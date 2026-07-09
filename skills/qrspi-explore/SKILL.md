---
description: Iterative research exploration — one question per round, research it, Socratically probe the answer, refine until complete or capped
model: opus
argument-hint: "<artifact_path>/"
---

# Explore — Iterative Research Discovery

Transform a task description into complete research findings through iterative single-question rounds: ask one question, research it, then Socratically probe the answer to drive the next question. Coordinates with qrspi-research to progressively refine `questions.md` and `research.md` until completeness or max rounds reached.

## Input

Same as qrspi-question:
- Task description, ticket file path, or issue reference
- No grooming.md required

## Process

### Round 1: Initial Question

1. **Read the task/ticket fully.**

2. **Generate one initial research question** (sequential — one thread at a time):
   - Pick the single most foundational unknown to open the thread.
   - Neutral fact-seeking ("how does X work?", not "how should we do X?")
   - Aim it at evidence on: 
     - Current patterns and how similar features work
     - System invariants (soft-delete, audit trails, immutability, subscription requirements, etc.)
     - Technical & business constraints (limits, SLAs, dependencies)
     - Implicit assumptions in the current system
     - How these interact and where they might conflict

3. **Call `/qrspi-research <artifact_path>/`** to answer the question
   - Wait for research.md to be written
   - qrspi-research will spawn codebase agents to explore

4. **Review the answer and grade its strength**:
   - **Invariants**: Are all system invariants documented and their enforcement clear? If unclear → red flag.
   - **Constraints**: Are technical/business constraints identified and understood? If vague → red flag.
   - **Assumptions**: Are implicit assumptions in the system explicit and validated? If unstated → red flag.
   - **Patterns**: Are current patterns documented with `file:line` references? If missing examples → red flag.
   - **Confidence**: Grade the answer **strong** (backed by load-bearing `file:line` evidence), **weak** (thin, inferred, or single-source), or **contradictory**. Weak and contradictory both trigger probing.

5. **Apply Socratic probing to the answer** (depth-first — drill this thread, don't open new ones yet):
   - **Clarify**: "What exactly does this mean? Which case does it cover?"
   - **Test evidence**: "Is this `file:line` actually load-bearing, or incidental? Does it prove the claim or just mention it?"
   - **Question assumptions**: "The code assumes X about state/users/reports. Is that validated? What if it's wrong?"
   - **Expose contradictions**: "Finding A says X, but B suggests Y. Which holds? Do both apply in different contexts?"
   - **Trace implications**: "If this invariant holds, what does it force downstream? What breaks if it doesn't?"
   - **Consider alternatives**: "Is there another path/pattern the code could take here? Why this one?"

6. **Decision point — has this thread hit bedrock?**
   - A thread is **bottomed out** when its answer is graded **strong** and probing surfaces no new weak/contradictory point.
   - If probing surfaced a weak, contradictory, or unresolved point → the thread is still open.
   - If bottomed out → check termination criteria first; if met, stop. If unmet, the thread is closed and the next round opens a new one.
   - Either way, proceed to step 7 to generate the single next question.

### Round N: Iterative Refinement

7. **Generate the single next question** — one of two kinds, depending on step 6:
   - **Follow-up** (thread still open): the next "why" targeting the weakest/most critical point probing exposed. Frame it Socratically: "How exactly does X work in that case?" "Does pattern A handle the Y scenario?" "If assumption A is wrong, what changes?"
   - **New thread** (thread bottomed out): the most foundational remaining unknown, framed like step 2.
   - Add it to questions.md (append, don't replace).

8. **Call `/qrspi-research <artifact_path>/`** again
   - Research will see every question asked so far (all prior rounds + this one)
   - Research.md will be updated with new findings

9. **Loop back to step 4** until completeness or max rounds

### Termination Criteria

**Hard cap (always wins):** stop the instant round count reaches `max_rounds` — even mid-thread, even with open probes. This is a non-negotiable ceiling; never extend it. On hitting it, stop and report what's unresolved.

Otherwise, stop when **any** of these are true:
- **Completeness**: All evidence gathered and validated:
  - All system invariants documented with enforcement logic (`file:line`)
  - All relevant constraints identified
  - All implicit assumptions explicit and validated
  - All patterns documented with examples
  - All unknowns either resolved or marked "out of scope"
- **Redundancy**: Same findings appearing in successive rounds (no new insights about invariants, constraints, patterns, or assumptions)
- **Max rounds**: see hard cap above

### Round Output Format

10. **Final `questions.md`** (evolved through all rounds):
   ```markdown
   # Research Questions

   ## Context
   [2-3 sentences describing which areas of codebase to focus on.]

   ## Round 1 — [thread name] (new thread)
   [The one question] — *answer graded: strong/weak/contradictory*

   ## Round 2 — follow-up on [thread]
   [The one follow-up question] — *answer graded: ...*

   ## Round 3 — [thread name] (new thread)
   [The one question] — *answer graded: ...*

   (One question per round; drill a thread with follow-ups until it bottoms out, then open the next)
   ```

11. **Final `research.md`** (synthesized across all rounds):
   - All findings integrated
   - Patterns documented with `file:line`
   - Invariants listed
   - Assumptions explicit
   - Unknowns marked as resolved, out-of-scope, or open

12. **Present to user**: "Exploration complete. [X rounds, Y questions, Z findings]. Ready for design?"
    - If stopped by max_rounds with open items, say so explicitly and list what remains unresolved.

## Output

- Files written: `questions.md` and `research.md` in artifact directory (evolved through all rounds)
- Tell the user: "Next: run `/qrspi-design <artifact_path>/`"

## Configuration

- Mode is **sequential only**: one question per round, drilling a single thread depth-first before opening the next.
- `max_rounds`: Max iteration rounds (default: 10). Prevents infinite loops/hallucination.
- `issues_dir` and `shared_dir` from `.qrspi` file

## Rules

- **Iterative**: Generate one question, run research, grade + probe the answer, then generate the next single question (follow-up on the same thread, or a new thread if it bottomed out). Repeat.
- **Depth-first**: Drill one thread to bedrock (strong answer, no open probes) before opening the next.
- **Coordinate with qrspi-research**: Each round, call qrspi-research which will see all accumulated questions.
- **Refine, don't replace**: questions.md and research.md evolve through rounds, accumulating findings.
- **Grounded in facts**: Every finding needs `file:line`. No speculation.
- **Completeness focus**: Continue until no new insights or max rounds reached.
- **Don't jump to solutions**: Questions are factual, not prescriptive.
- **Hard cap**: `max_rounds` is an absolute ceiling. Count every round; stop the moment you reach it, mid-thread or not. Never loop past it.
