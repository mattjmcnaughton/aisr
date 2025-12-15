# AISR - AI Spaced Repetition

An AI-powered spaced repetition flashcard app with agentic flashcard creation.

## Stack

| Layer | Technologies |
|-------|-------------|
| Backend | FastAPI, SQLModel, Pydantic, PydanticAI, uv, ruff, ty, structlog, OpenTelemetry |
| Frontend | React, SWR, Zustand, ShadCN/Tailwind, Vite, prettier, TypeScript |
| Infrastructure | Docker, PostgreSQL (docker-compose) |
| Testing | Pytest, Jest, Playwright (page-based) |
| Task Runner | just |

## Core Principles

### Simple Over Clever
Write straightforward code. Avoid abstractions until proven necessary.

### No Unnecessary Comments
Code should be self-documenting through clear naming and structure.

### Absolute Imports Only (Python)
```python
from aisr.services.card import CardService
from aisr.models.card import Card
from aisr.core.config import settings
```

## Backend Architecture

### Service Layer Pattern
Business logic lives in **Services** that are completely isolated:
- No database calls
- No API calls
- No external system interactions
- Pure functions where possible
- All dependencies injected

```python
class CardService:
    def calculate_next_review(self, card: Card, quality: int) -> Card:
        new_interval = self._compute_interval(card.interval, card.ease, quality)
        return card.model_copy(update={"interval": new_interval})
```

### Repository Pattern
**Repositories** handle all persistence:
- Database queries
- Transactions
- Data mapping

### Layer Responsibilities
```
API Routes → Services → Repositories → Database
     ↓           ↓
  Schemas     Models
```

### Structured Logging
Use structlog with snake_case event names:
```python
log.info("card_review_completed", card_id=str(card.id), quality=quality)
log.error("database_connection_failed", host=host, retry_count=count)
```

Trace IDs propagate automatically via middleware.

### Metrics (OpenTelemetry)
Export metrics via OTEL:
```python
meter = metrics.get_meter("aisr")
cards_created = meter.create_counter("cards_created_total")
review_duration = meter.create_histogram("review_duration_seconds")
```

## Frontend Architecture

### Separation of Concerns
Separate UI from network calls from business logic:

```
src/
├── components/     # Pure UI - receives props, renders JSX
├── features/       # Feature components - compose UI + hooks
├── hooks/          # Custom hooks - UI logic
├── api/            # Network layer - SWR hooks, fetch calls
├── services/       # Business logic - pure functions
├── stores/         # Zustand - global state
└── types/
```

- **components/**: Pure presentational, no data fetching
- **api/**: All network calls isolated here
- **services/**: Pure business logic, no React, no network

## Testing: The Pyramid

### Unit Tests (Most)
- Test services in complete isolation
- Mock nothing internal, inject test data
- Fast, deterministic

### Integration Tests (Some)
- Test two internal components together, OR
- Test one internal + one external (API + DB)

### E2E Tests (Few)
- Critical user flows only
- Expensive, run sparingly

## REST API Conventions

- Proper HTTP methods: GET, POST, PUT, PATCH, DELETE
- Appropriate status codes: 201 Created, 204 No Content, 404 Not Found
- Cursor-based pagination: `{"data": [...], "next_cursor": "..."}`
- Version prefix: `/api/v1/`

## Database (PostgreSQL)

Leverage OLTP capabilities:
- **Transactions**: Multi-statement operations
- **Foreign Keys**: Referential integrity at DB level
- **Constraints**: CHECK, UNIQUE, NOT NULL
- **Indexes**: Based on query patterns

## Project Structure

```
backend/
├── src/
│   └── aisr/
│       ├── __init__.py
│       ├── main.py
│       ├── api/v1/routes/
│       ├── models/
│       ├── schemas/
│       ├── services/
│       ├── repositories/
│       ├── agents/
│       └── core/
├── tests/
│   ├── unit/
│   └── integration/
├── pyproject.toml
└── justfile

frontend/
├── src/
│   ├── components/ui/
│   ├── features/
│   ├── hooks/
│   ├── api/
│   ├── services/
│   ├── stores/
│   └── types/
├── tests/
├── package.json
└── justfile

e2e/
├── pages/
├── tests/
└── fixtures/

docs/
├── api/
├── architecture/
├── development/
├── database/
├── runbooks/
└── prds/
```

## Subagents

| Agent | Purpose |
|-------|---------|
| `backend-dev` | Python/FastAPI, API design, services |
| `frontend-dev` | React/TypeScript, components, hooks |
| `db-architect` | PostgreSQL schema, migrations |
| `e2e-tester` | Playwright tests, Page Objects |
| `ai-agent-dev` | PydanticAI, flashcard generation |
| `code-reviewer` | Quality, security, architecture review |
| `prd-author` | Draft PRDs with measurable value |
| `prd-executor` | Execute PRDs via subagent delegation |
| `docs-generator` | Generate/refresh documentation |
| `scaffolder` | Project structure, dependencies |
| `docker-engineer` | Dockerfiles, docker-compose |
| `task-orchestrator` | Parallel task execution via worktrees |

## Slash Commands

| Command | Description |
|---------|-------------|
| `/just <cmd>` | Run just command |
| `/prd <feature>` | Draft a PRD |
| `/execute-prd <path>` | Execute a PRD |
| `/docs [scope]` | Generate/refresh docs |
| `/scaffold [type]` | Scaffold project structure |
| `/review [files]` | Code review |
| `/new-feature <desc>` | Plan a new feature |
| `/generate-cards <content>` | AI-generate flashcards |
| `/parallel <tasks...>` | Execute tasks in parallel worktrees |

## Just Commands

Run `just` in any directory to see available commands.

### Top-Level
| Command | Description |
|---------|-------------|
| `just dev` | Start all services |
| `just test` | Run all tests |
| `just lint` | Run all linters |
| `just fix` | Auto-fix issues |
| `just docker-up` | Start containers |
| `just status` | Project health |

### Backend (`cd backend`)
| Command | Description |
|---------|-------------|
| `just dev` | Start FastAPI server |
| `just test` | Run pytest |
| `just test-unit` | Unit tests only |
| `just test-integration` | Integration tests only |
| `just lint` | ruff + ty |
| `just db-migrate` | Run migrations |
| `just db-migration "name"` | Create migration |

### Frontend (`cd frontend`)
| Command | Description |
|---------|-------------|
| `just dev` | Start Vite server |
| `just test` | Run Jest |
| `just lint` | ESLint + tsc |
| `just build` | Production build |

## Design Philosophy

Emulate Linear:
- Clean, minimal interface
- Keyboard-first interactions
- Smooth animations
- Dark mode support
