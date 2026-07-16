---
name: doc-reduce
description: >
  Reduce a document to its concise form: every word carries meaning, like a
  math book where nothing can be removed without losing information. Cut tokens,
  keep all meaning. Use when the user says "reduce this document", "compress
  this doc", "condense this doc", "tighten this doc", "shrink this document",
  "make this concise", "distill this", "review and compress", or invokes
  /doc-reduce.
---

# Doc Reduce

## The principle
A concise document is like a math book: every word does work, every sentence
carries information that no other sentence carries, and removing any line would
lose something. Concision is not brevity for its own sake. It is **information
density** — the ratio of meaning to tokens. Raise the ratio; never lower the
meaning.

The test of a concise doc: re-read it and ask "could any word be removed
without losing information or changing what the reader understands?" If yes,
remove it. If removing it loses meaning, keep it. Meaning is fixed; tokens are
the variable.

## Rule zero
Preserve meaning. Never drop a fact, instruction, constraint, example, edge
case, decision, or reference. If removing a line could change what the reader
understands or does, keep it. When in doubt, keep it. When meaning and brevity
conflict, meaning wins.

## Redundancy detection (the main job)
The biggest token waste is saying the same thing many times in different ways.
Hunt this before anything else. Build a meaning inventory first, then compare
every sentence against it.

A statement is redundant when it adds no new information beyond one already
made. Same idea, different wording counts as redundant even if the phrasing
looks distinct. Watch for these forms:

- Exact restatement: "X is fast. X runs quickly."
- Paraphrase restatement: "The service retries on failure." + "On error, the
  service attempts the call again."
- Concept restatement: "Keep controllers thin." + "Controllers should hold
  little logic." + "Avoid fat controllers."
- Example restatement: two examples teaching the same lesson with no new
  nuance.
- Section restatement: an "Overview" that says what the body says; a "Summary"
  that repeats the body.
- Framing restatement: an intro paragraph, a bulleted version of the same, and
  a closing paragraph all restating one point.
- Signpost restatement: "In this section we cover X. X is... Next we cover Y.
  Y is..."

Rule for merging: when two statements overlap, keep the one with the most
information and the most concrete detail; fold any unique detail from the
others into it; drop the rest. If the overlap is partial (each carries some
unique info), merge into one sentence that carries the union. If the overlap
is total, keep the clearer one verbatim and drop the rest.

## What to compress
- Redundancy — every form listed above. This is where most savings come from.
- Filler words and pleasantries (please, simply, basically, actually, just, in
  order to -> to).
- Empty transitions ("Now let's talk about...", "Moving on to...").
- Commentary that paraphrases the code/spec without adding info.
- Hedge words that weaken without qualifying (might possibly, could
  potentially).
- Adjectives/nouns not carrying meaning (nice, simple, powerful, robust).
- Boilerplate (Note that, It is worth noting that, As mentioned earlier).
- Verbose lists -> compact tables; verbose prose -> bullets when order allows.

## What stays untouched
- Code blocks, commands, URLs, file paths, env var names, version numbers,
  config keys, error strings, identifiers.
- Constraints, invariants, contracts, rules.
- Decisions and their rationale.
- Edge cases, caveats, warnings, security notes.
- Quantities, thresholds, limits, timeouts, defaults.
- Step order in procedures. Do not reorder numbered steps; only trim words.
- Cross-references and links.
- Names of people, systems, modules, APIs.
- Anything under a heading like "Requirements", "Constraints", "Contract",
  "API", "Schema", "Security", "Invariant".

## Concision moves, strongest first
1. Delete redundancy (per the forms above). Biggest gain, lowest risk.
2. Merge adjacent paragraphs that say the same thing into one.
3. Convert verbose prose to bullets when order does not matter.
4. Convert bullet lists of parallel facts to compact tables when headers help.
5. Shorten sentences: "This is done in order to allow X" -> "This allows X".
6. Replace long phrases with standard short ones ("a number of" -> "several",
   "in the event that" -> "if", "at this point in time" -> "now").
7. Drop sections that only signpost ("Overview", "Summary") if their content
   is fully covered elsewhere and the heading carries no info.

If unsure a move is safe, skip it. The rewritten doc must pass the math-book
test: every remaining word is load-bearing.

## Process
1. Read the source document fully.
2. Build a meaning inventory: one entry per distinct fact, constraint,
   decision, example, step, and reference. This is your preservation contract.
3. Run a redundancy pass: for each inventory entry, collect every sentence in
   the doc that conveys it. If an entry has more than one sentence, mark the
   duplicates for merge. This is where the largest savings come from.
4. Run a filler pass: cut filler, boilerplate, hedges, and empty transitions.
5. Rewrite: apply the redundancy merges first, then the filler cuts, then the
   format moves (prose -> bullets, lists -> tables).
6. Apply the math-book test: re-read the output sentence by sentence. For each,
   ask "if I delete this, does the reader lose anything?" If no loss, delete.
7. Diff the output against the inventory:
   - any fact missing -> restore it
   - any constraint weaker -> restore it
   - any step reordered -> fix order
   - any example lost that taught something unique -> restore or inline its
     lesson
   - any inventory entry now stated zero times -> restore it exactly once
8. Only stop when every inventory entry survives, stated exactly once, and
   every remaining word is load-bearing.

## Output
Write the concise version to the same path as the source by default, unless
the user gives a target. If overwriting, preserve the file's frontmatter and
code fences exactly. Report at the end:
- input token count (approx)
- output token count (approx)
- redundancy found: list each group of statements that said the same thing,
  what you merged them into, and how many duplicates you removed
- other sections/lines removed and why
- anything you chose NOT to compress and why
- any place you were unsure and kept the original for safety

Never silently change meaning, drop a fact, or reorder procedural steps. The
goal is a document as dense as a math proof: nothing removable, nothing lost.