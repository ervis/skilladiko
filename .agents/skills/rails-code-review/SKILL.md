---
description: Review Ruby code for clean code principles and improve readability and maintainability
name: rails-code-review
---

## Rails Architecture & Design Review

## Purpose
Review Rails code for architecture, design, maintainability, performance, and safety.

## Focus
- SOLID and Rails conventions
- clear ownership and boundaries
- testability
- explicit contracts
- input validation
- transactional correctness
- minimal branching and mutation
- functional core, imperative shell
- separating refactors from abstraction changes
- misuse resistance and common-path ergonomics
- query efficiency, batching, migrations, and caching
- data volume awareness

## Mindset
- Prefer simple, idiomatic Rails code that is easy to read and test.
- Prefer small, focused objects with clear responsibilities.
- Prefer design by contract: validate at boundaries, trust internal invariants.
- Prefer branch-light, mutation-light implementations.
- Prefer methods as small abstractions.
- Prefer explicit expected-error handling and clear transaction scope.
- Prefer PRs that separate behavior changes, refactors, and abstraction changes.
- Prefer designs that make the common path easy, incorrect usage hard, and abuse difficult or impossible when practical.
- Prefer solutions sized appropriately for expected data volume.

## Review scope
Controllers, models, services, jobs, policies, serializers, forms, concerns, migrations, queries, caches, and cross-file workflows.

## Core guidance

### Controllers
Keep thin. Handle auth, params, and response.

### Models
Keep record-level rules and validations. Avoid god objects and orchestration.

### Use case / service objects
Use for non-trivial workflows. Keep them single-purpose, explicit, branch-light, and easy to test.

### Concerns
Use sparingly. Only when cohesive and truly shared.

### Forms / jobs / mailers / policies / serializers
Keep narrow. Avoid hidden orchestration and duplicated rules.

### Input validation
Validate high in the stack. Internal methods may trust established contracts unless they cross a new boundary.

### Transactions
Be explicit about what is inside vs outside a transaction. Avoid hidden rollback boundaries and side effects that escape atomic work.

### Errors
Separate expected failures from unexpected failures.
- Expected: business rejection, validation, known domain errors
- Unexpected: bugs, infrastructure failures, programmer mistakes

Handle expected failures explicitly. Do not swallow unexpected ones.

### Refactors vs abstractions
Flag PRs that mix mechanical refactoring with abstraction changes or behavior changes. Prefer smaller PRs when possible.

### Misuse resistance
Make the intended path obvious. Make incorrect usage hard. Make abusive or boundary-bypassing usage difficult or impossible when practical.

### Performance, scale, and data access
Check query efficiency, batching, migration safety, and caching tradeoffs.
- avoid N+1s and unbounded scans
- prefer bounded, indexed queries
- batch large reads/writes
- make migrations safe and reversible
- cache only when justified by cost, staleness tolerance, and invalidation strategy

### Data volume
Ask for expected data volume when it affects design:
- number of records
- request rate
- growth rate
- cache size
- migration size
- background job volume
- memory / latency constraints

## What to flag
- fat controllers or models
- unclear ownership
- duplicated business logic
- hidden side effects
- broad or generic service objects
- overuse of concerns
- unclear contracts
- redundant validation in internal layers
- excessive branching
- unnecessary mutation
- unclear transaction scope
- swallowed unexpected exceptions
- PRs that mix refactoring and abstraction changes
- designs that are easy to misuse or abuse
- inefficient queries or data loading
- unsafe migrations
- missing batching for large data
- unnecessary or poorly invalidated caching
- designs that ignore expected data volume

## What not to flag
- simple idiomatic Rails code
- clear delegation to a use case object
- cohesive concerns
- direct ActiveRecord usage when it is clearest
- localized callbacks
- small abstractions that improve clarity
- internal methods that trust validated contracts
- separate PRs for refactors and abstraction changes

## Review behavior
If context is missing, ask targeted questions. Do not guess about:
- valid inputs
- caller guarantees
- expected vs unexpected errors
- transaction scope
- side effects
- whether an object is shared or internal-only
- whether the PR changes behavior or abstraction
- whether the full change set has been reviewed
- how the design could be misused or abused
- expected data volume or growth

## Output
For each finding, include:
- severity
- file/line
- problem
- principle/convention
- recommendation
- tradeoff

End with:
- overall assessment
- top 3 priorities
- what is already good
