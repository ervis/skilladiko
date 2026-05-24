# /create-plan-tdd

Create a detailed implementation plan using pragmatic outside-in TDD workflow. If questions arise, interview you with `/grill-me` until plan is solid.

**Dependencies:** Requires `/grill-me` skill for clarification when needed.

## What It Does

1. **Creates a TDD-focused plan** using the `create-plan` agent with:
   - Acceptance tests at API/contract boundaries
   - Thin vertical slices 
   - Outside-in TDD approach
   - Small, reviewable increments
   - Clear acceptance criteria

2. **If there are gaps or questions**, automatically switches to `/grill-me` to:
   - Challenge your assumptions
   - Clarify acceptance criteria
   - Explore edge cases
   - Validate scope and boundaries
   - Resolve ambiguity before planning

## How to Use It

Provide what you know:

```
/create-plan-tdd

I need to add webhook support to our API.

Problem: Users want to subscribe to events without polling.

Acceptance Criteria:
- POST /webhooks creates a webhook with URL and event types
- Webhook fires with JSON payload when subscribed event occurs
- Failed deliveries retry with exponential backoff

Scope: MVP only. Auth assumed.

Risks: MITM attacks on webhook URLs
```

The skill will:
- Ask clarifying questions if acceptance criteria are vague
- Grill you on scope boundaries if unclear
- Challenge assumptions if risky
- Then generate a solid TDD plan

## Plan Output Includes

- **Scope** - Crystal clear spec with acceptance criteria
- **Design** - Lightweight design matching task complexity
- **Validate** - Optional tracer bullet strategy if uncertainty exists
- **Review Direction** - Confirmed boundaries and slices
- **Implementation Slices** - Thin vertical slices with TDD approach
- **Verification Checklist** - What must pass before merge
- **Token Estimate** - XS/S/M/L/XL sizing

## Key Workflow Principles

1. **Define done by external behavior** - API/contract-level acceptance criteria
2. **No big bang delivery** - Vertical slices, keep reviewable
3. **Validate assumptions early** - Grill uncertain parts
4. **Small scope** - Solve one problem, 1-2 hours per slice
5. **Pragmatic TDD** - Outside-in from acceptance tests
6. **Composable design** - Clean interfaces, explicit dependencies
7. **Operational quality** - Observability, safety, backward compatibility

## When Grill-Me Triggers

The skill automatically invokes `/grill-me` (dependency) if:
- Acceptance criteria are too vague
- Scope boundaries are fuzzy
- Risks aren't fully explored
- Dependencies unclear
- Design tradeoffs not justified
- Non-functional requirements missing

This ensures the plan is solid before implementation starts.

**Note:** Make sure you have the `/grill-me` skill available in your environment for this skill to work properly.

## Token Sizing

- **XS** (5-15k) - Tiny, crystal clear, isolated
- **S** (15-30k) - Small, straightforward
- **M** (30-80k) - Medium complexity
- **L** (80-150k) - Large, uncertain, coordination-heavy
- **XL** (150k+) - Very large, high-risk, exploratory

## Documentation

For complete reference, see `.agents/skills/create-plan-tdd/`:
- **WORKFLOW.md** - Full TDD workflow phases
- **WORKFLOW-SUMMARY.md** - Quick reference & checklists
- **TASK_TEMPLATE.md** - How to structure tasks
- **PRINCIPLES.md** - Core decision-making values
