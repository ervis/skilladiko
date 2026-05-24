# Task Template

Use this template for new implementation tasks. Keep it short, explicit, and execution-focused.

Store the planning doc in `docs/design/` before starting, or in your issue tracker. Move key decisions to `docs/task-logs/` once the task is complete.

## Title

Short, specific description of the task.

## Problem

What problem are we solving? Describe the user-visible or system-visible issue in plain language.

## Goal

What should be true when this task is complete?

## Non-Goals

What is explicitly out of scope?

- 
- 
- 

## Acceptance Criteria

List the small number of behaviors that define done.

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2
- [ ] Acceptance criterion 3

## Acceptance Test Plan

Describe the highest-value API- or contract-level tests for this task.

### Test 1
- Behavior:
- Boundary:
- Input / setup:
- Expected result:

### Test 2
- Behavior:
- Boundary:
- Input / setup:
- Expected result:

### Test 3
- Behavior:
- Boundary:
- Input / setup:
- Expected result:

Only include as many tests as needed. Prefer a few high-signal tests.

## Data Plan

Describe the test data strategy.

- Canonical examples:
- Edge cases:
- Why this data is realistic and deterministic:

Avoid literal production data. Prefer production-shaped, canonical, maintainable examples.

## Design Notes

Keep this lightweight.

- Main approach:
- Key interfaces / boundaries:
- Dependency order:
- Risks:
- Backward compatibility concerns:
- Rollout / observability notes:

## Implementation Slices

Break the task into thin vertical slices.

### Slice 1
- Goal:
- Acceptance test covered:
- Dependencies:
- Expected size: XS / S / M / L / XL

### Slice 2
- Goal:
- Acceptance test covered:
- Dependencies:
- Expected size: XS / S / M / L / XL

### Slice 3
- Goal:
- Acceptance test covered:
- Dependencies:
- Expected size: XS / S / M / L / XL

## Lower-Level Test Strategy

For each slice, add smaller unit/integration tests only where they help drive the implementation or protect non-trivial logic.

- Slice 1:
- Slice 2:
- Slice 3:

Avoid redundant tests that add maintenance cost without improving confidence.

## Operational Checklist

Include only what is relevant.

- [ ] Logging considered
- [ ] Metrics considered
- [ ] Feature flag considered
- [ ] Migration safety considered
- [ ] Backward compatibility considered
- [ ] Rollback path considered
- [ ] Manual verification steps documented

## Size Estimate

- Size: XS / S / M / L / XL
- Why:

## Definition of Done

The task is done when:

- [ ] Acceptance criteria are met
- [ ] Acceptance tests pass
- [ ] Lower-level tests are sufficient and not redundant
- [ ] Code is reviewable and appropriately scoped
- [ ] Operational concerns are addressed where relevant
- [ ] Risks and limitations are documented
