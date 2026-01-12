#!/bin/bash
# Simple server start script

set -e

echo "🚀 Starting DevOrchestrator Server..."
echo ""

# Load environment variables
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Use venv Python
VENV_PYTHON="./venv/bin/python3"
if [ ! -f "$VENV_PYTHON" ]; then
    echo "❌ Virtual environment not found!"
    echo "Run: python3 -m venv venv && ./venv/bin/python3 -m pip install -r requirements.txt"
    exit 1
fi

# Check port
if command -v lsof >/dev/null 2>&1; then
    if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "⚠️  Port 8000 is already in use"
        PID=$(lsof -ti:8000)
        echo "Process ID: $PID"
        read -p "Kill process and continue? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill -9 $PID 2>/dev/null || true
            sleep 1
        else
            exit 1
        fi
    fi
fi

echo "Starting server on http://localhost:8000"
echo "Press Ctrl+C to stop"
echo ""

# Start server
$VENV_PYTHON app.py

