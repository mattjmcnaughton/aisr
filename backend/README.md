# AISR Backend

FastAPI backend for AI Spaced Repetition.

## Development

```bash
# Install dependencies
just install

# Start development server
just dev

# Run tests
just test

# Run linters
just lint
```

## Project Structure

```
src/
└── aisr/
    ├── api/v1/routes/    # API endpoints
    ├── core/             # Config, database, logging
    ├── models/           # SQLModel database models
    ├── schemas/          # Pydantic schemas
    ├── services/         # Business logic
    ├── repositories/     # Data access layer
    └── agents/           # PydanticAI agents
```
