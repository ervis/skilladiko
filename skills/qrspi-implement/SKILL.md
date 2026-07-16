---
description: Execute the plan phase by phase with verification checkpoints
argument-hint: "[artifact_path/]"
---

# Implement — Execute the Plan

Implement the plan one phase at a time, verifying each phase before proceeding. Update the plan's checkboxes as you go — they are your progress tracker and context-recovery mechanism.

## Input

If no artifact path is provided, `$ARGUMENTS` is the current directory (`.`).

Read `$ARGUMENTS/plan.md`. That is your primary working document.
If `$ARGUMENTS/plan.md` does not exist, stop immediately and respond: "Cannot find plan.md at [resolved path]. Please run from the artifact directory or pass its path, then re-run." Do not attempt to create or infer a plan.

## Process

1. **Read `plan.md` fully.** Check for existing checkmarks (`- [x]`) — if some phases are already complete, pick up from the first unchecked item.

2. **Read all files referenced in the current phase** before making changes. Understand the code you're modifying.

3. **Implement one phase at a time:**
   - Make the changes described in the plan
   - If divergence can be resolved by changing only implementation details of the current phase (for example, a renamed variable or a moved file), adapt and continue.
   - If divergence requires changing the approach, interfaces, or assumptions of any other phase, stop and present it:
     ```
     Issue in Phase [N]:
     Expected: [what the plan says]
     Found: [actual situation]
     Impact: [what this means for the plan]

     How should I proceed?
     ```

4. **After completing a phase, run verification:**
   - If a phase has no automated verification commands listed, skip automated verification, note its absence in the pause message, and proceed to the commit step
   - Execute the automated verification commands from the plan
   - Fix any failures before proceeding
   - If you cannot fix a verification failure after one round of changes, stop and report the failing command, its output, and what you tried. Do not proceed past a failing check.
   - Check off automated items in `plan.md` using Edit: `- [ ]` becomes `- [x]`

5. **Commit the phase** after automated verification passes. Each phase should be a separate commit so it can be independently reverted if later phases break something. Use a descriptive message like `"Phase N: [phase name from plan]"`.
   - If the commit command fails, report the exact error to the user and pause. Do not proceed to the next phase with an uncommitted state.

6. **Pause for manual verification** (unless told to continue through multiple phases):
   ```
   Phase [N] complete — ready for manual verification.

   Automated checks passed:
   - [x] [list what passed]

   Please verify manually:
   - [ ] [manual items from the plan]

   Let me know when done, and I'll proceed to Phase [N+1].
   ```

7. **Repeat** for each phase until the plan is complete.

## Resuming After Context Reset

If you're starting fresh in a new context window:
- Read `plan.md` — checked boxes show what's done
- Trust completed work unless something seems off
- Pick up from the first unchecked item

## Output

- Code changes implemented according to the plan
- `plan.md` updated with checked verification items
- Tell the user: "Next: run `/qrspi-pr`"

## Rules

- One phase at a time. Do not skip ahead.
- Read before you write. Understand existing code before changing it.
- Update checkboxes as you go — they are the source of truth for progress.
- Do not check off manual verification items until the user confirms.
- If the plan has errors, or a divergence requires changes beyond the current phase, stop and ask. Do not silently deviate.
- Only make changes described in the plan. Do not refactor, clean up, or "improve" code you encounter along the way — even if it's messy. If you see something worth fixing, note it for the user after the phase is done.
- Do not spawn sub-agents during normal implementation. Use a sub-agent only when a test failure cannot be diagnosed from the error output alone, or when a referenced file is not in the plan and its purpose is unknown. Limit to one sub-agent call per phase.
- Commit after each phase passes automated verification — one commit per phase.

## When to Go Back

If divergence can be resolved by changing only implementation details of the current phase (for example, a renamed variable or a moved file), adapt and continue, and note the adjustment in the pause message. If it requires changing the approach, interfaces, or assumptions of any other phase, stop and tell the user, then suggest re-running `/qrspi-plan` or `/qrspi-design` with the new information rather than building on a broken foundation.
