---
description: Write a design doc for agent implementation. Use this whenever you are planning work that an agent will execute, designing a feature or system, making architectural decisions, or planning changes to code or infrastructure. This skill guides you through gathering all the information needed so an agent can implement overnight without asking questions. It ensures your design is consistent with existing approaches in the codebase, explicit about decisions, and ready for overnight implementation. Use it for any design that will be reviewed, approved, and then handed to an agent for implementation.
model: opus
argument-hint: "[artifact_path/]"
---

# Design Doc — Frozen Plan for Agent Implementation

Write a complete design doc that meets all Design Goal Metrics.
An agent reads this doc and implements it overnight without asking questions.

## Input

If no artifact path is provided, `$ARGUMENTS` is the current directory (`.`).

The skill reads existing work if present:
- `$ARGUMENTS/task.md` — what are you designing?
- `$ARGUMENTS/research.md` — what did you explore?
- `$ARGUMENTS/design.md` — earlier design thinking (if any)

## Process

The skill guides you through six phases.
Each phase stops and asks questions before moving ahead.

### Phase 1: Question
You state what you want to design.
The skill asks:
- What problem are you solving?
- What type is this work? (feature, fix, new system, refactor, internal tool)
- Who is affected?

### Phase 2: Explore
The skill investigates what you said.
It asks:
- What existing systems relate to this work?
- What do you know? What are you assuming?
- Do you need to research something before designing?

The skill may suggest research or prototyping.
Only continue when you have evidence for key claims.

### Phase 3: Structure
The skill decides which template sections you actually need.
A bugfix needs fewer sections than a new system.
The skill creates a lightweight structure for your type of work.

You approve the structure before moving ahead.

### Phase 4: Gather
The skill goes through each section one at a time.
For each section, it asks questions until the "must cover" items are answered.

**Use `/grill-me` for this phase.** The grill-me skill iteratively questions your answers 
until they are complete and specific. The design-doc skill and grill-me skill work together:
- Design-doc skill names what must be covered.
- Grill-me skill asks follow-up questions until the answer is truly complete.

The skill does not accept vague answers. Examples:
- You cannot write "make it fast." Write "P95 latency under 200ms."
- You cannot write "improve reliability." Write "99.9% uptime, handle 10x load."
- You cannot write "follow the existing pattern." Say which pattern and where it is used.
- You cannot write "add a new function." Write `function_name(param: Type): ReturnType` and its contract.
- You cannot write "use a new abstraction." Explain the abstraction, its contract, and why it's needed.

Throughout all sections, the skill asks about consistency and signatures:
- How does the codebase already solve this problem?
- Where in the codebase can you see the existing approach?
- Does your design use that same approach, or do you deviate? If you deviate, why?
- What are the exact signatures for new functions or API endpoints?
- What abstractions does this design introduce or change?
- What contract does each abstraction promise?

### Phase 5: Validate
The skill checks the doc against all Design Goal Metrics:

1. **Pattern Alignment** — Does the design explain which patterns it follows?
2. **Agent-Readiness** — Can an agent implement this without asking a question?
3. **Evidence-Based** — Are claims grounded in exploration or facts, not guesses?
4. **Completeness** — Are all "must cover" items answered? Any vague sections?
5. **Risk Clarity** — Are failure modes named? Is the rollback plan explicit?
6. **Traceability** — Is every change documented? Does every decision have a rationale?
7. **Scope Containment** — Are Goals and Non-Goals explicit? Can scope creep?
8. **Invariant Preservation** — Does the design preserve what must not change?

The skill also verifies: **All decision information the agent needs is in this doc or explicitly referenced.**

If any metric fails, the skill stops and tells you what to fix.
Only when all metrics pass do you move to Phase 6.

### Phase 6: Output
The skill produces the final design doc in markdown.

**Use `/simple-language` to review the doc.** The simple-language skill ensures 
the doc uses clear, direct language that is easy to understand. An agent reading 
this doc should never stumble on jargon or confusing sentences.

This doc is frozen. Peers review it.
An agent implements it overnight without further questions.

## Output

- File written: `design-doc.md` in artifact directory
- The doc meets all Design Goal Metrics
- The doc is ready for peer review and agent implementation

## Rules

- **Ask, don't assume.** Before writing anything, ask the author clarifying questions.
- **Gather evidence.** If the author makes a claim, ask what evidence backs it up.
- **Be specific.** Reject vague answers. Push for numbers, patterns, examples.
- **Name patterns.** Every design decision must explain which pattern it follows.
- **List changes explicitly.** Every change, even trivial ones, gets documented.
- **Reference everything.** If the agent needs to know something, it's in the doc or linked.
- **Check all metrics.** Do not move to the next phase until current phase passes validation.

## When to Go Back

**If Phase 2 (Explore) reveals the problem is different than stated:**
Tell the author and suggest going back to Phase 1 to reframe.
Do not continue with an incomplete understanding.

**If Phase 4 (Gather) uncovers a design flaw:**
Stop and suggest going back to Phase 3 (Structure) or Phase 1 (Question).
Design flaws found mid-gathering are cheaper to fix than mid-implementation.

**If Phase 5 (Validate) fails a metric:**
Do not move forward. Tell the author which metric failed and why.
Help them fix it before Phase 6.
