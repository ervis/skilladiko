## Dockify — Live Documentation Rule

Before starting any task, read the relevant docs to understand the current state of the system. After completing any task that changes durable system facts — architecture, behavior, invariants, usage, operations, or design rationale — update the relevant docs in the same change.

The project's docs live at the path set by `DOCKIFY_DOCS_DIR` in this file (default: `docs/`).

For folder routing, see `<docs>/README.md`.

For substantial tasks, also create:
- `<docs>/task-logs/<TASK-NAME>.md` — important clarifications, decisions, changes in direction
- `<docs>/retrospectives/<TASK-NAME>.md` — lessons that should improve future planning or execution

If the task touches multiple areas, update all relevant subdirectories in the same commit.

Documentation is part of task completion. A task is not done until the relevant canonical docs are updated, or there is a clear reason no update is needed.

For the full dockify pattern, see `.agents/skills/dockify/README.md`.
