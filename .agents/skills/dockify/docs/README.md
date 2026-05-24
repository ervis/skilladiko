# Documentation

This folder contains the project's version-controlled documentation.

Its job is to explain the system as it exists at each commit. The docs should help people and LLMs understand what the system does, how it works, why it was designed this way, how it is used, and what constraints, invariants, operational details, implementation history, and learnings matter.

## Intent

The `docs/` folder is the canonical place for durable system knowledge.

If you check out a commit and open `docs/`, you should be able to understand the facts of the system as they were true at that commit.

Use `docs/` to answer questions like:

- What does this system contain?
- How do the main components fit together?
- Why was a given approach chosen?
- What invariants and guarantees must hold?
- How should the system be used?
- What operational constraints or caveats matter?
- How do we build, test, review, and evolve it?
- What changed and why?
- What did we learn during implementation that should improve future work?

In general:

- **code** shows what the system does
- **issues** track work and scope
- **PRs** show the exact changes and review discussion
- **docs** preserve the durable understanding of the system

## Commit Accuracy

Documentation should evolve with the code.

At any commit, the docs should describe the system as it existed at that point in time.

Issues, plans, and design docs are task-scoped working artifacts. The `docs/` directory is the canonical record of the system. When a task changes the system in a durable way, the agent must update the relevant docs in the same change so `docs/` stays accurate for that commit.

A task is not complete until the relevant canonical documentation has been updated or a clear reason is given for why no update is needed.

## Folder Structure

### `architecture/`
System-level structure and component relationships.

Use this for:
- system overviews
- component maps
- data flow
- boundaries and responsibilities
- how major parts fit together

### `components/`
Documentation for major components, modules, or subsystems.

Use this for:
- component purpose
- responsibilities
- interfaces
- dependencies
- lifecycle or state behavior
- invariants and guarantees
- failure modes and caveats
- extension points

### `design/`
Design docs for important changes, features, or architectural decisions.

Use this for:
- design rationale
- tradeoffs and alternatives
- implementation approach
- constraints and decision records
- design updates when implementation changes materially

### `decisions/`
Concise records of important technical or architectural decisions.

Use this for:
- durable decision summaries
- non-obvious constraints
- alternatives considered
- reasons a direction was chosen

### `engineering/`
Engineering process, conventions, and quality standards.

Use this for:
- workflow and ways of working
- testing strategy
- coding standards
- code review expectations
- documentation standards
- reliability and rollout expectations

### `invariants/`
System-wide invariants, guarantees, and assumptions that must remain true as the system evolves.

Use this for:
- cross-component invariants
- contract guarantees
- ordering assumptions
- idempotency or consistency guarantees
- safety properties
- compatibility expectations that should not be broken accidentally

### `notes/`
Focused engineering notes that do not need a full design doc.

Use this for:
- caveats
- debugging notes
- gotchas
- temporary constraints
- implementation details worth preserving
- local reasoning that would otherwise become tribal knowledge

### `operations/`
Operational and support documentation.

Use this for:
- runbooks
- deployment notes
- migration steps
- troubleshooting guides
- rollback guidance
- observability notes
- failure mode guidance

### `releases/`
Release-facing summaries for meaningful shipped changes.

Use this for:
- release notes
- notable behavior changes
- rollout notes
- migration summaries
- cross-ticket summaries for shipped work

### `task-logs/`
Structured logs for meaningful tasks.

Use this for:
- important human clarifications during the task
- implementation decisions and the reasons behind them
- changes in direction from the original plan
- discoveries, failed attempts, and rejected approaches
- validations that were run
- updates made to canonical docs
- information that would otherwise be lost in squash merges

Task logs are the working history of a task. They should be selective and structured, not full raw transcripts.

### `retrospectives/`
Retrospectives and implementation learnings.

Use this for:
- postmortems for difficult tasks
- what went well and what did not
- where the implementation plan was weak
- what back-and-forth was needed to get to the right solution
- patterns in agent mistakes or confusion
- improvements to prompts, workflow, templates, docs, or agent guidance

Retrospectives summarize lessons from the task log and the final outcome. The goal is to capture lessons that improve future implementation quality and improve the agent's instructions, markdown files, and skills.

### `user/`
Documentation for users, consumers, or developers using the system.

Use this for:
- usage guides
- setup instructions
- examples
- API usage notes
- workflow guides

### `glossary/`
Canonical terminology and domain concepts.

Use this for:
- domain language
- core concepts
- canonical naming
- terms that need clear definitions

## What Counts as a Substantial Task

A task is substantial if it:
- touches more than one file
- changes behavior or architecture
- would leave a future maintainer confused about why a decision was made

Substantial tasks warrant a task log. Add a retrospective only when there are meaningful lessons for future work.

## What Is Worth Tracking

Track information that improves understanding, implementation quality, operational safety, or long-term maintainability.

This commonly includes:
- architecture and component boundaries
- design rationale and tradeoffs
- major component behavior and responsibilities
- invariants and guarantees
- engineering workflow and standards
- testing strategy and expectations
- coding and review standards
- operational procedures and failure modes
- migrations and compatibility constraints
- user-facing usage guidance
- release-impacting changes
- glossary and domain language
- known caveats, limits, and sharp edges
- task history that would otherwise be lost
- retrospective learnings about planning quality, execution quality, and agent behavior

## When to Update Documentation

Update documentation when a change affects:

- architecture or component boundaries
- external interfaces or behavior
- invariants or guarantees
- setup, configuration, or usage flows
- operational procedures
- rollout or migration requirements
- important design rationale
- engineering conventions or quality expectations
- known caveats, limitations, or constraints
- the expected behavior of a major component
- lessons that should improve future planning, prompting, or execution

If a future maintainer or LLM would be misled without the update, the docs should be updated.

## Document Conventions

Prefer documents that are easy to skim, search, and maintain.

When useful, structure documents with:
- summary
- context
- main content
- decisions or tradeoffs
- invariants or guarantees when relevant
- references to code, issues, PRs, or related docs

For substantial documents, it is helpful to include:
- status: draft / active / historical
- last updated date
- related issue or PR
- owner or maintainers when relevant

For task logs, it is useful to capture:
- the task goal
- important human clarifications
- the initial plan
- discoveries and changes in direction
- decisions and reasons
- validations that were run
- docs that were updated

For retrospectives, it is useful to capture:
- what the task was trying to achieve
- where the original plan was right or wrong
- what iterations were needed to reach the correct implementation
- what the agent missed, misunderstood, or did well
- what should change in prompts, templates, docs, or workflow

Use links instead of repeating large amounts of information across documents.

## Documentation Principles

### 1. Keep docs close to reality
Docs should reflect the implemented system, not just the original plan.

### 2. Prefer durable knowledge
Document information that helps future people and LLMs understand:
- what exists
- how it works
- why decisions were made
- what invariants must hold
- where the sharp edges are
- how implementation and planning can improve over time

### 3. Preserve meaningful history
When important task context would otherwise be lost, record it in a task log.

Use retrospectives to summarize the lessons from that history.

### 4. Avoid duplication without purpose
Do not repeat the same information across documents unless there is a clear reason.

Prefer linking to the document that holds the real detail.

### 5. Write for retrieval
Docs should be easy to search, skim, and understand.

Prefer:
- clear titles
- explicit headings
- concrete language
- stable terminology

### 6. Keep the structure high-signal
Not every change needs a new design doc, task log, release note, or retrospective.

Create documentation when it adds durable explanatory value.

### 7. Delete stale docs
When a document no longer reflects the system, delete it. Stale docs are worse than no docs — they mislead future readers and LLMs.

The current state of `docs/` should always reflect the current state of the system. Nothing more.

## Relationship to Other Artifacts

- **Issue**: tracks the problem, scope, tasks, and acceptance criteria
- **Design doc**: explains the planned and final technical approach
- **Task log**: records the meaningful execution history of a task
- **Pull request**: records the exact code change and review discussion
- **Docs**: preserve the canonical understanding of the system at each commit
- **Retrospective**: captures lessons from planning and implementation so future work can improve

## Efficiency Patterns for LLM Consumption

These are optional practices that make `docs/` faster and cheaper for agents to navigate.

### INDEX.md — one-line map of all docs

Maintain a `docs/INDEX.md` with one line per document: filename and a short description of what it covers. Agents can read this single file to find relevant docs without reading everything.

```markdown
# Docs Index

- [architecture/overview.md](architecture/overview.md) — system components and how they connect
- [components/auth.md](components/auth.md) — authentication module: interface, invariants, failure modes
- [decisions/use-postgres.md](decisions/use-postgres.md) — why Postgres over alternatives
- [invariants/ordering.md](invariants/ordering.md) — event ordering guarantees
```

Update `INDEX.md` whenever a doc is added, renamed, or deleted.

### Keep docs short and factual

Long narrative prose is expensive to load and hard to search. Prefer:
- bullet points over paragraphs
- concrete facts over explanations
- explicit headings that make grepping reliable

### One concept per file

Split large docs rather than growing them. A focused file is easier to retrieve and replace without touching unrelated content.

### Stable filenames

LLMs and humans build mental maps around filenames. Rename only when the old name is genuinely misleading. When you do rename, update `INDEX.md` and any cross-links in the same commit.

## What Not to Optimize For

Avoid:
- documenting trivial changes with no lasting explanatory value
- duplicating code that is already obvious
- writing status-heavy documents that do not improve understanding
- creating many small docs where one clear doc would be better
- writing task logs or retrospectives for routine work with no meaningful lessons
- dumping full raw chat transcripts into the repository

## Maintenance Rule

When a change materially affects architecture, design rationale, component behavior, invariants, usage, engineering standards, operations, or release behavior, update the relevant documentation in `docs/` in the same change.

For substantial tasks, keep a structured task log in `docs/task-logs/` so important implementation history is not lost.

When a task reveals lessons that should improve future planning, prompting, implementation quality, or agent behavior, record them in `docs/retrospectives/`.

The goal is for this folder to remain the best source of project understanding for any given commit.
