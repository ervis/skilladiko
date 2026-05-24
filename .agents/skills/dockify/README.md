# /dockify

Skill for keeping a project's live documentation accurate as you work.

## Concept: Docs-as-Code for LLMs

Dockify is an implementation of **docs-as-code** designed for LLM consumption.

Docs-as-code is the practice of treating documentation like source code: version-controlled, reviewed in pull requests, and kept accurate with the system it describes. It is a well-established practice in software engineering.

Dockify extends this with an explicit LLM-consumption constraint: the `docs/` folder is a structured, retrievable knowledge base that agents read before starting work and update after completing it. This makes it a **living context source** — the LLM equivalent of a wiki that is always current at HEAD.

The key properties that make it work for LLMs:
- **Commit-accurate**: docs reflect the system as it exists at each commit, not at some past or aspirational state
- **Structured by type**: agents can navigate to the right folder without reading everything
- **Deletable when stale**: wrong docs are worse than no docs
- **Human-maintained**: agents assist, but humans own the knowledge

Related patterns: Architecture Decision Records (ADRs), living documentation, agent memory systems.

## Docs Location

Projects are free to keep their live documentation anywhere — `docs/`, `wiki/`, `handbook/`, or any other path. This skill works with any location as long as it knows where to look.

The skill reads the docs location from the project's `CLAUDE.md`:

```
DOCKIFY_DOCS_DIR=<path>   # e.g. DOCKIFY_DOCS_DIR=wiki
```

If not set, it assumes `docs/`. Wherever this skill says `<docs>`, substitute the actual path.

## Adopting Dockify in a New Project

1. Copy the `docs/` folder from this skill into your project root (or wherever you want your docs to live).
2. Add the contents of `claude-md-snippet.md` to your project's `CLAUDE.md`.
3. If your docs are not in `docs/`, set `DOCKIFY_DOCS_DIR=<your-path>` in `CLAUDE.md`.

That's it. Agents will now treat the docs folder as the canonical record and keep it current as they work.

## Documentation and Process Expectations

Treat the docs directory as the canonical, version-controlled record of the system.

At any commit, the docs should describe the system as it exists at that commit. If you change the system in a way that affects durable facts—such as architecture, behavior, invariants, usage, operations, or important design rationale—you must update the relevant docs in the same change.

Documentation is part of task completion. Do not treat it as optional polish. A task is not complete until the relevant canonical docs are updated, or there is a clear reason why no documentation update is needed.

## Artifact Roles

- `<docs>/` preserves canonical system truth
- `<docs>/task-logs/` preserves meaningful task execution history
- `<docs>/retrospectives/` preserves lessons learned that should improve future work

## Task Logs

For substantial tasks, keep a structured task log in `<docs>/task-logs/`.

Task logs should capture meaningful history, such as:
- important human clarifications
- the initial plan
- discoveries
- changes in direction
- key implementation decisions and reasons
- validations performed
- documentation updates made

Do not dump raw transcripts or low-signal step-by-step chatter into the repository.

## Retrospectives

When a task reveals reusable lessons about planning, execution, prompting, workflow, documentation, or agent behavior, record them in `<docs>/retrospectives/`.

Retrospectives should summarize what was learned and what should change in:
- prompts
- templates
- workflow
- docs
- agent instructions or skills

Not every task needs a retrospective. Use one when there are meaningful lessons worth preserving.

## Working Rule

When in doubt:
1. Update canonical docs if durable system truth changed
2. Add a task log if meaningful implementation history would otherwise be lost
3. Add a retrospective if the task revealed lessons that should improve future work

## When Asked to "Dockify"

When asked "please dockify branch changes", do this:

### 1. Resolve the Docs Directory

Check the project's `CLAUDE.md` for `DOCKIFY_DOCS_DIR`. If set, use that path. Otherwise use `docs/`.

### 2. Identify What Changed

Use this cheat-sheet to route changes:

| What changed | Where it goes |
|---|---|
| System structure, component map, data flow | `architecture/` |
| Component purpose, interface, invariants, failure modes | `components/` |
| Design rationale, tradeoffs, alternatives | `design/` |
| A non-obvious technical decision | `decisions/` |
| Workflow, standards, testing, review conventions | `engineering/` |
| Cross-component guarantees or safety properties | `invariants/` |
| Caveat, gotcha, debugging note, sharp edge | `notes/` |
| Runbook, deployment, migration, rollback | `operations/` |
| Release notes, behavior changes, rollout summary | `releases/` |
| Usage guide, setup, examples, API notes | `user/` |
| Domain term or canonical concept | `glossary/` |
| Task execution history (decisions, changes in direction) | `task-logs/` |
| Lessons for future planning or execution | `retrospectives/` |

If a change touches multiple areas, update all relevant subdirectories. For full detail on each folder, see `<docs>/README.md`.

### 3. Create or Update Docs

Write or update documents in the relevant subfolder. Use `<docs>/retrospectives/TEMPLATE.md` if the project has one, otherwise follow the structure in `<docs>/README.md`.

Keep it concise, meaningful, and durable.

### 4. For Substantial Tasks

If this was significant work:
- Create `<docs>/task-logs/TASK-NAME.md` capturing clarifications, discoveries, decisions
- Create `<docs>/retrospectives/TASK-NAME.md` if there are lessons for next time

### 5. Clear Commit Message

Explain what changed, why it mattered, which docs were updated.

## Example

```
User: "Please dockify branch changes"

Agent:
1. Checks CLAUDE.md for DOCKIFY_DOCS_DIR → not set, uses docs/
2. Reviews what was changed
3. Routes via docs/README.md → updates docs/engineering/
4. Commits with clear message
5. Reports: "✓ Docs updated in 2 locations"
```
