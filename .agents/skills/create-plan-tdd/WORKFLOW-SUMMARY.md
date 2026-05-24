# Quick Reference: TDD Workflow

## 7-Phase Workflow at a Glance

| Phase | Owner | Input | Output | Duration |
|-------|-------|-------|--------|----------|
| **1. Scope** | Human + Agent | Problem desc | Clear spec with acceptance criteria | ~1-2 turns |
| **2. Design** | Human + Agent | Spec | Design proportional to complexity | ~1-2 turns |
| **3. Validate** | Agent | Design + uncertainty | Tracer bullet results (optional) | ~1 turn if needed |
| **4. Review Direction** | Human | Spec + design + tracer bullet | Approved direction or revisions | ~1 turn |
| **5. Implement** | Agent | Approved plan | Thin vertical slices with TDD | Multiple turns (1-2h each) |
| **6. Verify** | Agent + Human | Implementation | Verified & ready to merge | ~1 turn |
| **7. Merge** | Human | Verified code | Merged & integrated | ~1 action |

## Phase 1: Scope

**Goal:** Crystal-clear task specification

**Include:**
- Problem statement (what user problem?)
- User-visible goal (what should be true?)
- Non-goals (what's explicitly out?)
- Acceptance criteria (3-5 specific behaviors)
- Constraints & dependencies
- Risks
- Rollout/observability notes (if relevant)
- Estimated token size (XS/S/M/L/XL)

## Phase 2: Design

**Goal:** Design proportional to task complexity

**Include:**
- Main approach
- Key interfaces/boundaries
- Dependency order
- Data/migration implications
- Backward compatibility concerns
- Test strategy
- Operational considerations

**Keep it lightweight.** Only invest in deeper design if task is cross-cutting, high-risk, or hard to reverse.

## Phase 3: Validate (Conditional)

**Goal:** Reduce uncertainty before big investment

**Only when uncertainty is meaningful.** Use:
- Tracer bullet (minimal end-to-end example)
- Spike (explore unknown territory)
- Minimal experiment (test assumption)

**Skip if the path is already clear.**

## Phase 4: Review Direction

**Goal:** Get human approval before implementation

**Human reviews:**
- Is the boundary correct?
- Are the slices sensible?
- Are acceptance criteria sufficient?
- Are risks understood?

**Output:** Approved direction or revisions to plan.

## Phase 5: Implement

**Goal:** Build in thin, reviewable vertical slices

**TDD Pattern:**
1. Start with failing acceptance test
2. Add smaller tests only where they drive design
3. Implement minimum code to pass
4. Refactor
5. Move to next slice

**Rules:**
- Each slice = one meaningful behavior
- One acceptance test per behavior
- Keep changes small and reviewable
- Target: 1-2 hours per slice
- No speculative abstractions

## Phase 6: Verify

**Goal:** Confirm quality and merge-readiness

**Verify:**
- ✓ Acceptance tests pass
- ✓ Lower-level tests are appropriate & non-redundant
- ✓ Logging/metrics added where useful
- ✓ Feature flags used where rollout risk justifies
- ✓ Migrations safe
- ✓ Backward compatibility preserved
- ✓ Failure modes understandable
- ✓ Risks documented

## Phase 7: Merge

**Goal:** Integrate approved work

**Conditions for merge:**
- Behavior matches spec
- Changes are reviewable
- Rollout risk is acceptable
- Change is reversible or well-contained

## Token Sizing

| Size | Tokens | Characteristics |
|------|--------|-----------------|
| **XS** | 5-15k | Tiny, crystal clear, isolated |
| **S** | 15-30k | Small, straightforward |
| **M** | 30-80k | Medium complexity |
| **L** | 80-150k | Large, uncertain, coordination-heavy |
| **XL** | 150k+ | Very large, high-risk, exploratory |

**Increase size if:** Unclear spec, research required, high uncertainty, cross-cutting, migration complexity, operational complexity

**Decrease size if:** Clear spec, similar to existing, isolated, known patterns, minimal rollout risk

## Escalation Triggers

**Re-scope or escalate when:**
- Acceptance criteria become materially unclear
- Scope changes meaningfully
- New dependency appears
- Tracer bullet disproves plan
- Rollout/migration/compatibility risk increases
- Task can no longer be completed as small slice

**Don't silently continue on a broken plan.**

## Anti-Patterns to Avoid

- ❌ Big bang implementation
- ❌ Vague specs
- ❌ Hidden coupling
- ❌ Literal production data in tests
- ❌ Large brittle fixture systems
- ❌ Excessive end-to-end coverage
- ❌ Duplicate tests across layers
- ❌ Speculative abstraction
- ❌ Silent scope creep
- ❌ Patching wrong direction instead of re-planning

## Test Data

**Good test data is:**
- Production-shaped (looks real)
- Canonical (the right example for the behavior)
- Deterministic (same every run)
- Maintainable (small, understandable)

**Avoid:**
- Literal production data
- Oversized fixture forests
- Brittle setup
- Toy examples that hide real behavior

## Acceptance Test Rules

**A good acceptance test:**
- Covers one meaningful behavior
- Has clear pass/fail condition
- Uses realistic deterministic data
- Avoids unnecessary full-stack brittleness
- Maps cleanly to ticket completion

**Prefer:** Small number of high-signal tests over large slow suite

## TDD Pattern

**Pragmatic outside-in TDD:**
1. Write highest-value **failing** acceptance test
2. Add smaller tests **only where useful** to drive design
3. Implement **minimum** code to pass
4. **Refactor**
5. Move to next slice

**Don't force:**
- API tests for everything
- Unit tests for every method
- Duplicate coverage across layers
