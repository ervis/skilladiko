---
name: code-onboard
description: Onboard a developer onto a codebase, module, concept, or task area by driving a self-driven Socratic question chain — generate 3-7 neutral research questions, answer each from the codebase with file:line evidence, follow up with sharper questions from what was found, then surface the misconceptions a newcomer most likely holds. Solo, no user answers needed. Use when the user says "onboard me", "teach me this codebase", "I'm new here", "walk me through this project", "how does X work", "I want to understand X", "explain X", or wants to learn a concept/task/codebase area.
argument-hint: "<codebase path | module | concept | task description>"
---

# Code-Onboard — Self-Driven Socratic Question Chain

Onboard a developer onto a codebase, module, concept, or task by generating questions and answering them yourself from the code, then asking sharper follow-ups from what you found. Solo — no user answers mid-chain; the user stops you, you don't stop yourself. This fuses `/qrspi-question` (decompose into neutral research questions) with the research phase (answer from the codebase) into one self-driven loop, so the user doesn't run both separately.

## Input

`$ARGUMENTS` is the concept or task. If empty, ask the user to name one before recon. Resolve to concrete code via `Grep`/`Glob`; if ambiguous (multiple definitions) or unresolved, ask the user to disambiguate. Never silently pick one definition among several.

## Process

### Step 1 — Light recon
Spawn **`codebase-locator`** (or inline Grep/Glob if the subagent isn't available) to find which files relate to the target. You need to know what exists to write good questions.

### Step 2 — Decompose into 3-7 neutral research questions
Questions are **neutral and fact-seeking**, not solution-seeking. Each explores a different relevant area. Hard cap: 20 questions total across the chain (initial + follow-ups). Stop when covered, never exceed 20.

- Good: "How does the email notification system build its body, and where is the body defined?"
- Bad: "What's the best way to add a custom email template?"

Prefer "trace the flow" / "where is X defined" / "what's in X" over yes/no.

### Step 3 — Answer each question, then follow up
For each question:
1. **Read the code** (Read/Grep/Glob — never guess; every claim gets a `file:line`).
2. **Answer** with facts and `file:line` references.
3. **Generate 1-2 sharper follow-ups** probing the non-obvious: gaps, gotchas, design rationale, extension points.
4. **Answer the follow-ups** the same way.

This is the Socratic loop — question → read → answer → sharper question → read → answer. You are both questioner and answerer; the user watches.

### Step 4 — Surface misconceptions
Identify the 1-3 things a newcomer most likely gets wrong, and disprove each with `file:line` evidence. Highest-value output for a learner.

### Step 5 — Stop
Stop when covered — original questions answered, follow-ups resolved, misconceptions surfaced. Don't pad to a question count. Offer 1-2 deeper directions.

## Output Format

Inline. For each question:

```
**Q1. [question]**

[inner] [1-2 sentences: why this question, what you expect to find, where you'll look]

**A1.** [answer with file:line evidence]
```

Number sequentially (Q1, Q2, ...); follow-ups sub-numbered (Q1a, Q1b). Keep the `[inner]` monologue — it externalizes the research process so the user sees the wheels turn, not just polished answers. End with a "Misconceptions" section (Q-style) and a one-line offer to go deeper.

## Rules

- **Every claim has a `file:line`.** No assertions from vibes; no `~NNN` approximations — read the file or omit the claim.
- **Read before you answer.** Never describe code you haven't read this session.
- **Follow-ups probe the non-obvious.** Not the next obvious thing — the gap, gotcha, or rationale.
- **No teaching ornaments.** No comprehension checks aimed at the user, no "in your own words", no phases. This is a self-driven research chain, not a lesson.
- **Dense references over prose.** Bullets and `file:line`, not essays.

## Scope

One skill, one method, any scope — from a single function up to a whole repo. For a whole repo or large module, early questions map the system (what does this do, central abstractions, where the target sits), later questions zoom in. The method scales; you don't switch methods.

- "What is the role of X in the call graph" → role classification is a follow-up angle within the chain, not a separate skill.
- "I want to understand X so I can do Y" → the task anchors the questions, but questions stay neutral about how X works, not how to build Y. Facts surface the extension points; the user decides how to use them.
- Too large (monorepo, 50+ files) → narrow with the user before starting; don't fabricate coverage.
- Too small (single utility) → 3-4 questions cover it; say so, don't pad.