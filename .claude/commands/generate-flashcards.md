# Command: Flashcard Workflow for Coding Agents (Claude Code / Codex)

## Goal
Generate **high-signal technical flashcards** from either:
1) **provided source material** (preferred), or
2) a **generic topic** (in which case you may use the web to research authoritative sources).

## Web Research Policy
- If detailed source material is provided, **do not** do web research; rely on the content.
- If only a generic topic is provided, you **may** use the web to gather accurate, authoritative information.
- Prefer primary sources (official docs, papers, reputable technical references).

## Inputs
- `SOURCE`: The source content to extract from (may be empty if topic-only).
- `TOPIC`: A topic description (may be empty if SOURCE is provided).
- `N`: Number of flashcards (default 3).
- `SKIP_CONFIRMATION`: If true, skip idea confirmation and generate flashcards immediately.
- `OUT_DIR`: Output directory for generated markdown files (if filesystem available).

## Output Requirements
- If filesystem access is available:
  - Create directory `OUT_DIR` if it doesn't exist.
  - Write **one markdown file per flashcard** into `OUT_DIR`.
  - Use kebab-case filenames derived from the question.
- If filesystem access is not available:
  - Print the flashcards as raw markdown blocks (triple-backtick fenced), one per card.
- In all cases, each flashcard uses:
  - Front (question)
  - Separator line: `---`
  - Back (answer)

## Algorithm (Do Not Deviate)
1. **Ingest inputs**:
   - If `SOURCE` is non-empty, use it as the sole grounding material.
   - Else, treat `TOPIC` as the prompt and perform minimal web research to gather reliable content.

2. **Extract core ideas**:
   - Identify the **N most important, non-overlapping** ideas.
   - Each idea must be expressible as a single-sentence takeaway.

3. **Default confirmation step**:
   - If `SKIP_CONFIRMATION` is not set/true:
     - Output the numbered list of core ideas for user review:
       - “Confirm, edit, reorder, remove/add ideas, or say ‘proceed’.”
     - STOP until the user confirms.
   - If `SKIP_CONFIRMATION` is true, proceed immediately.

4. **Generate flashcards (one per idea)**:
   For each idea:
   - Internally identify the **single core insight**.
   - Create a question that targets that insight (well-scoped; expert-level).
   - Write the back using this structure:
     - First line: either **bolded `TL;DR:`** (preferred when appropriate) or a direct declarative answer
     - 2–4 short paragraphs of progressive elaboration:
       - mechanism/reasoning
       - distinctions/tradeoffs
       - concrete examples
   - Keep the back under ~150 words.
   - Avoid encyclopedic detail, tutorials, and unnecessary history.
   - Exactly one main idea per card.

## Flashcard Format (Exact)
```
<QUESTION>
---
<ANSWER>
```

## Few-Shot Examples (Reference Only)
```
What is OLTP?
---
**TL;DR:** OLTP systems handle fast, small, real-time transactions with strong consistency.

OLTP systems serve many concurrent users reading/writing small records with low latency.
They emphasize ACID guarantees, strong consistency, and row-oriented access patterns.
Examples include PostgreSQL, MySQL, and DynamoDB.
```

```
What is the key insight behind transformer self-attention?
---
Self-attention lets each token weight other tokens dynamically, enabling global context without recurrence.

Transformers compute attention weights in parallel rather than processing tokens sequentially.
This improves scalability and captures long-range dependencies more effectively.
It simplifies architectures while enabling strong performance on many sequence tasks.
```
