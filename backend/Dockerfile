FROM python:3.13-slim AS builder

RUN groupadd --gid 1000 appgroup && \
    useradd --uid 1000 --gid 1000 --create-home appuser

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY --chown=appuser:appgroup pyproject.toml uv.lock ./
RUN chown appuser:appgroup /app

USER appuser

RUN uv sync --frozen --no-dev --no-install-project

COPY --chown=appuser:appgroup src ./src
COPY --chown=appuser:appgroup README.md ./
RUN uv sync --frozen --no-dev

FROM python:3.13-slim

RUN groupadd --gid 1000 appgroup && \
    useradd --uid 1000 --gid 1000 --create-home appuser

WORKDIR /app

COPY --from=builder --chown=appuser:appgroup /app/.venv /app/.venv

ENV PATH="/app/.venv/bin:$PATH"

USER appuser

EXPOSE 8000

CMD ["uvicorn", "aisr.main:app", "--host", "0.0.0.0", "--port", "8000"]
