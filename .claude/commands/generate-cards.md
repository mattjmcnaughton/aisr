# Generate Flashcards with AI

Use the AI agent to generate flashcards from provided content.

## Arguments
- $ARGUMENTS: The content to generate flashcards from (text, topic, or file path)

## Process
1. Analyze the input content
2. Apply flashcard best practices:
   - One concept per card
   - Clear, unambiguous questions
   - Concise but complete answers
   - Appropriate difficulty levels
3. Generate structured flashcard output

## Output Format
For each generated card, provide:
```
---
Front: [Question or prompt]
Back: [Answer or explanation]
Tags: [relevant, tags]
Difficulty: [1-5]
Rationale: [Why this card structure was chosen]
---
```

Apply the ai-agent-dev principles:
- Atomic concepts
- Active recall focus
- Context-rich questions
- Suggest mnemonics where helpful

Ask clarifying questions if the content is ambiguous or if more context would help generate better cards.
