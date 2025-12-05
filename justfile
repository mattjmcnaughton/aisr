# AISR - AI Spaced Repetition
# Run `just` to see all available commands

set dotenv-load

# List available commands
default:
    @just --list

# ─────────────────────────────────────────────────────────────────────────────
# Development
# ─────────────────────────────────────────────────────────────────────────────

# Start all services (postgres, backend, frontend)
dev: docker-up
    @echo "Starting development servers..."
    just backend-dev &
    just frontend-dev

# Start backend development server
backend-dev:
    cd backend && just dev

# Start frontend development server
frontend-dev:
    cd frontend && just dev

# ─────────────────────────────────────────────────────────────────────────────
# Testing
# ─────────────────────────────────────────────────────────────────────────────

# Run all tests
test: test-backend test-frontend

# Run backend tests
test-backend *ARGS:
    cd backend && just test {{ARGS}}

# Run frontend tests
frontend-test *ARGS:
    cd frontend && just test {{ARGS}}

# Run e2e tests (requires dev servers running)
test-e2e *ARGS:
    cd e2e && npx playwright test {{ARGS}}

# ─────────────────────────────────────────────────────────────────────────────
# Code Quality
# ─────────────────────────────────────────────────────────────────────────────

# Run all linters and type checkers
lint: lint-backend lint-frontend

# Lint backend code
lint-backend:
    cd backend && just lint

# Lint frontend code
lint-frontend:
    cd frontend && just lint

# Fix auto-fixable issues
fix: fix-backend fix-frontend

# Fix backend issues
fix-backend:
    cd backend && just fix

# Fix frontend issues
fix-frontend:
    cd frontend && just fix

# ─────────────────────────────────────────────────────────────────────────────
# Database
# ─────────────────────────────────────────────────────────────────────────────

# Run database migrations
db-migrate *ARGS:
    cd backend && just db-migrate {{ARGS}}

# Create a new migration
db-migration NAME:
    cd backend && just db-migration {{NAME}}

# Reset database (drop and recreate)
db-reset:
    cd backend && just db-reset

# ─────────────────────────────────────────────────────────────────────────────
# Docker
# ─────────────────────────────────────────────────────────────────────────────

# Start docker services
docker-up *ARGS:
    docker-compose up -d {{ARGS}}

# Stop docker services
docker-down *ARGS:
    docker-compose down {{ARGS}}

# View docker logs
docker-logs *ARGS:
    docker-compose logs -f {{ARGS}}

# ─────────────────────────────────────────────────────────────────────────────
# Build
# ─────────────────────────────────────────────────────────────────────────────

# Build all containers
build:
    docker-compose build

# Build backend container
build-backend:
    cd backend && just build

# Build frontend for production
build-frontend:
    cd frontend && just build

# ─────────────────────────────────────────────────────────────────────────────
# Utilities
# ─────────────────────────────────────────────────────────────────────────────

# Show project status
status:
    @echo "=== Git Status ==="
    @git status --short
    @echo ""
    @echo "=== Docker Status ==="
    @docker-compose ps
    @echo ""
    @echo "=== Recent Commits ==="
    @git log --oneline -5

# Clean build artifacts
clean:
    cd backend && just clean
    cd frontend && just clean
    docker-compose down -v --remove-orphans

# Install all dependencies
install:
    cd backend && just install
    cd frontend && just install
