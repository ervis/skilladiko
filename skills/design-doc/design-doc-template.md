# How to Write a Design Doc for the Night Factory

This is a template for step 1 of the pipeline in
[dev-pipeline.md](dev-pipeline.md): the design doc a human approves in the
morning, that an agent then implements overnight without a human present.

**To write a design doc, use the `/design-doc` skill.** 
The skill guides you through all six phases and ensures your doc meets all Design Goal Metrics.
It integrates with `/grill-me` for iterative questioning and `/simple-language` for clarity.
This template describes what each section is for and what it must contain.

This document has two readers:

- **The human author**, who writes the doc and needs to know what each
  section is for and what it must contain to get approved fast.
- **The agent implementer**, who reads the approved doc overnight and needs
  to know exactly what "done" and "safe to proceed" mean for each section.

**Rule for the agent:** if a section below is missing, or a "must cover"
item is not answered, do not guess. Stop and record it as a blocker for the
morning review. A silently guessed assumption is the exact failure mode
this document exists to prevent. See dev-pipeline.md, "Design doc
antipatterns," for what an unresolved gap costs when nobody is awake to
answer a question.

## How to Use This Template With the Skill

The design doc skill guides you to fill this template.
The skill has six phases. You move through them one at a time.
At each phase, the skill stops and asks questions before moving ahead.

The **Gather** phase is the most important one.
The skill does not just ask you to write sections.
Instead, it asks follow-up questions until each section is truly complete.

Example: You write "improve performance."
The skill asks:
- "What is the current latency?"
- "What latency target do you need?"
- "Who is affected by this?"

This stops vague answers before they reach review.
It forces you to think through your assumptions.
It catches gaps and missing details early.

## Skill Workflow

### Phase 1: Question
You state what you want to design. Answer these:
- What problem are you solving?
- What type is this work? (feature, fix, new system, refactor)

### Phase 2: Explore
The skill investigates what you said. It may:
- Ask you about existing systems that relate to this work.
- Ask what you already know versus what you assume.
- Suggest you research a specific area before continuing.

### Phase 3: Structure
The skill decides which template sections you actually need.
A bugfix needs fewer sections than a new system.
The skill creates a lightweight structure for your type of work.

### Phase 4: Gather
The skill goes through each section one at a time.
For each section, it asks questions until the "must cover" items are answered.
It does not accept vague answers. It pushes for specifics and numbers.

Throughout all sections, the skill asks about consistency:
- "How does the codebase already solve this?"
- "Where in the codebase can you see that approach?"
- "Does your design use that same approach, or do you deviate?"

Example: You cannot write "make it fast." You must write "P95 latency under 200ms."
And if you choose a specific approach, you must explain whether it uses existing approaches from the codebase or why you're deviating.

### Phase 5: Validate
The skill checks the doc against all Design Goal Metrics:

1. **Consistency** — Does the design prefer existing approaches in the codebase? If it deviates, is the deviation justified?
2. **Agent-Readiness** — Can an agent implement this without asking a question?
3. **Evidence-Based** — Are claims grounded in exploration or facts, not guesses?
4. **Completeness** — Are all "must cover" items answered? Any vague sections?
5. **Risk Clarity** — Are failure modes named? Is the rollback plan explicit?
6. **Traceability** — Is every change documented? Does every decision have a rationale?
7. **Scope Containment** — Are Goals and Non-Goals explicit? Can scope creep?
8. **Invariant Preservation** — Does the design preserve what must not change?

The skill also verifies: **All decision information the agent needs is in this doc or explicitly referenced.**

Once all metrics pass, your doc is ready for peer review.

### Phase 6: Output
The skill produces the final design doc.
This doc is frozen. Peers review it in the morning.
An agent implements it at night without further questions.

---

## Design Goal Metrics

A design doc is approved only if it meets all these metrics. These are not suggestions.

**Design Goal Metrics:**

1. **Consistency** — The design uses existing solutions and ways of solving problems 
   that are already in the codebase. If the codebase already does X a certain way, 
   this design does X the same way. If deviating from existing approaches, the doc 
   explains why and gets explicit approval.

2. **Agent-Readiness** — An agent reading only this doc can implement it 
   overnight without asking a question. No ambiguity. No gaps.

3. **Evidence-Based** — Claims rest on exploration or facts, not assumptions. 
   If "this will scale," the author has tested it or researched why.

4. **Completeness** — All "must cover" items are answered. No section is vague or half-finished.

5. **Risk Clarity** — Failure modes are named. The agent knows what can go wrong 
   and how to detect it. Rollback plans are explicit.

6. **Traceability** — Every change is documented. Every decision has a rationale. 
   Nothing is approved implicitly.

7. **Scope Containment** — Goals and Non-Goals are explicit. Scope cannot silently expand 
   during implementation.

8. **Invariant Preservation** — The design preserves what must not change. 
   If an invariant breaks, it is named and justified.

**Critical Rule: All Decision Information Must Be in This Doc or Its References**

The agent cannot ask questions overnight. Therefore:
- Every decision the agent needs to make is answered in this doc.
- Every technical fact is either in this doc or a referenced doc (with link and section).
- Every assumption the agent needs to know is stated explicitly.
- If something the agent needs is "obvious" or "in the code," the doc must say where 
  and point to it explicitly.

---

---

## Context

**Goal:** bring a reader who knows nothing about this specific problem up
to speed, in under a paragraph.

**Must cover:**
- What exists today, in one or two sentences.
- Why this doc exists right now (what triggered it).

**Not this section's job:** justifying the chosen solution. That belongs
in Design Overview and Detailed Design, below.

## Problem Statement

**Goal:** state exactly what is being solved, specifically enough that two
different people would design toward the same target.

**Must cover:**
- The problem, stated specifically. "Improve performance" is not specific
  enough. "Reduce checkout latency in the payment service" is.
- Who this is for: end users, an internal team, or infrastructure.
- What happens if we do nothing. This is not filler; it exposes
  unnecessary complexity before it gets designed in.

## Goals and Non-Goals

**Goal:** bound the scope before any design decision gets made, so scope
cannot silently expand later.

**Must cover:**
- Goals: what this design will accomplish.
- Non-goals: things that could reasonably be in scope, but are explicitly
  chosen not to be. Name them, do not just omit them. A reader should never
  have to guess whether something is out of scope; the doc should say so.

**Agent-readiness check:** if the agent, mid-implementation, finds itself
touching something not listed in goals or non-goals, that is scope not
covered by the approved doc. Stop and flag it, do not extend the design to
cover it.

## Success Metrics

**Goal:** make "done" and "working" checkable by a number, not a feeling.

**Must cover:**
- A quantified definition of success. Translate every vague requirement
  into a number before design decisions are made:
  - "Many users" -> a specific number, e.g. "10 million daily active users,
    5k requests per second at peak."
  - "Fast" -> a specific latency, e.g. "P95 latency under 200 milliseconds."
  - "Reliable" -> a specific uptime, e.g. "three nines uptime, 8 hours of
    downtime per year."
  - "Scalable" -> a specific growth target, e.g. "handle 3x current load
    within 6 months."

**Agent-readiness check:** an agent cannot act on "make it fast." It can
act on a number. A design doc with no numbers here is not agent-ready,
regardless of how complete the rest of the doc looks.

## Existing System and Constraints

**Goal:** prove the design accounts for what already exists, instead of
reinventing something that already works.

**Must cover:**
- What already exists that is relevant, and what its actual limitations
  are in production today, not just in theory.
- Why existing functionality is or is not being reused. If the design adds
  something that looks similar to what already exists, this must state why
  reuse was rejected.
- What other teams or systems depend on the thing being changed. A change
  can silently break a dependent team if this is not checked.
- **What this design changes about the above.** Describing what exists is
  not enough; state what gets deprecated, replaced, narrowed, or otherwise
  invalidated by this change. A reader should not have to infer this by
  comparing Existing System and Constraints against Detailed Design
  themselves.

## Exploration

**Goal:** separate what was actually explored and learned from what is
merely proposed, so an unproven claim cannot pass as settled. See
dev-pipeline.md, "Confidence and blast radius," on prototyping as evidence:
"I tried it and it works" is strong evidence; "I think this will work" is
not evidence at all.

Exploration is not only prototyping code. It also includes fact-finding
against the existing codebase and system, the same job the `/qrspi-question`
and `/qrspi-research` skills do: turn an uncertainty into a specific
question, then go answer it with evidence instead of assumption.

**Must cover, if the approach is non-obvious:**
- What was explored, and how: a prototype or spike, a read of the existing
  code, a test against real data, or a targeted research pass. State the
  specific question each exploration was meant to answer.
- What was actually found, with numbers or citations where possible, not
  just "it worked" or "it should work."
- Any new question the exploration surfaced, even one it did not resolve.
  Carry it into Open Questions (below) instead of quietly dropping it.
  Finding a new question is a normal, valid outcome of exploration, not a
  failure of this section.
- Whether anything found contradicts or invalidates a fact stated earlier
  in this doc, most likely in Existing System and Constraints or Problem
  Statement. If exploration changed what the author believed, the doc must
  reflect the update, not the original assumption it disproved.

**When this section can be empty:** the approach is obvious or
well-trodden, and nothing in the design rests on an unproven assumption. An
empty section for that reason should say so directly, not just be left
blank. A non-obvious approach with an empty section here is not
agent-ready; it is an unresolved Open Question (below) wearing the shape of
a settled design.

## Design Overview

**Goal:** give a one-paragraph summary of the chosen solution before the
reader goes into the detailed design. This is the doc's own TL;DR.

**Must cover:**
- The chosen approach, in one paragraph, in plain language.

## Detailed Design

**Goal:** give the agent (or a human implementer) everything needed to
build the thing without asking a follow-up question.

This section is organized into four subsections:

### Data Design

**Must cover:**
- Database structure and table/schema layouts.
- Data models and entity-relationship diagrams.
- Data flow diagrams: show how data moves through the system.
- Data validation and integrity rules.
- How data will be stored and retrieved efficiently.

### Interface Design (APIs and Integration Points)

**Must cover:**
- API endpoint signatures and HTTP methods.
- Request/response message formats and data structures.
- Protocol specifications and standards used.
- Authentication and authorization methods.
- Error handling and exception codes.
- Rate limiting or other constraints.

### Component Design

**Must cover:**
- Purpose and responsibilities of each major component.
- Function and method signatures (parameter types, return types).
- Input and output specifications for each component.
- Algorithms and data structures used.
- Dependencies on other components or external systems.
- New abstractions introduced: name, contract, and justification.
- Changes to existing abstraction contracts: what changes and what depends on them.

### System Architecture Overview

**Must cover:**
- The components involved and how they connect to each other.
- High-level architecture diagrams.
- Data flow traced end to end: follow one request from entry to exit. 
  This catches design flaws diagrams alone miss.
- Technology choices and the tradeoffs behind each one.
- Justification for every added component. Fewer moving parts is the default; 
  each one added needs its own reason.

**Agent-readiness check:** an agent should never need to ask "what's the function 
signature?" or "what abstraction should I use here?" or "what's the database 
schema?" Everything must be explicit and concrete, not inferred from other sections.

## Alternatives Considered

**Goal:** prove the chosen design was actually compared against other
options, not just the first idea that came to mind.

**Must cover:**
- Every serious alternative that was considered, including "do nothing" as
  an explicit option.
- Why each alternative was not chosen.
- The downsides of the option that *was* chosen. Every option has a
  downside, including the chosen one; naming it is what shows the author is
  not emotionally attached to their own decision.

## Blast Radius

**Goal:** state, explicitly, who and what is affected if this design is
wrong, so the reviewer does not have to work this out themselves.

**Must cover:**
- Whether this change stays inside one team, or crosses a team boundary.
  See dev-pipeline.md, "Tiering by team boundary": single-team work can use
  a lighter version of this doc; work that crosses a boundary needs the
  full process, specifically at the interface being frozen.
- What breaks, and who is affected, if a core assumption in this design
  turns out to be wrong.

## Failure Design

**Goal:** design for the ways this will fail, before it fails in
production instead of on paper.

**Must cover:**
- Use the premortem method: assume the system has already failed, then
  work backward to explain why. Do this for each real dependency.
- What happens when a dependency goes down (a database, a third-party API,
  another service this design calls).
- What happens under a traffic spike, e.g. 10x expected load.
- The rollback plan if the failure is discovered after rollout.

**Agent-readiness check:** this section is what lets the agent's own
canary and rollback machinery (dev-pipeline.md, step 7) act correctly
overnight without a human. If failure modes are not named here, the agent
has no basis for automatic rollback decisions.

## Cross-Cutting Concerns

**Goal:** show that security, privacy, and observability were actually
considered, without turning this into a separate full review.

**Must cover:**
- Security implications, if any.
- Privacy implications, if any.
- Observability: what gets logged or measured so the team can tell if this
  is working after it ships.
- **Impact on existing observers, if any.** Anything that currently watches
  a signal this design changes: a dashboard, an alert, a log parser, an
  event subscriber, a webhook consumer. Changing a log format, a metric
  name, or a published event's shape can break something watching it even
  when no caller's behavior changes. If nothing currently observes what
  this design touches, say so.

Keep this section short. Its job is to show the author thought about each
one, not to repeat a full security or privacy review here.

## Implementation Phases (optional)

**Goal:** break a complex rollout into stages, only when the rollout
itself is complex.

**Must cover, if this section is used:**
- The stages of rollout, in order.
- What can be tested or used at each stage before the full feature ships.

**When to skip this section:** if the rollout is not a staged migration or
a gradual traffic shift, skip it. Forcing this section on a simple change
adds length without adding clarity.

## What the Skill Elicits: Decision Log, Consistency & Invariants, and Change Documentation

The Gather phase will surface three things the reviewer needs to see:

### Decision Log (in the doc)
The author explains why each choice was made.
- Every significant decision is recorded with its rationale.
- Includes relevant existing approaches or constraints that influenced the choice.

**Example:**
```
Database for user records: PostgreSQL — because existing auth service 
uses PostgreSQL (consistency with existing approach), and ACID transactions 
are required for financial data.
```

### Consistency & Invariants (threaded through sections)
The author states what the design preserves and what it changes.
- What invariants must never change? (e.g., "all user data in PostgreSQL")
- What constraints does this respect? (e.g., "no new infrastructure required")
- If an invariant is broken, the author explains why and gets explicit approval.

### Change Documentation (complete and explicit)
The author lists every change, even trivial ones.
Nothing is approved implicitly. Everything is traceable.
- Each file that changes: create, modify, delete, rename.
- For modifications: specific function signatures, schema changes, API changes, config keys.

---

## Glossary of Terms

**Goal:** define all technical terms, acronyms, and jargon so readers 
(including the agent) do not have to guess what words mean.

**Must cover:**
- Technical terms specific to this design.
- Acronyms and abbreviations used throughout the doc.
- Domain-specific jargon.
- Any terms that might be ambiguous or have multiple meanings.

**Format:**
```
- **Term**: Definition in plain language.
- **API**: Application Programming Interface — the contract between components.
- **Service mesh**: Infrastructure layer managing service-to-service communication.
```

**Agent-readiness check:** an agent should never encounter a term in this doc 
and not know what it means. If you use a term, define it.

---

## Open Questions

**Goal:** make every unresolved point visible, instead of letting it hide
inside a confident-sounding sentence elsewhere in the doc.

**Must cover:**
- Anything the author is not sure about yet.

**Agent-readiness check:** an empty Open Questions section is not proof
nothing is uncertain. It is only true once every section above has
actually been checked against its own "must cover" list. If the agent
finds an open question during implementation that is not listed here, that
question was missed at doc-approval time, not created by the agent, and it
should be treated as a blocker the same way a listed one would be.

## What the human reviewer is actually approving

Approving this doc in the morning is not proofreading. It means the
reviewer has checked that every "must cover" item above is answered, every
number in Success Metrics is real, and Blast Radius correctly states
whether this crosses a team boundary. Once approved, the agent proceeds
from this doc as the full and final source of intent for the night's
implementation work: see dev-pipeline.md, "Human tasks and agent tasks,"
for what the agent does and does not still need a human for after this
point.
