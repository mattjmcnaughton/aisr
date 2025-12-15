# AISR - AI Spaced Repetition

An AI-powered spaced repetition flashcard application with agentic flashcard creation.

## Features

- **AI-Powered Card Generation** - Automatically generate flashcards from content using PydanticAI agents
- **Spaced Repetition** - Optimized review scheduling based on proven learning algorithms
- **Modern Web Interface** - Clean, keyboard-first UI inspired by Linear
- **Full Observability** - Structured logging and OpenTelemetry metrics built-in

## Tech Stack

| Layer | Technologies |
|-------|-------------|
| Backend | FastAPI, SQLModel, Pydantic, PydanticAI |
| Frontend | React 19, TypeScript, Vite, Tailwind CSS |
| Database | PostgreSQL 17 |
| Testing | Pytest, Vitest, Playwright |
| Infrastructure | Docker, docker-compose |

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and Docker Compose
- [just](https://github.com/casey/just) - Command runner
- [uv](https://github.com/astral-sh/uv) - Python package manager (for backend development)
- [Node.js](https://nodejs.org/) 20+ (for frontend development)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/mattjmcnaughton/aisr.git
cd aisr

# Install dependencies
just install

# Start all services (PostgreSQL, backend, frontend)
just dev
```

The application will be available at:
- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines, coding standards, and architecture details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
