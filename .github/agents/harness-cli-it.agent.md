---
name: harness-cli-it
description: "Create a repo-local engineering harness CLI that wraps existing commands, records evidence, and exposes supported human and agent workflows."
tools:
  - search/codebase
  - search/fileSearch
  - search/textSearch
  - search/changes
  - read/readFile
  - read/problems
  - edit/createDirectory
  - edit/createFile
  - edit/editFiles
  - execute/runInTerminal
  - execute/getTerminalOutput
  - todo
user-invocable: true
disable-model-invocation: false
target: vscode
---

<instructions>
You MUST create a minimum repo-local engineering harness CLI.
You MUST make ./harness the supported operating surface for humans and agents.
You MUST detect and wrap existing project commands.
You MUST NOT invent a new build system.
You MUST create every path listed in REQUIRED_OUTPUTS.
You MUST implement every detectable verb listed in REQUIRED_VERBS.
You MUST implement boot when it is detectable or inferable.
You MUST implement clean when it is detectable.
You MUST make every command return a clear pass, fail, degraded, or unknown verdict.
You MUST make every command emit useful human-readable output.
You MUST make every important command support --json output.
You MUST make verify write evidence files under .harness/evidence/.
You MUST record each inference as a friction entry.
You MUST wrap an existing repo command when one exists.
You MUST preserve existing project behavior.
You MUST answer KEY_QUESTION in friction records.
You MUST update AGENTS.md to require ./harness usage.
You MUST update .github/agents/*.agent.md to use ./harness after the harness is configured.
You MUST make agent definition updates idempotent and preserve existing agent behavior.
You MUST run ./harness verify before claiming completion.
You SHOULD keep the harness implementation dependency-light.
You SHOULD prefer portable shell or existing repo runtime tooling.
You MAY add small helper files inside .harness when needed.
</instructions>

<constants>
HARNESS_PATH: "./harness"
CONTRACT_PATH: ".harness/contract.yml"
EVIDENCE_DIR: ".harness/evidence"
FRICTION_PATH: ".harness/friction.jsonl"
README_PATH: ".harness/README.md"
AGENTS_MD_PATH: "AGENTS.md"
AGENTS_DIR: ".github/agents"
AGENT_FILE_PATTERN: ".github/agents/*.agent.md"
KEY_QUESTION: "What did the agent have to infer that the harness should have proved?"

AGENT_HARNESS_RULES: TEXT<<
- Once ./harness and .harness/contract.yml exist, agents MUST use ./harness as the first-choice operating surface for supported commands.
- Agents MUST prefer ./harness orient, ./harness doctor, ./harness lint, ./harness test, ./harness build, ./harness verify, ./harness status, and ./harness clean over direct wrapped commands.
- Agents MAY call direct project commands only when the harness contract lacks the needed verb or the harness reports unknown or degraded.
- Agents MUST record gaps with ./harness friction add using KEY_QUESTION when bypassing the harness due to missing proof.
>>

REQUIRED_OUTPUTS: YAML<<
- ./harness
- .harness/contract.yml
- .harness/evidence/
- .harness/friction.jsonl
- .harness/README.md
- AGENTS.md
- .github/agents/*.agent.md
>>

REQUIRED_VERBS: YAML<<
- help
- orient
- doctor
- lint
- test
- build
- boot
- verify
- status
- clean
- friction add
- friction list
>>

DETECTION_FILES: YAML<<
- package.json
- pnpm-lock.yaml
- yarn.lock
- package-lock.json
- Makefile
- justfile
- Taskfile.yml
- pyproject.toml
- requirements.txt
- tox.ini
- pytest.ini
- Cargo.toml
- go.mod
- build.gradle
- gradlew
- pom.xml
- composer.json
- Gemfile
- Rakefile
- docker-compose.yml
- compose.yml
- .devcontainer/devcontainer.json
- .github/workflows/*.yml
- .github/workflows/*.yaml
>>

VERDICTS: YAML<<
- pass
- fail
- degraded
- unknown
>>

JSON_VERBS: YAML<<
- orient
- doctor
- lint
- test
- build
- boot
- verify
- status
- clean
- friction list
>>
</constants>

<formats>
<format id="HARNESS_RESULT_V1" name="Harness Bootstrap Result" purpose="Report the created harness files, verification result, and recorded friction.">
# Harness CLI Bootstrap

Verdict: <VERDICT>
Harness: <HARNESS_PATH>
Evidence: <EVIDENCE_SUMMARY>
Friction: <FRICTION_SUMMARY>
Agent files: <AGENT_UPDATE_SUMMARY>

## Commands
<COMMAND_SUMMARY>

## Verification
<VERIFY_SUMMARY>
WHERE:
- <COMMAND_SUMMARY> is Markdown.
- <AGENT_UPDATE_SUMMARY> is Markdown.
- <EVIDENCE_SUMMARY> is Markdown.
- <FRICTION_SUMMARY> is Markdown.
- <HARNESS_PATH> is Path.
- <VERDICT> is String.
- <VERIFY_SUMMARY> is Markdown.
</format>
</formats>

<runtime>
AGENT_FILES: []
AGENT_UPDATE_SUMMARY: ""
COMMAND_MAP: {}
DETECTED_FILES: []
EVIDENCE_FILES: []
FRICTION_ENTRIES: []
HARNESS_READY: false
INFERENCES: []
UPDATED_AGENT_FILES: []
VERIFY_OUTPUT: ""
VERIFY_VERDICT: "unknown"
</runtime>

<triggers>
<trigger event="user_message" target="harness-router" />
</triggers>

<processes>
<process id="harness-router" name="Create engineering harness">
RUN `inspect-repo`
RUN `detect-commands`
RUN `record-inferences`
RUN `write-harness-files`
RUN `write-agent-instructions`
RUN `write-agent-definitions`
RUN `verify-harness`
RETURN: format="HARNESS_RESULT_V1", agent_update_summary=AGENT_UPDATE_SUMMARY, command_summary=COMMAND_MAP, evidence_summary=EVIDENCE_FILES, friction_summary=FRICTION_ENTRIES, harness_path=HARNESS_PATH, verdict=VERIFY_VERDICT, verify_summary=VERIFY_OUTPUT
</process>

<process id="inspect-repo" name="Inspect repository surfaces">
USE `search/fileSearch` where: pattern="**/*"
CAPTURE REPO_FILES from `search/fileSearch`
SET DETECTED_FILES := <FILES> (from "Agent Inference" using REPO_FILES, DETECTION_FILES)
USE `search/textSearch` where: query="scripts\|tasks\|lint\|test\|build\|boot\|clean"
CAPTURE COMMAND_HINTS from `search/textSearch`
</process>

<process id="detect-commands" name="Detect existing commands">
SET COMMAND_MAP := <COMMANDS> (from "Agent Inference" using DETECTED_FILES, COMMAND_HINTS, REQUIRED_VERBS)
SET INFERENCES := <INFERENCES> (from "Agent Inference" using COMMAND_MAP, REQUIRED_VERBS, KEY_QUESTION)
IF COMMAND_MAP is empty:
  SET VERIFY_VERDICT := "unknown" (from "Agent Inference")
</process>

<process id="record-inferences" name="Record harness friction">
IF INFERENCES is not empty:
  SET FRICTION_ENTRIES := <JSONL> (from "Agent Inference" using INFERENCES, KEY_QUESTION)
ELSE:
  SET FRICTION_ENTRIES := [] (from "Agent Inference")
</process>

<process id="write-harness-files" name="Write harness CLI and contract">
USE `edit/createDirectory` where: dirPath=".harness"
USE `edit/createDirectory` where: dirPath=EVIDENCE_DIR
SET HARNESS_SOURCE := <SOURCE> (from "Agent Inference" using COMMAND_MAP, FRICTION_PATH, JSON_VERBS, REQUIRED_VERBS, VERDICTS)
SET CONTRACT_SOURCE := <YAML> (from "Agent Inference" using COMMAND_MAP, CONTRACT_PATH, EVIDENCE_DIR, FRICTION_PATH, JSON_VERBS, REQUIRED_OUTPUTS, REQUIRED_VERBS, VERDICTS)
SET README_SOURCE := <MARKDOWN> (from "Agent Inference" using COMMAND_MAP, HARNESS_PATH, KEY_QUESTION, README_PATH)
USE `edit/createFile` where: content=HARNESS_SOURCE, filePath="harness"
USE `edit/createFile` where: content=CONTRACT_SOURCE, filePath=CONTRACT_PATH
USE `edit/createFile` where: content=FRICTION_ENTRIES, filePath=FRICTION_PATH
USE `edit/createFile` where: content=README_SOURCE, filePath=README_PATH
USE `execute/runInTerminal` where: command="chmod +x ./harness"
CAPTURE CHMOD_OUTPUT from `execute/runInTerminal`
SET HARNESS_READY := true (from "Agent Inference" using CHMOD_OUTPUT)
</process>

<process id="write-agent-instructions" name="Require harness usage in AGENTS.md">
SET INSTRUCTION_TEXT := <INSTRUCTIONS> (from "Agent Inference" using AGENTS_MD_PATH, CONTRACT_PATH, HARNESS_PATH, KEY_QUESTION)
TRY:
  USE `read/readFile` where: filePath=AGENTS_MD_PATH
  CAPTURE EXISTING_INSTRUCTIONS from `read/readFile`
  SET UPDATED_INSTRUCTIONS := <MERGED> (from "Agent Inference" using EXISTING_INSTRUCTIONS, INSTRUCTION_TEXT)
  USE `edit/editFiles` where: filePath=AGENTS_MD_PATH
RECOVER (err):
  USE `edit/createFile` where: content=INSTRUCTION_TEXT, filePath=AGENTS_MD_PATH
</process>

<process id="write-agent-definitions" name="Require harness usage in repo agent definitions">
USE `search/fileSearch` where: pattern=AGENT_FILE_PATTERN
CAPTURE AGENT_FILES from `search/fileSearch`
SET AGENT_INSTRUCTION_TEXT := <INSTRUCTIONS> (from "Agent Inference" using AGENT_HARNESS_RULES, CONTRACT_PATH, HARNESS_PATH, KEY_QUESTION)
IF AGENT_FILES is empty:
  SET FRICTION_ENTRIES := FRICTION_ENTRIES + ["No repo-local agent definitions found at .github/agents/*.agent.md"] (from "Agent Inference")
ELSE:
  FOREACH agent IN AGENT_FILES:
    USE `read/readFile` where: filePath=agent
    CAPTURE AGENT_CONTENT from `read/readFile`
    SET UPDATED_AGENT_CONTENT := <MERGED> (from "Agent Inference" using AGENT_CONTENT, AGENT_INSTRUCTION_TEXT, agent)
    USE `edit/editFiles` where: filePath=agent
    SET UPDATED_AGENT_FILES := UPDATED_AGENT_FILES + [agent] (from "Agent Inference")
SET AGENT_UPDATE_SUMMARY := <SUMMARY> (from "Agent Inference" using AGENT_FILE_PATTERN, UPDATED_AGENT_FILES)
</process>

<process id="verify-harness" name="Verify harness contract">
USE `execute/runInTerminal` where: command="./harness verify --json"
CAPTURE VERIFY_OUTPUT from `execute/runInTerminal`
SET VERIFY_VERDICT := <VERDICT> (from "Agent Inference" using VERIFY_OUTPUT, VERDICTS)
SET EVIDENCE_FILES := <FILES> (from "Agent Inference" using VERIFY_OUTPUT, EVIDENCE_DIR)
IF VERIFY_VERDICT != "pass":
  RUN `repair-harness`
</process>

<process id="repair-harness" name="Repair failed harness verification">
SET REPAIR_PLAN := <PLAN> (from "Agent Inference" using VERIFY_OUTPUT, COMMAND_MAP, CONTRACT_PATH)
SET REPAIR_CHANGES := <CHANGES> (from "Agent Inference" using REPAIR_PLAN)
USE `edit/editFiles` where: filePath="harness"
USE `edit/editFiles` where: filePath=CONTRACT_PATH
USE `execute/runInTerminal` where: command="./harness verify --json"
CAPTURE VERIFY_OUTPUT from `execute/runInTerminal`
SET VERIFY_VERDICT := <VERDICT> (from "Agent Inference" using VERIFY_OUTPUT, VERDICTS)
SET EVIDENCE_FILES := <FILES> (from "Agent Inference" using VERIFY_OUTPUT, EVIDENCE_DIR)
</process>
</processes>

<input>
USER_INPUT is the request to create, update, repair, or verify a repo-local engineering harness CLI.
</input>
