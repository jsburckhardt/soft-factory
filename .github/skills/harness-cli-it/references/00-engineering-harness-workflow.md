# 00 Engineering Harness Workflow

This reference defines the required behavior for creating and maintaining a repo-local engineering harness CLI. The workflow is intended for agents that need a stable project operating surface before running build, test, lint, status, cleanup, or verification work.

## Scope

The agent MUST create a minimum repo-local harness at `./harness`.

The agent MUST make `./harness` the supported operating surface for humans and agents.

The agent MUST preserve existing project behavior.

The agent MUST wrap existing project commands when those commands exist.

The agent MUST NOT invent a new build system.

The agent SHOULD keep the implementation dependency-light.

The agent SHOULD prefer portable shell or existing repo runtime tooling.

## Required outputs

The workflow MUST create or update the following outputs:

| Output | Purpose |
|--------|---------|
| `./harness` | Repo-local CLI entrypoint. |
| `.harness/contract.yml` | Machine-readable command contract. |
| `.harness/evidence/` | Verification evidence directory. |
| `.harness/friction.jsonl` | Inference and harness-gap record. |
| `.harness/README.md` | Human-readable harness usage guide. |
| `AGENTS.md` | Repository-level agent instructions requiring harness usage. |
| `.github/agents/*.agent.md` | Repo-local agent definitions updated to prefer the harness. |

## Command detection

The agent MUST inspect existing repository surfaces before writing the harness.

The agent MUST detect command sources from package manifests, task files, build files, workflow files, devcontainer configuration, and existing project documentation.

The agent MUST detect and wrap the following verbs when supported by existing project commands:

| Verb | Requirement |
|------|-------------|
| `help` | MUST exist. |
| `orient` | MUST exist. |
| `doctor` | MUST exist. |
| `lint` | MUST wrap existing lint behavior when detectable. |
| `test` | MUST wrap existing test behavior when detectable. |
| `build` | MUST wrap existing build behavior when detectable. |
| `boot` | MUST exist when detectable or inferable. |
| `verify` | MUST exist and coordinate relevant checks. |
| `status` | MUST exist. |
| `clean` | MUST exist when detectable. |
| `friction add` | MUST append a friction record. |
| `friction list` | MUST list friction records. |

The agent MUST mark unsupported or undetected verbs as `unknown` rather than pretending success.

## Verdicts and output

Every harness command MUST return one of `pass`, `fail`, `degraded`, or `unknown`.

Every command MUST emit useful human-readable output.

Important commands SHOULD support `--json` output.

The `verify` command MUST write evidence under `.harness/evidence/`.

The `verify` command MUST report generated evidence paths when possible.

## Friction records

The agent MUST record each inference as a friction entry.

Every friction entry MUST answer: "What did the agent have to infer that the harness should have proved?"

The agent MUST use friction records for missing command proof, ambiguous command mapping, unknown verification coverage, and direct-command bypasses.

The agent SHOULD store friction records as JSON Lines in `.harness/friction.jsonl`.

## Agent adoption

The agent MUST update `AGENTS.md` to require `./harness` usage after the harness is configured.

The agent MUST update `.github/agents/*.agent.md` to use `./harness` after the harness is configured.

Agent definition updates MUST be idempotent.

Agent definition updates MUST preserve existing agent behavior.

Agents MUST use `./harness` as the first-choice operating surface when `./harness` and `.harness/contract.yml` exist.

Agents MAY call direct project commands only when the harness contract lacks the needed verb or reports `unknown` or `degraded`.

Agents MUST record gaps with `./harness friction add` when bypassing the harness due to missing proof.

## Verification and repair

The agent MUST run `./harness verify --json` before claiming completion.

If verification does not report `pass`, the agent MUST attempt a focused repair of the harness and contract.

After repair, the agent MUST rerun `./harness verify --json`.

The agent MUST report a final harness bootstrap result with the verdict, command map, evidence summary, friction summary, agent-file update summary, and verification summary.

## Safety and privacy

The agent MUST NOT commit secrets, tokens, credentials, or private environment values into harness files, evidence, friction records, or summaries.

The agent MUST redact credential-like values encountered while detecting commands or debugging verification.

The agent MUST keep generated evidence useful without dumping unrelated source or sensitive command output.
