#!/bin/bash
# Script to create .env file with API key

API_KEY="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"

cat > .env << EOF
# Groq API Configuration (REQUIRED)
GROQ_API_KEY=${API_KEY}

# LangChain Configuration (Optional)
LANGCHAIN_TRACING_V2=false
LANGCHAIN_API_KEY=your_langchain_key_here

# Application Configuration
ENVIRONMENT=development
DEBUG=true
HOST=0.0.0.0
PORT=8000
WORKERS=4

# Groq Model Configuration
GROQ_MODEL=openai/gpt-oss-120b

# Logging
LOG_LEVEL=INFO
LOG_FILE=logs/app.log

# File Handling
GENERATED_PROJECT_DIRECTORY=./generated_projects
MAX_UPLOAD_SIZE_MB=100

# Timeouts (in seconds)
REQUEST_TIMEOUT_SECONDS=300
LLM_TIMEOUT_SECONDS=120

# Rate Limiting
RATE_LIMIT_REQUESTS=100
RATE_LIMIT_PERIOD=60

# CORS (comma-separated list, or * for all)
CORS_ORIGINS=*

# Security (CHANGE IN PRODUCTION!)
SECRET_KEY=dev-secret-key-change-in-production
EOF

echo "✅ .env file created with your API key!"
echo ""
echo "Your API key has been added:"
grep "GROQ_API_KEY" .env | head -1

