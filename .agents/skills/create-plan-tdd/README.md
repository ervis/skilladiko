# create-plan-tdd Skill

Create a detailed implementation plan using pragmatic outside-in TDD workflow.

## Dependencies

- **Required:** `/grill-me` skill — Used for clarifying unclear specifications and validating assumptions before planning

## What This Skill Does

When you invoke `/create-plan-tdd`, it helps you create a structured implementation plan following TDD/outside-in workflow principles:

- Starting with acceptance tests at API/contract boundaries
- Building thin vertical slices with one meaningful behavior per slice
- Test-first approach: make failing acceptance test, then implement minimum code
- Small, reviewable changes (1-2 hours each)
- Clear external behavior definitions

## How to Use

When you invoke this skill, provide:

1. **Problem statement** - What user problem are you solving?
2. **Acceptance criteria** - What does success look like at the API/contract level?
3. **Scope and constraints** - What's in/out of scope?
4. **Known risks or dependencies** - What could go wrong?

The skill will help you create a plan with:
- Clear task specification
- Design proportional to complexity
- Acceptance test strategy
- Thin vertical slices with clear boundaries
- Token size estimate (XS/S/M/L/XL)

## Documentation

This skill includes:
- `WORKFLOW.md` - Full workflow phases and guidance
- `TASK_TEMPLATE.md` - Template for structuring tasks
- `PRINCIPLES.md` - Core values and decision-making framework
- `WORKFLOW-SUMMARY.md` - Quick reference guide

## Quick Start

1. Gather your problem statement and acceptance criteria
2. Invoke `/create-plan-tdd`
3. Follow the workflow phases: Scope → Design → Validate → Review → Implement → Verify → Merge
4. Use TASK_TEMPLATE.md to structure your work
5. Reference PRINCIPLES.md for decision-making

## Key Workflow Phases

1. **Scope** - Crystal clear spec with acceptance criteria
2. **Design** - Lightweight design matching complexity
3. **Validate** - Tracer bullet if uncertainty is meaningful
4. **Review Direction** - Confirm spec and slice boundaries
5. **Implement** - Execute thin vertical slices with TDD
6. **Verify** - Acceptance tests pass, quality checks done
7. **Merge** - Ready for integration
