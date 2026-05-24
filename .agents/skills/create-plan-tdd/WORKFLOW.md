# TDD/Outside-In Workflow

How we build with humans and agents. Optimized for correctness, reviewability, incremental delivery, and efficient use of tokens.

## Core Principles

1. **Define done by external behavior** - Prefer API- or contract-level acceptance criteria for user-visible work
2. **No big bang delivery** - Build in thin vertical slices, keep changes reviewable, and prefer frequent integration
3. **Validate assumptions early** - Test feasibility before investing heavily when uncertainty is meaningful
4. **Progress must be visible** - Work should be easy to reason about, review, and verify
5. **Small scope** - Each task should solve one problem with minimal hidden coupling
6. **Composable design** - Prefer clean interfaces and explicit dependencies over entangled implementation
7. **Pragmatic TDD** - Use outside-in TDD where it helps, and smaller internal TDD loops where they add clarity
8. **Operational quality matters** - Consider observability, migration safety, backward compatibility, and rollback
9. **Avoid process theater** - Adopt high-signal engineering discipline, not unnecessary ceremony

## Default Delivery Model

For most product or externally visible work, use a pragmatic outside-in workflow:

1. Start from a small set of **acceptance tests** at the API or contract boundary
2. Implement **one vertical slice at a time**
3. For each slice, make the acceptance test fail first
4. Then add smaller unit/integration tests only as needed to drive implementation
5. Implement the minimum necessary code to pass
6. Refactor before moving to the next slice

When all acceptance tests pass and non-functional requirements are satisfied, the task is complete.

This is the default, not a rigid rule. For internal refactors, infrastructure work, parsers, low-level libraries, or algorithm-heavy changes, the outer test boundary may be lower than the API layer.

## Test Data Policy

Use **realistic, canonical, deterministic** data.

Prefer:
- Production-shaped examples
- Domain-realistic fixtures
- Canonical edge cases
- Small datasets that are easy to understand and maintain

Avoid:
- Literal production data
- Oversized fixture forests
- Brittle test setup
- Toy examples that hide real behavior

The goal is realism without nondeterminism, privacy risk, or maintenance overhead.

## Workflow Phases

### 1. Scope (Human + Agent)

Write a short but explicit task specification.

Include:
- Problem statement
- User-visible goal
- Non-goals
- Acceptance criteria
- Constraints
- Dependencies
- Risks
- Rollout / observability notes when relevant
- Estimated token size (XS/S/M/L/XL)

Output: a clear spec with minimal ambiguity.

### 2. Design (Human + Agent)

Create a design before implementation.

Document:
- Proposed approach
- Main interfaces or boundaries
- Dependency order
- Data and migration implications
- Backward compatibility concerns
- Test strategy
- Operational considerations

Design depth should match the scope, risk, and complexity of the task.
Use lightweight design by default, and invest in deeper design only when the change is cross-cutting, high-risk, or difficult to reverse.

Output: a design that makes implementation and review easier.

### 3. Validate (Conditional - Agent)

Only do this when uncertainty is meaningful.

Use a tracer bullet, spike, or minimal experiment to validate:
- Feasibility
- Assumptions
- Integration points
- Unknown risks

Spend tokens here only when it reduces larger downstream waste.

Skip when the path is already clear.

### 4. Review Direction (Human)

Review the spec, design, and any tracer bullet if one was needed.

Ask:
- Is the boundary correct?
- Are the slices sensible?
- Are acceptance criteria sufficient?
- Are the risks understood?

Feedback should be concrete. Approve direction or revise it.

### 5. Implement (Agent)

Implement in thin vertical slices.

Rules:
- Each slice should represent a meaningful increment
- Prefer one acceptance test per behavior
- Implement in dependency order
- Make the current acceptance test fail first
- Add lower-level tests only where they help drive the current slice
- Avoid speculative abstractions
- Keep changes small and reviewable
- Prefer code that is easy to reason about, test, and revert

For larger work, tasks should usually be completable in about 1-2 hours of focused implementation effort.

### 6. Verify (Agent + Human)

Before merge, verify:
- Acceptance tests pass
- Lower-level tests are appropriate and not redundant
- Logging/metrics are added where useful
- Feature flags are used where rollout risk justifies them
- Migrations are safe
- Backward compatibility is preserved where required
- Failure modes are understandable
- Manual verification is documented when relevant
- Risk changes are understood and documented when they occur

### 7. Merge (Human)

Final review and merge when:
- The behavior matches the spec
- The slice is reviewable
- The rollout risk is acceptable
- The change is reversible or well-contained

## Task Design

Each task should be:

- **Crystal clear** - Little or no interpretation required
- **Externally grounded** - Done is tied to observable behavior where appropriate
- **Small** - Usually completable in 1-2 hours
- **Testable** - Acceptance criteria can be verified
- **Independent** - Can be reviewed and merged on its own
- **Composable** - Builds cleanly on previous work
- **Reviewable** - Small enough for fast, high-quality review
- **Reversible** - Safe to revert or isolate if needed

## Acceptance Test Guidance

Use API- or contract-level acceptance tests by default for user-visible behavior.

A good acceptance test:
- Covers one meaningful behavior
- Has a clear pass/fail condition
- Uses realistic deterministic data
- Avoids unnecessary full-stack brittleness
- Maps cleanly to ticket completion

Do not create excessive acceptance coverage. Prefer a small number of high-signal tests over a large suite of slow or overlapping tests.

## TDD Guidance

Use **pragmatic outside-in TDD**.

Recommended pattern:
1. Start with the highest-value failing acceptance test for the current slice
2. Add smaller tests only where useful to drive design or protect non-trivial logic
3. Implement the minimum needed to pass
4. Refactor
5. Move to the next slice

Do not force:
- API-level tests for every kind of work
- Unit tests for every tiny method
- Duplicate coverage across every layer

The purpose of TDD here is guidance and feedback, not ceremony.

## Escalation Rules

Escalate or re-scope when:
- Acceptance criteria are materially unclear
- Scope changes meaningfully
- A new dependency appears
- A tracer bullet disproves the plan
- Rollout, migration, or compatibility risk increases
- A task can no longer be completed as a small reviewable slice

Do not silently continue on a broken plan.

## Token Estimation (T-Shirt Sizes)

Estimate when creating a task based on clarity, complexity, uncertainty, and dependency weight.

- **XS** - ~5-15k tokens (tiny, crystal clear, isolated)
- **S** - ~15-30k tokens (small, straightforward)
- **M** - ~30-80k tokens (medium, moderate complexity)
- **L** - ~80-150k tokens (large, uncertain, or coordination-heavy)
- **XL** - ~150k+ tokens (very large, high-risk, exploratory)

### Factors that increase size
- Unclear spec
- Research or codebase exploration required
- High uncertainty
- Cross-cutting dependencies
- Migration or compatibility constraints
- Operational complexity

### Factors that decrease size
- Clear spec
- Similar to existing code
- Isolated scope
- Known patterns
- Minimal rollout risk

## Execution

1. Create a clear task spec
2. Write a design proportional to the task
3. Estimate token size
4. Define a small set of acceptance tests when appropriate
5. Implement in thin vertical slices
6. Integrate in small reviewable increments
7. Verify behavior, quality, operational safety, and merge readiness
8. Merge

## Progress Tracking

Progress should be visible through completed behavior and reviewable increments.

Track:
- Acceptance criteria closed
- Acceptance coverage status
- Small reviewable increments merged or ready for review
- Explicit dependency order for sequencing
- Risks and blockers when they affect delivery

Do not leave incomplete, ambiguous, or partially validated work in the main branch.

## Anti-Patterns

Avoid:
- Big bang implementation
- Vague specs
- Hidden coupling
- Literal production data in tests
- Large brittle fixture systems
- Excessive end-to-end coverage
- Duplicate tests across every layer
- Speculative abstraction
- Process overhead without signal
- Silent scope creep
- Patching fundamentally wrong directions instead of resetting the plan

If direction is wrong, fix the plan and re-slice the work rather than layering more complexity onto a bad foundation.

## Principles

See PRINCIPLES.md for core values such as stability, efficiency, and correctness.

This workflow operationalizes those values in a way that is optimized for both human and agent execution.
