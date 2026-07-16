---
name: code-onboard
description: Onboard a developer onto a codebase, module, concept, or task area by building the mental model of one concept — anchor on its central abstraction, trace producers and consumers to draw the spine through the call graph, map its neighborhood, surface the trapdoors, and connect findings to the user's stated task. Solo, no user answers needed. Use when the user says "onboard me", "teach me this codebase", "I'm new here", "walk me through this project", "how does X work", "I want to understand X", "explain X", or wants to learn a concept/task/codebase area.
argument-hint: "<codebase path | module | concept | task description>"
---

# Code-Onboard — Mental Model Mining

Onboarding onto a codebase = building the mental model of one concept. A concept has, at its core, **one central abstraction** — the data structure or interface that *is* the concept. Everything else produces it, consumes it, or configures it. Find that abstraction, trace its collaborators both directions, and the mental model builds itself.

The method is structured, evidence-backed reading — not a distinct technique. The "question chain" framing organizes the research into producer/consumer/neighbor/trap questions but is not a special mechanism. **The chain runs internally — do not print Q/A to the terminal.** The report is the only artifact emitted.

## Input

`$ARGUMENTS` is the concept or task. If empty, ask before recon. Resolve to code via `Grep`/`Glob`; if ambiguous (multiple candidate abstractions) or unresolved, ask the user to disambiguate. Never silently pick among several.

## Process

### Step 1 — Light recon (locate the abstraction)
Spawn **`codebase-locator`** (or inline Grep/Glob if unavailable) to find which files relate to the target. The locator is a WHERE tool: it returns the file tree of the concept's neighborhood, not the hand-offs (it doesn't read contents). You need the WHERE before you can read and trace.

### Step 2 — Name the central abstraction (provisional)
Identify the single data structure, interface, or class that *is* the concept. State it explicitly. If multiple are equally central, ask the user which to anchor on rather than picking silently.

Naming is **provisional** — made from recon alone, before deep reading. If Step 4 shows the named abstraction doesn't explain the concept end-to-end (a producer fills it but no consumer produces the effect the user cares about, or the consumer reads a *different* structure), rename and retrace. Re-anchoring is expected, not a failure.

### Step 3 — Decompose into 3-7 neutral research questions
Neutral and fact-seeking, not solution-seeking. Hard cap: 20 questions total (initial + follow-ups). Stop when covered.

Shapes, in priority order:
- **Producers** — who constructs/fills the abstraction? What slots exist?
- **Consumers** — who reads it and acts on it? How is the output made from those slots? (Producer + consumer + their connection = the spine.)
- **Off-spine neighbors** — siblings, config, adjacent stations (k=1 in graph terms).
- **Traps** — what looks like the obvious way and silently doesn't work? Adjacent-but-unrelated machinery that pattern-matches as the extension point?

- Good: "Who constructs the abstraction and which fields does it fill?"
- Bad: "What's the best way to add a custom X?"

Prefer "trace the flow" / "where is X defined" / "who produces/consumes X" over yes/no.

### Step 4 — Answer each question, then follow up
For each question: **read** the code (never guess; every claim gets a `file:line`), **answer** with facts and `file:line`, generate 1-2 **sharper follow-ups** probing the non-obvious (gaps, gotchas, rationale, extension points), answer them the same way.

**Reading-depth stop:** read each station until you can state its job in one sentence and name its hand-off to the next — then stop. A station is a node on the spine, not a file to memorize.

Follow-ups probe *why* / *what breaks* / *edge case*, not *what else*. Descriptive follow-ups (restating what the code does) are filler — re-probe for a gotcha or rationale. When you find *any* templating/machinery near the target, verify it's for the target, not an adjacent concern (recurring trap: usage that looks like the obvious extension point but serves a different concern).

**Re-anchor check:** if a producer fills the abstraction but no consumer turns it into the user-relevant effect, or a consumer reads a *different* structure, the Step 2 anchor was wrong. Rename and retrace. Do not force findings onto a wrong anchor.

### Step 5 — Surface misconceptions
Identify the 1-3 things a newcomer most likely gets wrong. Disprove each with `file:line`. Hard cap: 3 — cut the weakest. Misconceptions are trapdoors that break the mental model; plain facts about sanitization or config belong in the report body, not here.

### Step 6 — Confirm traps if cheap; locate the mirror tests
Trapdoors are claims a user will act on — highest cost of being wrong. Check whether each can be cheaply confirmed (grep for the collision pattern, quick test run, import-order check, dispatcher-logic glance — under ~1 minute). Confirm if cheap; else mark `[inferred]` in the report rather than stating as fact.

Locate the **tests that exercise the spine** — the unit/integration tests that instantiate the central abstraction and call its consumers. They double as: (a) cheap trap confirmation (a trap may already be demonstrated or fail a test), and (b) the user's safety net — "confidence not to break things." Record test paths for the report.

### Step 7 — Stop and write the report
Stop when covered — spine traced, neighborhood mapped, traps surfaced (confirmed-or-marked-inferred), extension point for the stated task connected. Don't pad to a question count.

Write a **comprehensive, doc-reduced report**: every fact, finding, and `file:line` distilled to maximum information density, no redundancy (every word load-bearing, nothing removable without losing meaning).

The report MUST contain, in this order:
1. **Spine** — the central abstraction + producer → abstraction → consumer chain, end to end, with `file:line` at each hop. One sentence stating the abstraction; then the chain.
2. **Neighborhood** — the k=1 collaborators off the spine: siblings, config, adjacent stations, with where they live in the file tree.
3. **Trapdoors** — the silently-doesn't-work traps, with `file:line`. **Mark each `[read]` (directly observed) or `[inferred]` (reasoned, unconfirmed).** Do not blur "read at a line" with "concluded from import order / dispatch logic."
4. **Paths for your goal** — the stated task connected to findings: which spine station is the edit point, what neighbors constrain it, the idiomatic path(s). If the codebase does not support the goal, say so — state why, name the closest thing. Negative results are valid; do not force a fake path.
5. **Mirror tests** — the test paths that exercise the spine. The user's safety net.
6. **Misconceptions** (≤3) — trapdoors that break the mental model, with `file:line`.
7. **Go deeper** — 1-2 directions, then ask the user which (if any) to pursue. End with a question.

**Small-scope relaxation:** for a single utility or function (3-4 questions cover it), collapse Spine + Neighborhood into one section, and drop any empty section. Do not pad.

## Output Format

Run the chain **internally** — do not emit Q/A to the terminal. Keep each internal A doc-reduced: facts and `file:line`, no restatement.

After the chain, ask the user (via the `question` tool) whether to **print the report in the terminal** or **write it to a file**. If file, ask for the path and write the `.md` using the `write` tool. Do only the chosen action — not both.

## Rules

- **Every claim has a `file:line`.** No vibes; no `~NNN` approximations — read or omit.
- **Distinguish `[read]` from `[inferred]`.** A claim reasoned from import order or dispatch logic is not a claim read at a line. Mark inferences.
- **Confirm traps if cheap.** Unconfirmed traps are marked `[inferred]`, not stated as fact.
- **Read before you answer.** Never describe code you haven't read this session.
- **Anchor on one central abstraction.** Name it explicitly; trace its producers and consumers. If you can't name it, you don't have the mental model yet. Rename if Step 4 shows it's wrong.
- **Follow-ups probe the non-obvious.** The gap, gotcha, or rationale — reject descriptive follow-ups.
- **No teaching ornaments.** No comprehension checks, no "in your own words", no phases. This is research, not a lesson.
- **Dense references over prose.** Bullets and `file:line`, not essays.
- **Honor the stated task.** Questions stay neutral about how X works; the report's "Paths for your goal" section connects findings to what the user came to do — including "not supported" if so.

## Scope

One skill, one method, any scope — single function to whole repo. The central-abstraction anchor scales: for a single function the "abstraction" may be the function's return type or the function itself; for a whole repo, early questions locate the abstraction and its neighborhood, later questions trace the spine.

- "What is the role of X in the call graph" → X is the central abstraction; trace its producers and consumers.
- "I want to understand X so I can do Y" → X is the concept, Y is the stated task; "Paths for your goal" maps findings to Y.
- Too large (monorepo, 50+ files) → narrow with the user before starting; don't fabricate coverage.
- Too small (single utility) → 3-4 questions cover it; use the small-scope report relaxation; say so, don't pad.