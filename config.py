"""
Configuration module for DevOrchestrator application.
Loads configuration from environment variables and .env file.
"""

import os
from typing import Optional
from pathlib import Path

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables"""
    
    # Application
    app_name: str = "DevOrchestrator"
    app_version: str = "1.0.0"
    environment: str = os.getenv("ENVIRONMENT", "development")
    debug: bool = os.getenv("DEBUG", "true").lower() == "true"
    
    # Server
    host: str = os.getenv("HOST", "0.0.0.0")
    port: int = int(os.getenv("PORT", 8000))
    workers: int = int(os.getenv("WORKERS", 4))
    
    # Groq API
    groq_api_key: str = os.getenv("GROQ_API_KEY", "")
    groq_model: str = os.getenv("GROQ_MODEL", "openai/gpt-oss-120b")
    
    # LangChain
    langchain_tracing_v2: bool = os.getenv("LANGCHAIN_TRACING_V2", "false").lower() == "true"
    langchain_api_key: Optional[str] = os.getenv("LANGCHAIN_API_KEY")
    
    # Logging
    log_level: str = os.getenv("LOG_LEVEL", "INFO")
    log_file: str = os.getenv("LOG_FILE", "logs/app.log")
    
    # File handling
    generated_project_directory: str = os.getenv(
        "GENERATED_PROJECT_DIRECTORY",
        "./generated_projects"
    )
    max_upload_size_mb: int = int(os.getenv("MAX_UPLOAD_SIZE_MB", 100))
    
    # Timeouts (in seconds)
    request_timeout: int = int(os.getenv("REQUEST_TIMEOUT_SECONDS", 300))
    llm_timeout: int = int(os.getenv("LLM_TIMEOUT_SECONDS", 120))
    
    # Rate limiting
    rate_limit_requests: int = int(os.getenv("RATE_LIMIT_REQUESTS", 100))
    rate_limit_period: int = int(os.getenv("RATE_LIMIT_PERIOD", 60))
    
    # CORS
    cors_origins: str = os.getenv("CORS_ORIGINS", "*")
    
    # Security
    secret_key: str = os.getenv("SECRET_KEY", "dev-secret-key-change-in-production")
    
    class Config:
        env_file = ".env"
        case_sensitive = False
    
    def __init__(self, **data):
        super().__init__(**data)
        # Validate required environment variables
        if not self.groq_api_key:
            raise ValueError("GROQ_API_KEY environment variable is required")
    
    @property
    def is_production(self) -> bool:
        """Check if running in production"""
        return self.environment.lower() == "production"
    
    @property
    def cors_origins_list(self) -> list:
        """Parse CORS origins from string"""
        if self.cors_origins == "*":
            return ["*"]
        return [origin.strip() for origin in self.cors_origins.split(",")]
    
    @property
    def generated_projects_path(self) -> Path:
        """Get generated projects path as Path object"""
        path = Path(self.generated_project_directory)
        path.mkdir(parents=True, exist_ok=True)
        return path


# Create settings instance
settings = Settings()
