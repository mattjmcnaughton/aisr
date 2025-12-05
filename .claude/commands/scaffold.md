# Scaffold Project

Initialize or extend project structure, dependencies, and configuration.

## Arguments
- $ARGUMENTS: What to scaffold (e.g., `backend`, `frontend`, `all`, `docker`, `component <name>`)

## Scaffold Options

### `all` or no argument
Initialize complete project structure:
- Backend with uv, FastAPI, SQLModel
- Frontend with npm, React, Vite, ShadCN
- Docker setup with docker-compose
- E2E test structure
- Documentation directories

### `backend`
Initialize backend only:
- Create `src/aisr/` directory structure
- Initialize uv with pyproject.toml
- Add dependencies
- Create justfile
- Create Dockerfile

### `frontend`
Initialize frontend only:
- Create `src/` directory structure
- Initialize npm with package.json
- Add dependencies
- Create justfile
- Create Dockerfile

### `docker`
Create/update Docker configuration:
- Dockerfile for backend
- Dockerfile for frontend
- docker-compose.yml
- docker-compose.override.yml (dev)

### `component <name>`
Add a new feature component (both backend and frontend):
- Backend: model, schema, service, repository, routes
- Frontend: api hook, service, component, feature page

## Backend Structure (src/aisr/)
```
backend/
├── src/
│   └── aisr/
│       ├── __init__.py
│       ├── main.py
│       ├── api/v1/routes/
│       ├── core/
│       ├── models/
│       ├── schemas/
│       ├── services/
│       ├── repositories/
│       └── agents/
├── tests/
├── pyproject.toml
└── justfile
```

## Frontend Structure
```
frontend/
├── src/
│   ├── components/ui/
│   ├── features/
│   ├── hooks/
│   ├── api/
│   ├── services/
│   ├── stores/
│   └── types/
├── package.json
└── justfile
```

## Process
1. Delegate to scaffolder agent for structure
2. Delegate to docker-engineer agent for containers
3. Verify with `just lint` (if applicable)
