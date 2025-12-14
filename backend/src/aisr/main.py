from contextlib import asynccontextmanager
from collections.abc import AsyncIterator

from fastapi import FastAPI

from aisr.core.config import settings
from aisr.core.logging import setup_logging, get_logger
from aisr.api.v1.routes import health

log = get_logger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    setup_logging(debug=settings.debug)
    log.info("application_starting", app_name=settings.app_name)
    yield
    log.info("application_shutting_down")


app = FastAPI(
    title=settings.app_name,
    version="0.1.0",
    lifespan=lifespan,
)

app.include_router(health.router, prefix="/api/v1", tags=["health"])
