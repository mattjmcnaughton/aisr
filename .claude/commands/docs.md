# Generate/Refresh Documentation

Generate or refresh project documentation.

## Arguments
- $ARGUMENTS: Optional scope (e.g., `api`, `architecture`, `all`, or specific file path)

## Documentation Types

| Type | Location | Description |
|------|----------|-------------|
| API | `docs/api/` | Endpoint documentation |
| Architecture | `docs/architecture/` | System design |
| Development | `docs/development/` | Setup & guides |
| Database | `docs/database/` | Schema & ERD |
| Runbooks | `docs/runbooks/` | Operations |

## Process

### For "all" or no argument:
1. Scan entire codebase for changes
2. Compare existing docs to current code
3. Update all outdated sections
4. Remove docs for deleted features
5. Add docs for new features

### For specific type (e.g., `api`):
1. Focus on that documentation type
2. Scan relevant code sections
3. Update or generate documentation

### For specific file:
1. Read the existing documentation
2. Compare to current codebase
3. Refresh that specific file

## Standards

- **Format**: Markdown, concise, no fluff
- **Code examples**: Must be runnable
- **Diagrams**: Use Mermaid
- **Structure**: Clear hierarchy

## Checklist

### API Docs
- All endpoints documented
- Schemas accurate
- Examples current

### Architecture
- Diagrams reflect current state
- Components complete

### Development
- Setup instructions work
- Env vars documented
- Just commands listed

### Database
- Tables documented
- Relationships accurate

## Output
Updated documentation files with current date stamps.
