# Foreman project data

Foreman is the APS agent in `.github/agents/foreman.agent.md`, not a runtime
application in this directory.

Bootstrap/onboarding creates the consuming project's non-secret `project.json`
profile after its stack and commands are confirmed. That file is committed.
Worker execution is disabled unless the project explicitly configures it.

Enabling managed execution approves `--yolo` for managed launches/resumptions
and configures Foreman's PR review operations.

The agent maintains local `context/`, `mission.json`, `registry.json`, issue
request/results, `reviews/`, and `inbox/` data using host file tools. These files are
Git-ignored; retain them for mission resume. They do not contain executable
configuration or duplicate a backlog service.

See [the project initialization and Foreman guide](../docs/foreman.md).
