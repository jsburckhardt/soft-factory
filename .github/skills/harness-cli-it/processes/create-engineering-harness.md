<instructions>
You MUST create a minimum repo-local engineering harness CLI.
You MUST make ./harness the supported operating surface for humans and agents.
You MUST detect and wrap existing project commands.
You MUST NOT invent a new build system.
You MUST create every path listed in REQUIRED_OUTPUTS.
You MUST implement every detectable verb listed in REQUIRED_VERBS.
You MUST implement boot when it is detectable or inferable.
You MUST implement clean when it is detectable.
You MUST make every command return a clear verdict.
You MUST make every command emit useful human-readable output.
You MUST make every important command support --json output.
You MUST make verify write evidence files under .harness/evidence/.
You MUST record each inference as a friction entry.
You MUST wrap an existing repo command when one exists.
You MUST preserve existing project behavior.
You MUST answer KEY_QUESTION in friction records.
You MUST update AGENTS.md to require ./harness usage.
You MUST update .github/agents/*.agent.md after the harness is configured.
You MUST make agent definition updates idempotent.
You MUST run ./harness verify before claiming completion.
You SHOULD keep the harness implementation dependency-light.
You SHOULD prefer portable shell or existing repo runtime tooling.
You MAY add small helper files inside .harness when needed.
</instructions>

<constants>
AGENTS_DIR: ".github/agents"
AGENTS_MD_PATH: "AGENTS.md"
AGENT_FILE_PATTERN: "*.agent.md"
COMMAND_HINT_PATTERN: "scripts|tasks|lint|test|build|boot|clean"
CONTRACT_PATH: ".harness/contract.yml"
EVIDENCE_DIR: ".harness/evidence"
FRICTION_PATH: ".harness/friction.jsonl"
HARNESS_PATH: "./harness"
KEY_QUESTION: "What did the agent have to infer that the harness should have proved?"
README_PATH: ".harness/README.md"

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
- <AGENT_UPDATE_SUMMARY> is Markdown.
- <COMMAND_SUMMARY> is Markdown.
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
<trigger event="user_message" target="create-engineering-harness" />
</triggers>

<processes>
<process id="create-engineering-harness" name="Create Engineering Harness">
RUN `inspect-repo`
RUN `detect-commands`
RUN `record-inferences`
RUN `write-harness-files`
RUN `write-agent-instructions`
RUN `write-agent-definitions`
RUN `verify-harness`
RETURN: format="HARNESS_RESULT_V1", agent_update_summary=AGENT_UPDATE_SUMMARY, command_summary=COMMAND_MAP, evidence_summary=EVIDENCE_FILES, friction_summary=FRICTION_ENTRIES, harness_path=HARNESS_PATH, verdict=VERIFY_VERDICT, verify_summary=VERIFY_OUTPUT
</process>

<process id="inspect-repo" name="Inspect Repository Surfaces">
USE `Glob` where: path=".", pattern="**/*"
CAPTURE REPO_FILES from `Glob`
SET DETECTED_FILES := <FILES> (from "Agent Inference" using REPO_FILES, DETECTION_FILES)
USE `Grep` where: path=".", pattern=COMMAND_HINT_PATTERN
CAPTURE COMMAND_HINTS from `Grep`
</process>

<process id="detect-commands" name="Detect Existing Commands">
SET COMMAND_MAP := <COMMANDS> (from "Agent Inference" using DETECTED_FILES, COMMAND_HINTS, REQUIRED_VERBS)
SET INFERENCES := <INFERENCES> (from "Agent Inference" using COMMAND_MAP, REQUIRED_VERBS, KEY_QUESTION)
IF COMMAND_MAP is empty:
  SET VERIFY_VERDICT := "unknown" (from "Agent Inference")
</process>

<process id="record-inferences" name="Record Harness Friction">
IF INFERENCES is not empty:
  SET FRICTION_ENTRIES := <JSONL> (from "Agent Inference" using INFERENCES, KEY_QUESTION)
ELSE:
  SET FRICTION_ENTRIES := [] (from "Agent Inference")
</process>

<process id="write-harness-files" name="Write Harness CLI and Contract">
USE `Shell` where: command="mkdir -p .harness .harness/evidence"
SET HARNESS_SOURCE := <SOURCE> (from "Agent Inference" using COMMAND_MAP, FRICTION_PATH, JSON_VERBS, REQUIRED_VERBS, VERDICTS)
SET CONTRACT_SOURCE := <YAML> (from "Agent Inference" using COMMAND_MAP, CONTRACT_PATH, EVIDENCE_DIR, FRICTION_PATH, JSON_VERBS, REQUIRED_OUTPUTS, REQUIRED_VERBS, VERDICTS)
SET README_SOURCE := <MARKDOWN> (from "Agent Inference" using COMMAND_MAP, HARNESS_PATH, KEY_QUESTION, README_PATH)
USE `Write` where: content=HARNESS_SOURCE, path="harness"
USE `Write` where: content=CONTRACT_SOURCE, path=CONTRACT_PATH
USE `Write` where: content=FRICTION_ENTRIES, path=FRICTION_PATH
USE `Write` where: content=README_SOURCE, path=README_PATH
USE `Shell` where: command="chmod +x ./harness"
CAPTURE CHMOD_OUTPUT from `Shell`
SET HARNESS_READY := true (from "Agent Inference" using CHMOD_OUTPUT)
</process>

<process id="write-agent-instructions" name="Require Harness Usage in AGENTS.md">
SET INSTRUCTION_TEXT := <INSTRUCTIONS> (from "Agent Inference" using AGENTS_MD_PATH, CONTRACT_PATH, HARNESS_PATH, KEY_QUESTION)
TRY:
  USE `Read` where: path=AGENTS_MD_PATH
  CAPTURE EXISTING_INSTRUCTIONS from `Read`
  SET UPDATED_INSTRUCTIONS := <MERGED> (from "Agent Inference" using EXISTING_INSTRUCTIONS, INSTRUCTION_TEXT)
  USE `Write` where: content=UPDATED_INSTRUCTIONS, path=AGENTS_MD_PATH
RECOVER (err):
  USE `Write` where: content=INSTRUCTION_TEXT, path=AGENTS_MD_PATH
</process>

<process id="write-agent-definitions" name="Require Harness Usage in Repo Agent Definitions">
USE `Glob` where: path=AGENTS_DIR, pattern=AGENT_FILE_PATTERN
CAPTURE AGENT_FILES from `Glob`
SET AGENT_INSTRUCTION_TEXT := <INSTRUCTIONS> (from "Agent Inference" using AGENT_HARNESS_RULES, CONTRACT_PATH, HARNESS_PATH, KEY_QUESTION)
IF AGENT_FILES is empty:
  SET FRICTION_ENTRIES := FRICTION_ENTRIES + ["No repo-local agent definitions found at .github/agents/*.agent.md"] (from "Agent Inference")
ELSE:
  FOREACH agent IN AGENT_FILES:
    USE `Read` where: path=agent
    CAPTURE AGENT_CONTENT from `Read`
    SET UPDATED_AGENT_CONTENT := <MERGED> (from "Agent Inference" using AGENT_CONTENT, AGENT_INSTRUCTION_TEXT, agent)
    USE `Write` where: content=UPDATED_AGENT_CONTENT, path=agent
    SET UPDATED_AGENT_FILES := UPDATED_AGENT_FILES + [agent] (from "Agent Inference")
SET AGENT_UPDATE_SUMMARY := <SUMMARY> (from "Agent Inference" using AGENT_FILE_PATTERN, UPDATED_AGENT_FILES)
</process>

<process id="verify-harness" name="Verify Harness Contract">
USE `Shell` where: command="./harness verify --json"
CAPTURE VERIFY_OUTPUT from `Shell`
SET VERIFY_VERDICT := <VERDICT> (from "Agent Inference" using VERIFY_OUTPUT, VERDICTS)
SET EVIDENCE_FILES := <FILES> (from "Agent Inference" using VERIFY_OUTPUT, EVIDENCE_DIR)
IF VERIFY_VERDICT != "pass":
  RUN `repair-harness`
</process>

<process id="repair-harness" name="Repair Failed Harness Verification">
SET REPAIR_PLAN := <PLAN> (from "Agent Inference" using VERIFY_OUTPUT, COMMAND_MAP, CONTRACT_PATH)
SET REPAIRED_HARNESS_SOURCE := <SOURCE> (from "Agent Inference" using REPAIR_PLAN)
SET REPAIRED_CONTRACT_SOURCE := <YAML> (from "Agent Inference" using REPAIR_PLAN)
USE `Write` where: content=REPAIRED_HARNESS_SOURCE, path="harness"
USE `Write` where: content=REPAIRED_CONTRACT_SOURCE, path=CONTRACT_PATH
USE `Shell` where: command="./harness verify --json"
CAPTURE VERIFY_OUTPUT from `Shell`
SET VERIFY_VERDICT := <VERDICT> (from "Agent Inference" using VERIFY_OUTPUT, VERDICTS)
SET EVIDENCE_FILES := <FILES> (from "Agent Inference" using VERIFY_OUTPUT, EVIDENCE_DIR)
</process>
</processes>

<input>
USER_INPUT is the request to create, update, repair, or verify a repo-local engineering harness CLI.
</input>
