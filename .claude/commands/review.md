# Code Review

Review recent changes or specific files for quality, security, and best practices.

## Arguments
- $ARGUMENTS: Optional file paths or git ref (e.g., "HEAD~3..HEAD", "src/components/Card.tsx")

## Process
1. If no arguments, review uncommitted changes (`git diff`)
2. If git ref provided, review those commits
3. If file paths provided, review those specific files

## Commands to Execute
```bash
git diff $ARGUMENTS
```

## Review Checklist

### Architecture
- Services are isolated (no DB/API calls in business logic)
- Repositories handle persistence
- Absolute imports only (Python)

### Code Quality
- No unnecessary comments
- Simple over clever
- Type hints/TypeScript strict

### Database
- Foreign keys defined
- Transactions where needed
- Indexes on query patterns

### Testing
- Unit tests for services (isolated)
- Integration tests for API + DB
- Following the test pyramid

### API
- RESTful conventions
- Proper status codes
- Pagination implemented

## Output Format
1. **Summary**: Overall assessment
2. **Must Fix**: Critical issues
3. **Should Fix**: Important improvements
4. **Consider**: Optional suggestions
