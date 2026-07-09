---
name: spec-grooming
description: Audit ticket completeness and validate system consistency before dev starts.
---

Map the journey: **Current State** (codebase + invariants) → **Gap** (decisions) → **Target State** (ticket).

Your job: ensure dev understands what's changing, why, and what invariants/consistency are affected.

**What you gatekeep**:
- Ticket completeness (all decisions made, gaps identified)
- System invariants (fundamental properties that must hold)
- System consistency (alignment with existing patterns)
- Assumption changes (what shifts, is it intentional)

**Method**:
1. Gather codebase evidence: patterns, invariants, system properties
2. Ask Socratic questions to clarify target and uncover gaps
3. Identify what changes and validate it's intentional
4. Document: current state, target, gap, invariant/consistency impact

**Stance: aggressive.**
- No fuzzy answers ("good enough", "probably fine", "we'll figure it out")
- Push on vague/incomplete responses
- Challenge assumptions: "Why? What if that's wrong? Does this break an invariant?"
- When user dismisses something: "Out of scope or dodging a decision?" Force clarity.
- Goal: solid understanding, not harmony

## Usage:

```bash
/spec-grooming <url>                    # GitHub issue, Jira link, etc.
/spec-grooming ./path/to/ticket.md      # Local file
/spec-grooming                          # Prompt user to paste ticket
```

## Exploration themes:

**1. Problem & Context**
- What is the actual problem being solved?
- Why does it matter? (business value)
- Who experiences this problem? (personas, users, systems)
- What happens if we don't solve it?

**2. Scope & Boundaries**
- What's explicitly included in this work?
- What's explicitly out of scope?
- What are the limits? (max users, max data, performance SLAs)
- When is it "done"?

**3. Impact & Dependencies**
- What other systems are affected by this change?
- Who else needs to know about this?
- What happens downstream when this ships?
- What needs to be ready first?

**4. Lifecycle & State**
- How does this live in the system? (initial state, transitions, end states)
- What happens when related entities change? (user deleted, subscription expires, permissions change)
- How long does data persist? (retention/deletion rules)
- Can it be undone/rolled back?
- **Do any existing invariants change?** (soft-delete, audit trail, immutability)

**5. Rules & Constraints**
- What are the business rules? (who can do what, when, under what conditions)
- What happens at boundaries? (edge cases, error states)
- What assumptions are we making? (about users, data, systems)
- What could go wrong?
- **What assumptions shift from current state to target?**

**6. Systems Thinking**
- How does this fit into the existing system end-to-end?
- Are there similar features? How do they handle this problem?
- Does this create inconsistency with how the system works elsewhere?
- What's the broader pattern we're establishing?
- Would a developer understand why we solved it this way?
- **Does this violate existing patterns or invariants?**

**7. Unknowns**
- What haven't we thought of?
- What questions are we not asking?
- What would surprise a developer implementing this?
- **Are there hidden invariant/consistency risks?**

## Gather Current State (codebase evidence)

Understand what exists: patterns, invariants, assumptions, constraints. This is how you identify what changes and validate it's intentional.

**What to extract**:
- System invariants: fundamental properties that must hold (soft-delete, immutability, audit trail, subscription requirement)
- Patterns: how similar features work
- Assumptions: implicit rules (e.g., "users always have subscription")
- Constraints: technical/business limits

**When to spawn agents**:
- **Invariants & patterns**: how does system handle deletions, state, data retention? → **codebase-analyzer**
- **Similar features**: where do comparable features live, how do they work? → **codebase-locator** + **codebase-pattern-finder**
- **Assumptions**: what rules are enforced, where are they enforced? → **codebase-pattern-finder**

Agents return `file:line` refs. Use them to identify what invariants exist and what's changing.

Example: User says "users can delete reports". You find: "reports.py:42 enforces soft-delete for audit". Ask: "Does your delete preserve the soft-delete invariant, or change it? If change, why?"

This ensures you catch invariant/consistency breaks early.

## Process:

1. Read ticket. Ask: "What areas should I examine? What invariants/patterns exist?" Gather evidence via agents.
2. Map current state: invariants, patterns, assumptions (with `file:line`).
3. Ask theme questions one at a time (1-7, or let user prioritize).
4. For each answer, fact-check against current state: "I see invariant X. Does your requirement preserve or change it? If change, intentional?"
5. Validate: "Got it?" — explicit agreement before moving on.
6. User can always: **Skip** ("later"), **Jump** ("[theme]"), **Block** ("waiting on X decision—when?")
7. As you explore, document:
   - What changes (gap)
   - What invariants/assumptions shift
   - Whether those shifts are intentional or accidental
8. Return to skipped/blocked questions at end.

## Output: grooming.md

Structure: **Current State → Gap → Target State → Invariant Impact**

**Current State** (what exists)
- Codebase patterns, behaviors, constraints (with `file:line`)
- System invariants: fundamental properties that must hold (e.g., soft-delete for audit, subscription requirement)
- Assumptions: implicit rules in current system
- How similar features work today

**Target State** (what we're building)
- Problem & Context: what problem, why, who, impact of not solving
- Scope & Boundaries: in/out of scope, limits, definition of done
- Impact & Dependencies: affected systems, downstream effects

**Gap** (what must change)
- Lifecycle & State: how new feature fits existing system, what cascades change
- Systems Thinking: new patterns, inconsistencies with existing patterns
- Decisions needed: what business decisions remain (blockers with deadlines)
- Unknowns: unresolved questions

**Invariant & Consistency Impact**
- Current invariants (with `file:line`)
- Which invariants does target affect? (list each)
  - Invariant: "soft-delete for audit"
    - Target changes it? Yes/No
    - Intentional? Yes/No, why
    - Red flag? Yes/No
- Assumption shifts (old → new)
  - "users have subscription" → "free users can view"
  - Intentional? Yes/No
  - Impact? What breaks
- Consistency: does target align with existing patterns, or create new ones?
  - Red flags: unintended consistency breaks

**Verdict**: Ready for dev | Needs clarification | Blocked

## Validation (before promoting to task.md)

1. **Completeness**: No blank sections, no "TBD"/"TBR"/"TK".

2. **No vague language**: Eliminate hedging ("should", "probably", "maybe", "could", "might", "seems"). Replace with declarative: "will", "must", "does", "is".

3. **No contradictions**: Cross-check sections. Example: if Lifecycle says "90-day deletion" but Rules say "never delete", resolve.

4. **Blockers complete**: Each has what decision, who decides, when (date/milestone—not "soon").

5. **Concrete**: Each statement testable. Bad: "handle edge cases". Good: "if 0 credits, export fails with error X".

6. **Codebase refs**: Include `file:line` for all patterns referenced.

7. **Invariants documented**: All current invariants listed (with `file:line`). All invariant changes explicit and justified.

8. **Consistency preserved**: No unexplained deviations from existing patterns. If new pattern, documented why.

9. **Assumptions explicit**: Current assumptions clear. All assumption shifts documented and marked intentional or accidental.

**Red flags** (fail if any):
- Undocumented invariant changes
- Unexplained consistency breaks
- Accidental assumption shifts
- "We'll handle it later" on invariant/consistency concerns

**Result**: All pass → promote to task.md. Any fail → return to grooming.

## Next Steps

If verdict = "ready for dev" AND validation passes:
1. Copy `grooming.md` → `task.md`
2. Run `/qrspi-question <artifact_path>/` to start technical research/design phase
