#!/bin/bash
# Complete setup, test, and run script

set -e

echo "🚀 DevOrchestrator - Complete Setup & Test"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Step 1: Check Python
echo -e "${BLUE}📋 Step 1: Checking Python...${NC}"
if ! command_exists python3; then
    echo -e "${RED}❌ Python 3 not found! Please install Python 3.11+${NC}"
    exit 1
fi
PYTHON_VERSION=$(python3 --version)
echo -e "${GREEN}✅ ${PYTHON_VERSION}${NC}"
echo ""

# Step 2: Setup venv
echo -e "${BLUE}📦 Step 2: Setting up virtual environment...${NC}"
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo -e "${GREEN}✅ Virtual environment created${NC}"
else
    echo -e "${GREEN}✅ Virtual environment exists${NC}"
fi

# Use venv Python directly
VENV_PYTHON="./venv/bin/python3"
if [ ! -f "$VENV_PYTHON" ]; then
    echo -e "${RED}❌ Virtual environment Python not found!${NC}"
    exit 1
fi
echo ""

# Step 3: Install dependencies
echo -e "${BLUE}📥 Step 3: Installing dependencies...${NC}"
echo "Upgrading pip..."
$VENV_PYTHON -m pip install --upgrade pip -q
echo "Installing packages (this may take a minute)..."
$VENV_PYTHON -m pip install -r requirements.txt 2>&1 | grep -E "(Successfully|Requirement|ERROR)" || true
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Step 4: Check .env
echo -e "${BLUE}🔑 Step 4: Checking environment configuration...${NC}"
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  .env file not found, creating from template...${NC}"
    cp env.example .env
    echo -e "${RED}❌ Please add your GROQ_API_KEY to .env file!${NC}"
    exit 1
fi

# Check if API key is set
if grep -q "GROQ_API_KEY=your_groq_api_key_here" .env || ! grep -q "GROQ_API_KEY=gsk_" .env; then
    echo -e "${YELLOW}⚠️  Checking API key...${NC}"
    if grep -q "GROQ_API_KEY=gsk_" .env; then
        echo -e "${GREEN}✅ API key found in .env${NC}"
    else
        echo -e "${RED}❌ GROQ_API_KEY not properly set in .env${NC}"
        echo "Please edit .env and add your API key from: https://console.groq.com/keys"
        exit 1
    fi
else
    echo -e "${GREEN}✅ .env file configured${NC}"
fi
echo ""

# Step 5: Create directories
echo -e "${BLUE}📁 Step 5: Creating required directories...${NC}"
mkdir -p generated_projects logs
echo -e "${GREEN}✅ Directories created${NC}"
echo ""

# Step 6: Test imports
echo -e "${BLUE}🧪 Step 6: Testing imports...${NC}"
if $VENV_PYTHON -c "
import os
from dotenv import load_dotenv
load_dotenv()
from agent.graph import agent
print('✅ All imports successful')
" 2>&1; then
    echo -e "${GREEN}✅ All imports working${NC}"
else
    echo -e "${RED}❌ Import test failed!${NC}"
    echo "Checking what's wrong..."
    $VENV_PYTHON -c "
import sys
try:
    from agent.graph import agent
except Exception as e:
    print(f'Error: {e}')
    sys.exit(1)
" 2>&1
    exit 1
fi
echo ""

# Step 7: Check port
echo -e "${BLUE}🔌 Step 7: Checking port 8000...${NC}"
if command_exists lsof; then
    if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Port 8000 is already in use${NC}"
        PID=$(lsof -ti:8000)
        echo "Process using port 8000: PID $PID"
        read -p "Kill process and continue? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill -9 $PID 2>/dev/null || true
            sleep 1
            echo -e "${GREEN}✅ Port cleared${NC}"
        else
            echo -e "${YELLOW}⚠️  Please stop the process manually and try again${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✅ Port 8000 is available${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Cannot check port (lsof not available)${NC}"
fi
echo ""

# Step 8: Start server
echo -e "${GREEN}=========================================="
echo "  🚀 Starting DevOrchestrator Server"
echo "==========================================${NC}"
echo ""
echo -e "${BLUE}Server will start on: ${GREEN}http://localhost:8000${NC}"
echo -e "${BLUE}Health check: ${GREEN}http://localhost:8000/api/health${NC}"
echo -e "${BLUE}Frontend: ${GREEN}http://localhost:8000${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
echo ""

# Load environment and start
export $(cat .env | grep -v '^#' | xargs)
$VENV_PYTHON app.py

