# Contributing to AISR

Thank you for your interest in contributing to AISR! This document provides guidelines and technical details for contributors.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style](#code-style)
- [Architecture](#architecture)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and Docker Compose
- [just](https://github.com/casey/just) - Command runner
- [uv](https://github.com/astral-sh/uv) - Python package manager
- [Node.js](https://nodejs.org/) 20+
- Python 3.12+

### Setup

```bash
# Clone the repository
git clone https://github.com/mattjmcnaughton/aisr.git
cd aisr

# Install all dependencies
just install

# Start development environment
just dev
```

## Development Workflow

### Running Services

```bash
just dev              # Start all services
just docker-up        # Start PostgreSQL and OpenTelemetry collector
just backend-dev      # Start FastAPI server with hot reload
just frontend-dev     # Start Vite dev server
```

### Code Quality

```bash
just lint             # Run all linters
just fix              # Auto-fix issues
```

### Database Operations

```bash
just db-migrate                    # Run pending migrations
just db-migration "description"    # Create new migration
just db-reset                      # Reset database
```

## Code Style

### Core Principles

**Simple Over Clever** - Write straightforward code. Avoid abstractions until proven necessary.

**Self-Documenting Code** - Use clear naming and structure. Avoid unnecessary comments.

**Minimal Changes** - Only make changes that are directly requested or clearly necessary. Don't add features, refactor code, or make improvements beyond what was asked.

### Python (Backend)

- Use absolute imports only
- Follow ruff formatting rules
- Type hints required for all functions

```python
# Correct - absolute imports
from aisr.services.card import CardService
from aisr.models.card import Card

# Incorrect - relative imports
from .services.card import CardService
```

### TypeScript (Frontend)

- Use TypeScript strict mode
- Follow prettier formatting
- Prefer functional components with hooks

## Architecture

### Backend Architecture

The backend follows a layered architecture with clear separation of concerns:

```
API Routes (async) -> Services (sync/async) -> Repositories (async) -> Database
     |                      |
   DTOs                  Models
```

#### Async-First

All I/O operations use async/await:

- FastAPI route handlers: `async def`
- Database operations: `AsyncSession`, `await session.execute()`
- PydanticAI agents: `await agent.run()`

#### Services

Business logic lives in Services that are completely isolated:

- No database calls
- No API calls
- No external system interactions
- Pure functions where possible (sync if no I/O)
- Async only when doing I/O
- All dependencies injected

```python
# Service with pure logic - can be sync
class CardService:
    def calculate_next_review(self, card: Card, quality: int) -> Card:
        new_interval = self._compute_interval(card.interval, card.ease, quality)
        return card.model_copy(update={"interval": new_interval})

# Service with I/O - must be async
class CardGenerationService:
    async def generate_from_content(self, content: str, agent: Agent) -> list[Card]:
        result = await agent.run(content)
        return self._parse_cards(result.output)
```

#### Repositories

Repositories handle all persistence (always async):

- Database queries with `await`
- Transactions
- Data mapping

```python
class CardRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_by_id(self, card_id: int) -> Card | None:
        return await self.session.get(Card, card_id)

    async def create(self, card: Card) -> Card:
        self.session.add(card)
        await self.session.commit()
        await self.session.refresh(card)
        return card
```

#### DTOs

Data Transfer Objects define the shape of data transferred between layers:

- **Request DTOs**: Validate incoming API request bodies
- **Response DTOs**: Structure outgoing API responses

#### Logging

Use structlog with snake_case event names:

```python
log.info("card_review_completed", card_id=str(card.id), quality=quality)
log.error("database_connection_failed", host=host, retry_count=count)
```

### Frontend Architecture

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

### REST API Conventions

- Proper HTTP methods: GET, POST, PUT, PATCH, DELETE
- Appropriate status codes: 201 Created, 204 No Content, 404 Not Found
- Cursor-based pagination: `{"data": [...], "next_cursor": "..."}`
- Version prefix: `/api/v1/`

### Database

PostgreSQL with full OLTP capabilities:

- **Transactions**: Multi-statement operations
- **Foreign Keys**: Referential integrity at DB level
- **Constraints**: CHECK, UNIQUE, NOT NULL
- **Indexes**: Based on query patterns

## Testing

### Testing Philosophy

Follow the testing pyramid:

**Unit Tests (Most)** - Test services in complete isolation. Mock nothing internal, inject test data. Fast and deterministic.

**Integration Tests (Some)** - Test two internal components together, OR test one internal + one external (API + DB).

**E2E Tests (Few)** - Critical user flows only. Expensive, run sparingly.

### Running Tests

```bash
# All tests
just test

# Backend only
just test-backend
just test-backend tests/unit              # Unit tests only
just test-backend tests/integration       # Integration tests only
just test-backend --cov                   # With coverage

# Frontend only
just test-frontend
just test-frontend --watch                # Watch mode
just test-frontend --coverage             # With coverage

# E2E (requires dev servers running)
just test-e2e
```

## Submitting Changes

1. **Fork** the repository
2. **Create a branch** for your feature or fix
3. **Make your changes** following the guidelines above
4. **Run tests** and linting: `just test && just lint`
5. **Submit a pull request** with a clear description of the changes

### Commit Messages

Write clear, concise commit messages:

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Keep the first line under 72 characters

### Pull Request Guidelines

- Keep PRs focused on a single change
- Include tests for new functionality
- Update documentation if needed
- Ensure all CI checks pass
