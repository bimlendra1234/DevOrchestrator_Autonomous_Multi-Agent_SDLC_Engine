#!/bin/bash
# Complete test and run script

set -e

echo "🔍 DevOrchestrator - Complete Test & Run"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Check Python
echo "📋 Step 1: Checking Python..."
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 not found!${NC}"
    exit 1
fi
PYTHON_VERSION=$(python3 --version)
echo -e "${GREEN}✅ ${PYTHON_VERSION}${NC}"
echo ""

# Step 2: Check/Create venv
echo "📦 Step 2: Setting up virtual environment..."
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo -e "${GREEN}✅ Virtual environment created${NC}"
else
    echo -e "${GREEN}✅ Virtual environment exists${NC}"
fi
echo ""

# Step 3: Activate and install
echo "📥 Step 3: Installing dependencies..."
VENV_PYTHON="venv/bin/python3"
if [ ! -f "$VENV_PYTHON" ]; then
    echo -e "${RED}❌ Virtual environment Python not found!${NC}"
    exit 1
fi

$VENV_PYTHON -m pip install --upgrade pip -q
echo "Installing packages (this may take a minute)..."
$VENV_PYTHON -m pip install -r requirements.txt -q
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Step 4: Check .env
echo "🔑 Step 4: Checking environment configuration..."
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  .env file not found, creating from template...${NC}"
    cp env.example .env
    echo -e "${YELLOW}⚠️  Please add your GROQ_API_KEY to .env file!${NC}"
else
    if grep -q "GROQ_API_KEY=your_groq_api_key_here" .env || grep -q "GROQ_API_KEY=$" .env; then
        echo -e "${YELLOW}⚠️  GROQ_API_KEY not set in .env${NC}"
    else
        echo -e "${GREEN}✅ .env file configured${NC}"
    fi
fi
echo ""

# Step 5: Create directories
echo "📁 Step 5: Creating required directories..."
mkdir -p generated_projects logs
echo -e "${GREEN}✅ Directories created${NC}"
echo ""

# Step 6: Test imports
echo "🧪 Step 6: Testing imports..."
if $VENV_PYTHON -c "from agent.graph import agent; print('✅ Import successful')" 2>&1; then
    echo -e "${GREEN}✅ All imports working${NC}"
else
    echo -e "${RED}❌ Import failed!${NC}"
    echo "Trying to fix..."
    $VENV_PYTHON -m pip install --force-reinstall -r requirements.txt -q
    if $VENV_PYTHON -c "from agent.graph import agent; print('✅ Import successful after reinstall')" 2>&1; then
        echo -e "${GREEN}✅ Fixed!${NC}"
    else
        echo -e "${RED}❌ Still failing. Check error above.${NC}"
        exit 1
    fi
fi
echo ""

# Step 7: Check port
echo "🔌 Step 7: Checking port 8000..."
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Port 8000 is already in use${NC}"
    read -p "Kill process on port 8000? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        lsof -ti:8000 | xargs kill -9 2>/dev/null || true
        echo -e "${GREEN}✅ Port cleared${NC}"
        sleep 1
    else
        echo -e "${YELLOW}⚠️  Using existing process${NC}"
    fi
else
    echo -e "${GREEN}✅ Port 8000 is available${NC}"
fi
echo ""

# Step 8: Start server
echo "🚀 Step 8: Starting DevOrchestrator server..."
echo ""
echo -e "${GREEN}=========================================="
echo "  Server starting on http://localhost:8000"
echo "==========================================${NC}"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start the server
$VENV_PYTHON app.py

