import copy
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest
import uuid


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("foreman", ROOT / "scripts/foreman.py")
foreman = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(foreman)
SHA = "a" * 40


def mission():
    return {
        "version": 1, "id": "example-mission", "objective": "Deliver organization support",
        "base_ref": "origin/main", "max_workers": 4, "permission_mode": "interactive",
        "paused": False, "revision": 1, "revision_reason": "Initial graph",
        "conditions": [{"id": "OUT-1", "description": "Membership is delivered", "evidence": []}],
        "nodes": [{"issue": issue, "depends_on": [21] if issue == 23 else [],
                   "outcomes": ["OUT-1"], "priority": 0, "status": "queued", "blockers": []}
                  for issue in (21, 22, 23, 24)],
    }


def reservation(issue=21):
    return {"issue": issue, "worker": f"rpiv-{issue}", "mission": "example-mission"}


def event(name="WORKER_STARTED", phase="research", status="running", **extra):
    return {"request_id": str(uuid.uuid4()), "event": name, "phase": phase, "status": status, **extra}


class GraphTests(unittest.TestCase):
    def test_ready_parallel_and_dependency_gate(self):
        graph = mission()
        self.assertEqual(foreman.ready_set(graph, {}), [21, 22, 24])
        graph["nodes"][0]["status"] = "delivered"
        self.assertNotIn(23, foreman.ready_set(graph, {}))
        graph["nodes"][0].update(status="integrated", delivery={"pr": 45, "merge_commit": SHA, "base_commit": SHA})
        self.assertIn(23, foreman.ready_set(graph, {}))

    def test_capacity_counts_waiting_reservations(self):
        graph = mission()
        graph["max_workers"] = 2
        registry = {"21": reservation(), "22": reservation(22)}
        registry["21"]["state"] = "waiting"
        self.assertEqual(foreman.ready_set(graph, registry), [])
        graph["max_workers"] = 4
        self.assertEqual(foreman.ready_set(graph, registry), [24])

    def test_deterministic_priority(self):
        graph = mission()
        graph["nodes"][3]["priority"] = -1
        self.assertEqual(foreman.ready_set(graph, {}), [24, 21, 22])

    def test_invalid_graphs(self):
        for value in (0, -1, True, "4", 1.5):
            with self.subTest(capacity=value):
                graph = mission()
                graph["max_workers"] = value
                with self.assertRaisesRegex(ValueError, "positive integer"):
                    foreman.ready_set(graph, {})
        for dependencies in ([21], [999], [22, 22]):
            with self.subTest(dependencies=dependencies):
                graph = mission()
                graph["nodes"][0]["depends_on"] = dependencies
                with self.assertRaises(ValueError):
                    foreman.ready_set(graph, {})
        graph = mission()
        graph["nodes"][0]["depends_on"] = [23]
        with self.assertRaisesRegex(ValueError, "cycle"):
            foreman.ready_set(graph, {})

    def test_duplicate_and_missing_outcomes(self):
        graph = mission()
        graph["nodes"].append(copy.deepcopy(graph["nodes"][0]))
        with self.assertRaisesRegex(ValueError, "Duplicate issue"):
            foreman.validate_graph(graph)
        graph = mission()
        graph["nodes"][0]["outcomes"] = ["unknown"]
        with self.assertRaisesRegex(ValueError, "Unknown outcome"):
            foreman.validate_graph(graph)

    def test_parent_is_not_dependency(self):
        graph = mission()
        graph["nodes"][1]["parent"] = 21
        self.assertIn(22, foreman.ready_set(graph, {}))

    def test_completion_requires_integrated_outcomes_and_retired_workers(self):
        graph = mission()
        for node in graph["nodes"]:
            node.update(status="integrated", delivery={"pr": 45, "merge_commit": SHA, "base_commit": SHA})
        self.assertEqual(foreman.mission_report(graph, {})["status"], "blocked")
        graph["conditions"][0]["evidence"] = ["Merged PR 45, accepted mission behavior"]
        self.assertEqual(foreman.mission_report(graph, {})["status"], "complete")
        self.assertNotEqual(foreman.mission_report(graph, {"21": reservation()})["status"], "complete")
        graph["paused"] = True
        self.assertEqual(foreman.mission_report(graph, {})["status"], "paused")

    def test_cancelled_dependency_and_empty_mission_cannot_complete(self):
        graph = mission()
        graph["nodes"][0].update(status="cancelled", cancellation_reason="Outcome moved to issue 22")
        self.assertNotIn(23, foreman.ready_set(graph, {}))
        graph["nodes"] = []
        graph["conditions"][0]["evidence"] = ["Unsubstantiated success"]
        self.assertNotEqual(foreman.mission_report(graph, {})["status"], "complete")

    def test_registry_identity(self):
        graph = mission()
        with self.assertRaisesRegex(ValueError, "another mission"):
            foreman.ready_set(graph, {"21": {"issue": 21, "mission": "other"}})


class StateTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.item = self.root / "project/work-items/21-stable-title"
        self.item.mkdir(parents=True)
        self.env = {"RPIV_WORKER": "rpiv-21", "RPIV_ATTEMPT": str(uuid.uuid4())}

    def publish(self, request):
        return foreman.publish_state(self.root, 21, "feat/21-work", request, self.env)

    def test_four_phases_and_completion(self):
        self.publish(event())
        for phase in ("plan", "implement", "verify"):
            self.publish(event("PHASE_CHANGED", phase))
        complete = self.publish(event("COMPLETED", "verify", "done",
                                      evidence={"commit": SHA, "pr_url": "https://github.com/o/r/pull/45"}))
        self.assertEqual(complete["sequence"], 5)
        self.assertEqual(foreman.load(self.item / "state.json"), complete)
        self.assertEqual(len(foreman.read_history(self.item / "events.jsonl")), 5)
        with self.assertRaisesRegex(ValueError, "Terminal"):
            self.publish(event("PROGRESS", "verify"))

    def test_identical_replay_is_idempotent(self):
        request = event()
        first = self.publish(request)
        self.assertEqual(self.publish(request), first)
        changed = dict(request, reason="different")
        with self.assertRaisesRegex(ValueError, "Conflicting duplicate"):
            self.publish(changed)

    def test_recover_lagging_snapshot_but_reject_ahead(self):
        initial = self.publish(event())
        latest = self.publish(event("PHASE_CHANGED", "plan"))
        foreman.atomic(self.item / "state.json", initial)
        result = self.publish(event("PROGRESS", "plan"))
        self.assertEqual(result["sequence"], latest["sequence"] + 1)
        foreman.atomic(self.item / "state.json", dict(result, sequence=99))
        with self.assertRaisesRegex(ValueError, "Snapshot conflicts"):
            self.publish(event("PROGRESS", "plan"))

    def test_reject_truncated_and_out_of_order_history(self):
        self.publish(event())
        path = self.item / "events.jsonl"
        original = path.read_text()
        path.write_text(original.rstrip("\n"))
        with self.assertRaisesRegex(ValueError, "Truncated"):
            self.publish(event("PROGRESS"))
        record = json.loads(original)
        record["sequence"] = 5
        path.write_text(json.dumps(record) + "\n")
        with self.assertRaisesRegex(ValueError, "sequence"):
            self.publish(event("PROGRESS"))

    def test_invalid_transitions_and_completion(self):
        self.publish(event())
        with self.assertRaisesRegex(ValueError, "phase transition"):
            self.publish(event("PHASE_CHANGED", "verify"))
        with self.assertRaises(ValueError):
            self.publish(event("COMPLETED", "research", "done"))
        with self.assertRaisesRegex(ValueError, "Invalid phase"):
            self.publish(event("PHASE_CHANGED", "deliver"))

    def test_replanning_and_implementation_correction(self):
        self.publish(event())
        for phase in ("plan", "implement", "verify"):
            self.publish(event("PHASE_CHANGED", phase))
        self.publish(event("PHASE_CHANGED", "implement", reason="Code correction"))
        self.publish(event("PHASE_CHANGED", "plan", "replanning", reason="ADR conflict; owner Plan"))
        self.publish(event("PHASE_CHANGED", "implement"))

    def test_exception_events_require_reason(self):
        self.publish(event())
        for name, status in (("BLOCKED", "blocked"), ("NEEDS_DECISION", "needs-human"), ("FAILED", "failed")):
            with self.subTest(name=name):
                with self.assertRaisesRegex(ValueError, "reason"):
                    self.publish(event(name, status=status))
        self.publish(event("BLOCKED", status="blocked", reason="Depends on issue 19",
                           evidence={"category": "dependency", "owner": "foreman"}))

    def test_all_failure_categories_have_enforced_owners(self):
        self.publish(event())
        for category, owner in foreman.FAILURE_OWNERS.items():
            with self.subTest(category=category):
                record = self.publish(event("BLOCKED", status="blocked", reason="Fixture blocker",
                                            evidence={"category": category, "owner": owner}))
                self.assertEqual(record["evidence"]["owner"], owner)
                with self.assertRaisesRegex(ValueError, "responsible owner"):
                    self.publish(event("BLOCKED", status="blocked", reason="Wrong owner",
                                       evidence={"category": category, "owner": "unknown"}))

    def test_new_attempt_archives_history(self):
        self.publish(event())
        old = self.env["RPIV_ATTEMPT"]
        self.env["RPIV_ATTEMPT"] = str(uuid.uuid4())
        with self.assertRaisesRegex(ValueError, "explicit restart"):
            self.publish(event())
        restarted = self.publish(event(restart=True))
        self.assertEqual(restarted["sequence"], 1)
        self.assertTrue((self.item / ".attempts" / old / "events.jsonl").exists())

    def test_identity_and_canonical_path(self):
        self.env["RPIV_WORKER"] = "rpiv-22"
        with self.assertRaisesRegex(ValueError, "identity"):
            self.publish(event())
        self.env["RPIV_WORKER"] = "rpiv-21"
        (self.item.parent / "21-new-title").mkdir()
        with self.assertRaisesRegex(ValueError, "exactly one"):
            self.publish(event())

    def test_standalone_needs_no_controller(self):
        result = foreman.publish_state(self.root, 21, "feat/21-work", event(), {})
        self.assertEqual(result["worker"], "rpiv-21")
        self.assertEqual(foreman.inbox({}), [])

    def test_snapshot_and_explicit_standalone_restart(self):
        first = foreman.publish_state(self.root, 21, "feat/21-work", event(), {})
        self.assertEqual(foreman.read_snapshot(self.root, 21), first)
        resumed = foreman.publish_state(self.root, 21, "feat/21-work", event(restart=True), {})
        self.assertNotEqual(first["attempt"], resumed["attempt"])


class CommandTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="foreman fixture ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / "scripts").mkdir()
        shutil.copy(ROOT / "justfile", self.root / "justfile")
        shutil.copy(ROOT / "scripts/foreman.py", self.root / "scripts/foreman.py")
        foreman.atomic(self.root / ".foreman/mission.json", mission())
        binary = self.root / "bin"
        binary.mkdir()
        # All external processes are inert fixtures, including tmux and Copilot.
        stub = """#!/usr/bin/env python3
import json, os, pathlib, sys
root = pathlib.Path(os.environ["FIXTURE_ROOT"])
tool = pathlib.Path(sys.argv[0]).name
args = sys.argv[1:]
with (root / "calls.jsonl").open("a") as stream:
    stream.write(json.dumps({"tool": tool, "args": args, "cwd": os.getcwd(),
        "worker": os.environ.get("RPIV_WORKER"), "attempt": os.environ.get("RPIV_ATTEMPT")}) + "\\n")
if tool == "git":
    if args[:2] == ["rev-parse", "--show-toplevel"]: print(root)
    elif args[:2] == ["rev-parse", "--verify"]: print("a" * 40)
    elif args[:2] == ["branch", "--show-current"]: print("feat/21-work")
    elif args[:1] == ["show-ref"]: sys.exit(1)
    elif args[:2] == ["worktree", "add"]: pathlib.Path(args[4]).mkdir(parents=True)
    elif args[:1] == ["merge-base"] and os.environ.get("ANCESTOR") == "no": sys.exit(1)
elif tool == "tmux":
    if args[:1] == ["show-options"]: print(root)
    elif args[:1] == ["list-windows"]: print("foreman")
elif tool == "gh" and args[:2] == ["pr", "view"]:
    print(json.dumps({"state": os.environ.get("PR_STATE", "MERGED"), "mergeCommit": {"oid": "a"*40},
        "baseRefName": "main", "closingIssuesReferences": [{"number": 21}],
        "url": "https://github.com/o/r/pull/45"}))
"""
        for tool in ("git", "gh", "tmux", "copilot"):
            path = binary / tool
            path.write_text(stub)
            path.chmod(0o755)
        self.env = dict(os.environ, FIXTURE_ROOT=str(self.root), PATH=str(binary) + os.pathsep + os.environ["PATH"])
        for variable in ("FOREMAN_ROOT", "RPIV_WORKER", "RPIV_ATTEMPT"):
            self.env.pop(variable, None)

    def run_recipe(self, *args):
        return subprocess.run(["just", *args], cwd=self.root, env=self.env, text=True, capture_output=True)

    def calls(self):
        return [json.loads(line) for line in (self.root / "calls.jsonl").read_text().splitlines()]

    def test_launch_and_worker_bootstrap_are_compatible(self):
        launched = self.run_recipe("foreman-launch", "21")
        self.assertEqual(launched.returncode, 0, launched.stderr)
        calls = self.calls()
        windows = [call for call in calls if call["tool"] == "tmux" and call["args"][0] == "new-window"]
        self.assertEqual(windows[0]["args"][-1], "just foreman-worker 21")
        worker = self.run_recipe("foreman-worker", "21")
        self.assertEqual(worker.returncode, 0, worker.stderr)
        cli = [call for call in self.calls() if call["tool"] == "copilot"][-1]
        self.assertEqual(cli["cwd"], str(self.root / ".trees/issue-21"))
        self.assertEqual(cli["worker"], "rpiv-21")
        self.assertNotIn("--yolo", cli["args"])
        self.assertEqual(cli["args"][:2], ["--agent", "rpiv"])
        prompt = cli["args"][cli["args"].index("-p") + 1]
        for field in ("ISSUE_NUMBER: 21", "WORKER_ID: rpiv-21", "ATTEMPT_ID:", "WORKTREE:", "FOREMAN_ROOT:"):
            self.assertIn(field, prompt)
        again = self.run_recipe("foreman-launch", "21")
        self.assertNotEqual(again.returncode, 0)
        self.assertEqual(len(foreman.load(self.root / ".foreman/registry.json")), 1)

    def test_permissions_need_matching_explicit_launch(self):
        graph = mission()
        graph["permission_mode"] = "yolo"
        foreman.atomic(self.root / ".foreman/mission.json", graph)
        denied = self.run_recipe("foreman-launch", "21")
        self.assertNotEqual(denied.returncode, 0)
        self.assertFalse((self.root / ".foreman/registry.json").exists())
        allowed = self.run_recipe("foreman-launch", "21", "yolo")
        self.assertEqual(allowed.returncode, 0, allowed.stderr)

    def test_shell_metacharacters_are_rejected_as_identity(self):
        denied = self.run_recipe("foreman-launch", "21; touch INJECTED")
        self.assertNotEqual(denied.returncode, 0)
        self.assertFalse((self.root / "INJECTED").exists())

    def test_send_and_receive_preserve_message_as_data(self):
        self.assertEqual(self.run_recipe("foreman-launch", "21").returncode, 0)
        reason = "$(touch INJECTED); 'quoted' \"message\""
        foreman.atomic(self.root / "message.json", {"command": "pause", "reason": reason})
        result = self.run_recipe("foreman-send", "21", "message.json")
        self.assertEqual(result.returncode, 0, result.stderr)
        worker = foreman.load(self.root / ".foreman/registry.json")["21"]
        messages = foreman.inbox({"FOREMAN_ROOT": str(self.root),
                                  "RPIV_WORKER": "rpiv-21", "RPIV_ATTEMPT": worker["attempt"]})
        self.assertEqual(messages[0]["reason"], reason)
        self.assertFalse((self.root / "INJECTED").exists())
        self.assertFalse(any("send-keys" in call["args"] for call in self.calls()))

    def test_existing_worktree_is_not_overwritten(self):
        tree = self.root / ".trees/issue-21"
        tree.mkdir(parents=True)
        (tree / "user-work").write_text("preserve")
        result = self.run_recipe("foreman-launch", "21")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((tree / "user-work").read_text(), "preserve")

    def test_delivery_requires_merged_linked_available_pr(self):
        result = self.run_recipe("foreman-delivery", "21", "45")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("merge_commit=" + SHA, result.stdout)
        self.env["PR_STATE"] = "OPEN"
        self.assertNotEqual(self.run_recipe("foreman-delivery", "21", "45").returncode, 0)
        self.env["PR_STATE"] = "MERGED"
        self.env["ANCESTOR"] = "no"
        self.assertNotEqual(self.run_recipe("foreman-delivery", "21", "45").returncode, 0)
        self.env.pop("ANCESTOR")
        self.assertNotEqual(self.run_recipe("foreman-delivery", "22", "45").returncode, 0)

    def test_issue_and_pr_titles_are_data(self):
        title = "'; touch INJECTED; $(uname)"
        foreman.atomic(self.root / "request.json", {"title": title, "body": "bounded criteria"})
        for recipe in ("issue-create", "rpiv-create-pr"):
            result = self.run_recipe(recipe, "request.json")
            self.assertEqual(result.returncode, 0, result.stderr)
        commands = [call for call in self.calls() if call["tool"] == "gh"]
        self.assertTrue(all(call["args"][call["args"].index("--title") + 1] == title for call in commands))
        self.assertFalse((self.root / "INJECTED").exists())


class AgentContractTests(unittest.TestCase):
    def test_aps_sections_tools_and_process_references(self):
        for name in ("foreman", "rpiv", "rpiv-research", "rpiv-planner", "rpiv-implementer",
                     "rpiv-verifier", "issue-generator"):
            with self.subTest(agent=name):
                text = (ROOT / f".github/agents/{name}.agent.md").read_text()
                header, body = text.split("---", 2)[1:]
                self.assertNotIn("target: vscode", header)
                self.assertRegex(header, r'description: "[^\n]+"')
                tools = set(re.findall(r"^  - ([a-z_]+)$", header, re.M))
                used = set(re.findall(r"USE `([^`]+)`", body))
                self.assertTrue(used <= tools, f"undeclared tools: {used - tools}")
                sections = ("instructions", "constants", "formats", "runtime", "triggers", "processes", "input")
                positions = []
                for section in sections:
                    self.assertEqual(body.count(f"<{section}>"), 1)
                    self.assertEqual(body.count(f"</{section}>"), 1)
                    positions.append(body.index(f"<{section}>"))
                self.assertEqual(positions, sorted(positions))
                processes = set(re.findall(r'<process id="([^"]+)"', body))
                targets = set(re.findall(r'RUN `([^`]+)`|target="([^"]+)"', body))
                for target in targets:
                    self.assertIn(next(value for value in target if value), processes)
                self.assertNotIn("\t", body)
                self.assertNotRegex(body, r"<[A-Z0-9_]{65,}>")

    def test_foreman_commands_exist_and_four_stages_remain(self):
        text = (ROOT / ".github/agents/foreman.agent.md").read_text()
        recipes = set(re.findall(r"^([a-z][a-z-]+)(?: [^:\n]*)?:", (ROOT / "justfile").read_text(), re.M))
        references = set(re.findall(r"just ([a-z][a-z-]+)", text))
        self.assertTrue(references <= recipes, references - recipes)
        stages = (ROOT / "AGENTS.md").read_text().split("PIPELINE_STAGES: YAML<<", 1)[1].split(">>", 1)[0]
        self.assertEqual(re.findall(r"^- id: (.+)$", stages, re.M), ["research", "plan", "implement", "verify"])
        self.assertNotIn("send-keys", (ROOT / "justfile").read_text())

    def test_cross_surface_discovery_and_ignores(self):
        for name in ("README.md", "AGENTS.md", "LLM.txt", "docs/foreman.md",
                     "CONTRIBUTING.md", "project/architecture/ADR/DECISION-LOG.md"):
            self.assertIn("foreman", (ROOT / name).read_text().lower())
        ignored = (ROOT / ".gitignore").read_text()
        for path in ("/.trees/", "/.foreman/*", "/project/work-items/*/state.json",
                     "/project/work-items/*/events.jsonl"):
            self.assertIn(path, ignored)


if __name__ == "__main__":
    unittest.main()
