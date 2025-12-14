from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    app_name: str = "AISR"
    debug: bool = False

    database_url: str = "postgresql+asyncpg://aisr:aisr@localhost:5432/aisr"

    openai_api_key: str = ""

    otel_exporter_otlp_endpoint: str = ""
    otel_service_name: str = "aisr-backend"


settings = Settings()
