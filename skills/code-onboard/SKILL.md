---
name: code-onboard
description: Onboard a developer onto a codebase, module, concept, or task area by building the mental model of one concept — anchor on its central abstraction, trace producers and consumers to draw the spine through the call graph, map its neighborhood, surface the trapdoors, and connect findings to the user's stated task. Solo, no user answers needed. Use when the user says "onboard me", "teach me this codebase", "I'm new here", "walk me through this project", "how does X work", "I want to understand X", "explain X", or wants to learn a concept/task/codebase area.
argument-hint: "<codebase path | module | concept | task description>"
---

# Code-Onboard — Mental Model Mining

Onboarding = building the mental model of one concept. A concept has one **central abstraction** — the data structure or interface that *is* the concept; everything else produces, consumes, or configures it. Find it, trace its collaborators both directions, the model builds itself.

The method is structured, evidence-backed reading — not a distinct technique. The "question chain" organizes research into producer/consumer/neighbor/trap questions but is no special mechanism. **The chain runs internally — never print Q/A.** The report is the only artifact.

## Input

`$ARGUMENTS` is the concept or task. If empty, ask before recon. Resolve to code via `Grep`/`Glob`; if ambiguous (multiple candidate abstractions) or unresolved, ask the user to disambiguate. Never silently pick among several.

## Process

### Step 1 — Light recon
Spawn **`codebase-locator`** (or inline Grep/Glob if unavailable) to find which files relate to the target. The locator is a WHERE tool: file tree of the neighborhood, not hand-offs (it doesn't read contents). You need the WHERE before tracing.

### Step 2 — Name the central abstraction (provisional)
Identify the single data structure, interface, or class that *is* the concept. State it explicitly. If multiple are equally central, ask the user which to anchor on. Naming is **provisional** — from recon alone, before deep reading. If Step 4 shows it doesn't explain the concept end-to-end (producer fills it but no consumer produces the user-relevant effect, or consumer reads a *different* structure), rename and retrace **once**. If the second anchor also fails, proceed with the best available and note the gap in the report. Do not loop re-anchoring more than once — an unbounded rename loop is the recursion risk.

### Step 3 — Decompose into 3-7 neutral research questions
Neutral, fact-seeking, not solution-seeking. **Hard cap: 20 questions total (initial + follow-ups) — when hit, write the report even if coverage feels incomplete; note the gap.** Do not exceed 20. Stop earlier when covered.

Shapes, in priority order:
- **Producers** — who constructs/fills the abstraction? What slots exist?
- **Consumers** — who reads it and acts on it? How is the output made from those slots? (Producer + consumer + their connection = the spine.)
- **Invariants & constraints** — what must hold for the concept to function? Preconditions (producer guarantees before hand-off), postconditions (consumer assumes on receipt), happens-before rules (X must complete before Y — e.g. body built with `cid:` IDs before matching `MIMEImage`s attached), capacity/size limits, allowed values, sanitization/filtering. These are the rules "looks-right" code silently violates.
- **Off-spine neighbors** — siblings, config, adjacent stations (k=1 in graph terms).
- **Traps** — what looks like the obvious way and silently doesn't work? Adjacent-but-unrelated machinery pattern-matching as the extension point?

- Good: "Who constructs the abstraction and which fields does it fill?"
- Bad: "What's the best way to add a custom X?"

Prefer "trace the flow" / "where is X defined" / "who produces/consumes X" over yes/no.

### Step 4 — Answer each question, then follow up
For each: **read** the code (never guess; every claim gets a `file:line`), **answer** with facts and `file:line`, generate 1-2 **sharper follow-ups** probing the non-obvious (gaps, gotchas, rationale, extension points), answer them the same way.

**Reading-depth stop:** read each station until you can state its job in one sentence and name its hand-off to the next — then stop. A station is a spine node, not a file to memorize.

Follow-ups probe *why* / *what breaks* / *edge case*, not *what else*. Descriptive follow-ups (restating what the code does) are filler — re-probe for a gotcha or rationale. When you find *any* templating/machinery near the target, verify it's for the target, not an adjacent concern (recurring trap: usage that looks like the extension point but serves a different concern).

**Re-anchor check:** if a producer fills the abstraction but no consumer turns it into the user-relevant effect, or a consumer reads a *different* structure, the Step 2 anchor was wrong. Rename and retrace. Don't force findings onto a wrong anchor.

### Step 5 — Surface misconceptions
The 1-3 things a newcomer most likely gets wrong. Disprove each with `file:line`. Hard cap: 3 — cut the weakest. Misconceptions are trapdoors that break the mental model; plain facts about sanitization or config belong in the report body, not here.

### Step 6 — Confirm traps if cheap; locate mirror tests
Trapdoors are claims a user will act on — highest cost of being wrong. Check whether each can be cheaply confirmed (grep for the collision pattern, quick test run, import-order check, dispatcher-logic glance — under ~1 minute). Confirm if cheap; else hedge the language ("appears to", "likely") rather than stating as certain fact.

Locate the **tests that exercise the spine** — unit/integration tests instantiating the central abstraction and calling its consumers. They double as: (a) cheap trap confirmation (a trap may already be demonstrated or fail a test), and (b) the user's safety net — "confidence not to break things." Record paths for the report.

### Step 7 — Stop and write the report
Stop when covered — spine traced, neighborhood mapped, traps surfaced (confirmed-or-marked-inferred), extension point for the stated task connected. Do not exceed the 20-question cap (Step 3) — if hit, write the report with what you have and note gaps. Don't pad to a count.

Write a **comprehensive, doc-reduced report** following the template at `skills/code-onboard/report.template` (in this skill's directory). Fill every applicable section; drop inapplicable ones. Every fact, finding, and `file:line` distilled to maximum information density, no redundancy (every word load-bearing, nothing removable without losing meaning).

The report MUST contain, in this order:
1. **Spine** — central abstraction + producer → abstraction → consumer chain, end to end, `file:line` at each hop. One sentence stating the abstraction; then the chain.
2. **Neighborhood** — k=1 collaborators off the spine: siblings, config, adjacent stations, with file locations.
3. **Trapdoors** — silently-doesn't-work traps, with `file:line`. If a trap is unconfirmed, hedge the language ("appears to", "likely") rather than stating as certain.
4. **Invariants & constraints** — preconditions, postconditions, happens-before rules, capacity limits, allowed values, sanitization constraints that must hold for the concept to function. `file:line` for each. What "looks-right" code silently violates.
5. **Paths for your goal** — stated task connected to findings: which spine station is the edit point, what neighbors constrain it, the idiomatic path(s). If unsupported, say so — state why, name the closest thing. Negative results are valid; don't force a fake path.
6. **Mirror tests** — test paths exercising the spine. The user's safety net.
7. **Misconceptions** (≤3) — trapdoors that break the mental model, with `file:line`.
8. **Go deeper** — 1-2 directions, then ask the user which (if any) to pursue. End with a question.

**Small-scope relaxation:** for a single utility or function (3-4 questions cover it), collapse Spine + Neighborhood into one section, drop empty sections. Don't pad.

## Output Format

Run the chain **internally** — never emit Q/A. Keep each internal A doc-reduced: facts and `file:line`, no restatement.

After the chain, ask the user (via the `question` tool) whether to **print the report in the terminal** or **write it to a file**. If file, ask for the path and write the `.md` using the `write` tool. Do only the chosen action — not both.

## Rules

- **Every claim has a `file:line`.** No vibes; no `~NNN` approximations — read or omit.
- **Confirm traps if cheap.** Unconfirmed traps hedged ("appears to", "likely"), not stated as certain.
- **Read before you answer.** Never describe code you haven't read this session.
- **Anchor on one central abstraction.** Name it explicitly; trace its producers and consumers. If you can't name it, you don't have the model yet. Rename if Step 4 shows it's wrong.
- **Follow-ups probe the non-obvious.** The gap, gotcha, or rationale — reject descriptive follow-ups.
- **No teaching ornaments.** No comprehension checks, no "in your own words", no phases. Research, not a lesson.
- **Dense references over prose.** Bullets and `file:line`, not essays.
- **Honor the stated task.** Questions stay neutral about how X works; "Paths for your goal" connects findings to what the user came to do — including "not supported" if so.

## Scope

One skill, one method, any scope — single function to whole repo. The central-abstraction anchor scales: for a single function the "abstraction" may be the function's return type or the function itself; for a whole repo, early questions locate the abstraction and neighborhood, later questions trace the spine.

- "What is the role of X in the call graph" → X is the central abstraction; trace its producers and consumers.
- "I want to understand X so I can do Y" → X is the concept, Y is the stated task; "Paths for your goal" maps findings to Y.
- Too large (monorepo, 50+ files) → narrow with the user before starting; don't fabricate coverage.
- Too small (single utility) → 3-4 questions cover it; use the small-scope relaxation; say so, don't pad.