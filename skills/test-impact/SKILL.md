---
name: test-impact
description: Review a change (diff, file, folder, or task), map its dependencies, blast radius, and entry points, then propose test cases to document — not implement. Standalone or part of qrspi flow. Auto-detects the stack and loads the matching stack pack for concrete vocabulary.
argument-hint: "[artifact_path/ | git ref | path/to/file | path/to/dir/ | task description]"
---

# Test Impact — Map the Blast Radius, Propose the Tests

Given a change, identify **what is touched, what depends on it, what can break, and how to prove it still works**. Output is a catalog of test cases — not the tests themselves.

## Stance: document, don't implement.

- DO NOT write test code. Describe test cases.
- DO NOT run tests or fix failures.
- DO NOT modify source or test files.
- DO NOT critique the change or suggest refactors.
- ONLY document: dependencies, blast radius, entry points, and proposed test cases.

## Step 0 — Detect the stack and load a stack pack

Before anything else, detect the project's stack. Check in this order (first match wins):

| Signal | Stack | Pack to load |
|---|---|---|
| `Gemfile` with `rails`, or `config/routes.rb`, or `app/` + `config/` layout | Rails / Ruby | `skills/test-impact-rails/SKILL.md` |
| `package.json` with `react`/`next`/`express`/`nest` | Node web | *(no pack yet — use generic terms below)* |
| `go.mod` | Go | *(no pack yet)* |
| `Cargo.toml` | Rust | *(no pack yet)* |
| `pyproject.toml` / `requirements.txt` | Python | *(no pack yet)* |
| none of the above | unknown | use generic terms below |

**If a pack exists, load it via the `skill` tool and follow its vocabulary** (symbol roles, entry points, test layers, invariants, flakiness isolations, test framework). The pack overrides the generic terms in this skill. The generic process below still applies; only the concrete vocabulary changes.

**If no pack exists**, proceed with generic terms:
- Symbols = public functions / methods / classes / types / exports
- Entry points = HTTP routes, CLI commands, UI components, public API exports, background jobs, event subscriptions
- Test layers = unit | integration | e2e | contract | property
- Invariants = cite `file:line`, never invent
- Flakiness = time, randomness, network, filesystem — note the project's stub/mock/freeze convention by reading existing tests

When in doubt about the project's testing convention, read 2-3 existing test files and mirror their style. Do not assume a framework.

## Input

`$ARGUMENTS` tells you what to review. Resolve it to one of these modes:

| Caller says | Mode | How to resolve |
|---|---|---|
| `/test-impact` (no arg) | **Uncommitted** | `git diff` + `git status` — staged + unstaged changes |
| `/test-impact <branch>` | **Diff** | `git diff <branch>...HEAD` (commits on this branch not on the base) |
| `/test-impact <ref>` (sha, `HEAD~N`, tag) | **Diff** | `git diff <ref> --stat` + `git diff <ref>` |
| `/test-impact <refA>...<refB>` | **Diff** | `git diff <refA>...<refB>` |
| `/test-impact path/to/file` | **File** | Treat the single file as Tier 0 — inventory its public symbols/invariants |
| `/test-impact path/to/dir/` | **Folder** | See "Folder mode" below |
| `/test-impact ./artifact-dir/` (has `structure.md`/`plan.md`) | **qrspi** | Planned phases ARE the changes |
| `/test-impact "task description"` | **Inferred** | Infer change surface from text; mark every assumption |

### Resolution rules

1. If `$ARGUMENTS` is empty → uncommitted mode.
2. If `$ARGUMENTS` contains `...` or is a known git ref (resolve with `git rev-parse --verify`) → diff mode.
3. If `$ARGUMENTS` is a path that exists:
   - Directory with `structure.md` or `plan.md` → qrspi mode.
   - Directory without those → folder mode.
   - File → file mode.
4. Otherwise → inferred mode (treat `$ARGUMENTS` as a task description).

If resolution fails (e.g. ref doesn't exist, path not found), stop and report the exact error. Do not guess.

### Diff mode (branches, refs, ranges)

- `git diff <ref> --stat` → file list + churn.
- `git diff <ref>` → hunks. Capture changed symbols per hunk.
- For a range `<refA>...<refB>`, diff the three-way merge-base: `git diff $(git merge-base <refA> <refB>) <refB>`.

### File mode

A single file is Tier 0. Inventory its public symbols + invariants, then run the standard process. Useful for "review tests for this one module."

### Folder mode

When given a module/folder (no qrspi artifacts), the goal shifts from "what changed" to "what's the contract this module exposes, and how do we prove it holds." The module IS Tier 0.

1. **Inventory the public surface**: enumerate every public symbol (functions, methods, classes, types, constants, exports). Skip private/internal helpers unless they encode an invariant.
2. **Read each public symbol's signature + docstring/comment** to infer its contract (inputs, outputs, side effects, errors).
3. **Identify the module's invariants**: properties that must always hold. Cite `file:line` for where each is enforced or implied.
4. Then proceed with the standard process (dependency trace → blast radius → entry points → test cases), treating the module's public symbols as Tier 0.

Folder mode is also the right mode for **audit/review of an untested module** — the output is a proposed test suite from scratch, not a delta.

## Process

### 1. Inventory the change

- **Diff mode**: list every file touched (added, modified, deleted). For each modified file, capture the hunks: what symbols changed. Categorize each change: **new**, **modified signature**, **modified body**, **removed**.
- **File mode**: enumerate the file's public symbols + invariants. Categorize each by role (use the stack pack's roles if loaded, else generic: function/method/class/type/constant/side-effecting).
- **Folder mode**: list every file in the module. For each, enumerate public symbols. Categorize each by role.
- **qrspi mode**: read `structure.md`/`plan.md` phases — each phase's "Files affected" + "Key changes" is the inventory.
- **Inferred mode**: list the symbols/areas the description implies. Mark each as `[assumed]` until confirmed by reading the code.

### 2. Trace dependencies (what depends on it)

For each changed symbol:

- Search the codebase for callers/importers.
- Record `file:line` of each caller.
- Mark direct callers vs transitive (caller-of-caller, one level deep unless the chain crosses a process/api boundary).

Use `codebase-locator` or `codebase-pattern-finder` agents when the dependency surface is large or unclear. Limit to 2 agent calls; prefer direct grep/glob for simple cases.

### 3. Map the blast radius

Group affected code into tiers:

- **Tier 0 — Direct change**: the files/symbols in the diff.
- **Tier 1 — Direct consumers**: code that imports/calls Tier 0.
- **Tier 2 — Transitive consumers**: code that depends on Tier 1, plus integration points (routes, handlers, jobs, UI entry points, CLI commands).
- **Tier 3 — Boundary effects**: anything observable at a system boundary — HTTP responses, persisted state, emitted events, logs, queued jobs, public exports.

### 4. Identify entry points

List every place a user, external system, or test can reach the changed code. Use the stack pack's entry point list if loaded; otherwise enumerate generically:

- HTTP routes / handlers
- CLI commands
- UI components / pages
- Public API exports / library entry points
- Background jobs / cron / queue consumers
- Event subscriptions

Each entry point is a candidate for an integration/e2e test case.

### 5. Propose test cases

For each change + its blast radius, propose test cases. Each case:

- **ID** (e.g. `TC-01`)
- **Layer**: unit | integration | e2e | contract | property (use the stack pack's layer names if loaded)
- **Target**: the symbol or entry point under test (`file:line`)
- **Scenario**: one sentence describing the situation
- **Given / When / Then**: the three-line behavior spec
- **Covers**: which change IDs / blast tiers this case addresses
- **Priority**: critical | high | medium | low
- **Type**: happy | edge | error | regression | invariant

Selection rules (Google testing principles):

- **Prevention over detection**: prefer tests that pin down an invariant the change could break, over tests that merely re-state the happy path.
- **Critical paths + error branches first**. Do not chase 100% line coverage. Note explicitly what is NOT covered and why it's acceptable.
- **One behavior per case.** If a case needs "and also", split it.
- **Behavior, not implementation.** Test the observable contract, not private helpers.
- **Regression cases for bug fixes**: if the diff fixes a bug, the first case is the failing reproduction (red), marked `regression`.
- **Invariants**: list system invariants the change could violate and propose a case per invariant. Use the stack pack's invariant examples as a checklist, but only list invariants with `file:line` evidence.

### 6. Gap analysis

- Which blast tiers have no proposed case? Note the risk.
- Which entry points are untested? Note.
- Which invariants are unverified? Note.
- Flaky-prone areas (time, randomness, network, filesystem) — flag and note the required isolation strategy (use the stack pack's tooling if loaded, else read existing tests for the project's convention).

## Output: test-impact.md

Write to the artifact directory if running in qrspi flow, else to the repo root (or `./` if no artifact dir). Structure:

```markdown
# Test Impact — [change summary]

## Stack
Detected: [stack name] | Pack: [pack name or "generic"]

## Change Inventory
| File | Change | Symbols affected |
|------|--------|------------------|
| path/to/file | modified | `symbolA`, `SymbolB` |

## Dependency Map
### `symbolA` (path/to/file:LL)
- Direct callers:
  - `other/path:LL` — `callerFn`
- Transitive:
  - `third/path:LL` — `grandCaller`

## Blast Radius
- **Tier 0 — Direct change**: [files]
- **Tier 1 — Direct consumers**: [files + symbols]
- **Tier 2 — Transitive consumers**: [files + symbols]
- **Tier 3 — Boundary effects**: [observable outputs / state]

## Entry Points
- [entry point] — `file:line`

## Invariants at Risk
- Invariant: [name] — enforced at `file:line` — change may [preserve|break] it
- ...

## Proposed Test Cases

### TC-01 [ID] — [Scenario]
- **Layer**: [layer]
- **Target**: `symbolA` (`path/to/file:LL`)
- **Given**: ...
- **When**: ...
- **Then**: ...
- **Covers**: Tier 0, Tier 1, invariant "[name]"
- **Priority**: critical
- **Type**: happy

### TC-02 ...

## Gaps
- Tier 2 has no integration case for `grandCaller` — risk: [low/med/high], acceptable because [reason].
- Entry point [name] untested at e2e — risk: high.
- Invariant "[name]" unverified — risk: critical.

## Not Covered (intentional)
- [area] — [why it's acceptable to skip]
```

## Handoff

- Tell the user: "Test cases documented in `test-impact.md`. Next: implement the cases, or run `/qrspi-plan` to fold them into the plan."
- If running inside qrspi flow and `plan.md` exists, suggest adding a "Test cases" section per phase referencing the TC IDs.

## Rules

- Document only. No test code, no source edits, no running tests.
- Every claim about the codebase must cite `file:line`.
- Every proposed case must map to at least one change ID or invariant.
- Keep the catalog scannable — tables for inventory, one block per test case.
- If the change cannot be determined from input, stop and ask. Do not guess the change surface.
- Cap proposed cases at a useful set — if you're proposing >40, the change is too large; say so and suggest splitting the work.
- Never invent invariants. Only list invariants with evidence (`file:line`) in the codebase or named in `structure.md`/`design.md`/`task.md`.
- Match the project's existing test style. Detect the framework from config + existing test files. Do not mix conventions.
- If a stack pack is loaded, its vocabulary overrides the generic terms in this skill.

## When to Go Back

If mapping the blast radius reveals the change touches far more than expected, or breaks an invariant that wasn't discussed in design, stop and tell the user. Suggest re-running `/qrspi-design` or `/spec-grooming` rather than documenting tests around a flawed change.