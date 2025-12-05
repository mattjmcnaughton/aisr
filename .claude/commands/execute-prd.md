# Execute PRD

Implement a feature from an existing PRD.

## Arguments
- $ARGUMENTS: Path to PRD file (e.g., `docs/prds/agentic-card-creation.md`)

## Process

### Phase 1: Analysis
1. Read the full PRD
2. Extract all acceptance criteria
3. Identify technical requirements
4. Create task breakdown
5. Flag any ambiguities

### Phase 2: Plan
Create implementation plan following this order:
```
Database → Models → Repositories → Services → API → Frontend API → Frontend Services → Frontend Components → Tests
```

### Phase 3: Execute
For each task:
1. Mark task in progress
2. Implement following project conventions
3. Write tests
4. Run `just lint`
5. Mark task complete

### Phase 4: Verify
1. Run full test suite: `just test`
2. Manually verify each acceptance criterion
3. Update PRD status to "Complete"

## Conventions

### Backend
- Absolute imports
- Isolated services
- Structured logging (snake_case)
- OTEL metrics

### Frontend
- Separate UI / API / services
- Keyboard shortcuts
- TypeScript strict

### Testing
- Follow test pyramid
- Unit tests for services
- Integration for API + DB
- E2E for critical flows

## Output
- Working feature meeting all acceptance criteria
- Tests passing
- Documentation updated if needed
- PRD marked complete
