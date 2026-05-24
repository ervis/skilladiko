# Decisions

This folder contains concise records of important technical and architectural decisions.

## What Belongs Here

Use this folder for decisions that are:
- non-obvious — a future reader would wonder "why did they do it this way?"
- durable — the decision shapes the system for a meaningful period of time
- worth preserving — alternatives were considered and rejected for specific reasons

Trivial decisions do not need a record. Use one when the reasoning would otherwise become tribal knowledge.

## Relationship to ADRs

This folder follows the spirit of **Architecture Decision Records (ADRs)**, a pattern introduced by Michael Nygard.

The core idea: capture not just what was decided, but why — including the context, the alternatives considered, and the consequences. A future maintainer (or LLM) reading an ADR should understand the decision without needing to reconstruct the reasoning from git history or institutional memory.

Full ADR tooling (e.g. `adr-tools`, MADR format) is optional. A simple markdown file with the sections below is sufficient.

## Recommended Format

```markdown
# [Short title of decision]

## Status
active | superseded by [link] | historical

## Context
What situation or constraint forced this decision?

## Decision
What was decided?

## Alternatives Considered
What else was evaluated and why was it rejected?

## Consequences
What does this decision make easier or harder going forward?
```

Not every field is required for every decision. Use the fields that add explanatory value.

## Naming Convention

Use kebab-case filenames that describe the decision, not the date:

- `use-postgres-for-primary-store.md`
- `reject-event-sourcing.md`
- `api-versioning-strategy.md`

## When to Update

If a decision is revisited and reversed, do not delete the original record. Update its status to `superseded by [link]` and create a new record explaining the new decision and why the original was changed.

If a decision becomes irrelevant (e.g. the component it governed was removed), delete the file.
