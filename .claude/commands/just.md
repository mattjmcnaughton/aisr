# Run Just Command

Execute a just command from the project's justfile.

## Arguments
- $ARGUMENTS: The just command and any arguments (e.g., "test-backend -v", "db-migrate", "lint")

## Available Commands
Run `just` in the project root to see all available commands. Key commands:

**Development**
- `just dev` - Start all services
- `just backend-dev` - Start backend only
- `just frontend-dev` - Start frontend only

**Testing**
- `just test` - Run all tests
- `just test-backend` - Backend tests
- `just test-frontend` - Frontend tests
- `just test-e2e` - E2E tests

**Code Quality**
- `just lint` - Run all linters
- `just fix` - Auto-fix issues

**Database**
- `just db-migrate` - Run migrations
- `just db-migration "name"` - Create migration
- `just db-reset` - Reset database

**Docker**
- `just docker-up` - Start containers
- `just docker-down` - Stop containers

## Command to Execute
```bash
just $ARGUMENTS
```
