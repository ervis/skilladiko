# Core Principles

Core values that guide your implementation planning and execution.

## Stability Over Features

Stability is the foundation. Users depend on your work for critical workflows.

- Once released, APIs remain stable
- Breaking changes happen only in major versions
- Deprecations come with a full release cycle of notice
- Every change is tested with real-world scenarios

## Clear Before Fast

Document and design before coding.

- Write detailed specs for each task (not vague requirements)
- Define acceptance criteria explicitly
- Sketch architecture before implementation
- Design decisions are recorded (not buried in commits)

## Test Thoroughly

Tests verify reality, not intentions.

- Write tests against actual scenarios
- Test edge cases, not just happy paths
- Every feature has comprehensive test coverage
- Tests remain as documentation

## Respect Dependencies

Follow the order. Earlier phases unblock later ones.

- Complete phase dependencies before starting new work
- Don't skip steps or take shortcuts
- If blocked, document why, don't work around it
- Parallelize only truly independent work

## Transparent About Tradeoffs

Every decision has costs. Own them.

- Document why we chose path A over path B
- Explain limitations honestly (don't hide them)
- Acknowledge what we sacrificed for what we gained
- Future maintainers should understand the reasoning

## Simple Over Complete

Do the minimum that solves the problem.

- Add features when needed, not when possible
- Avoid premature abstraction
- Start with one case, not ten
- Expand scope only when current scope is working

## Keep Userspace Safe

Users build systems on top of your code. Don't break them.

- No silent changes to behavior
- API contracts are sacred
- Errors are explicit, not hidden
- Version correctly (semantic versioning)
