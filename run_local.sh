#!/bin/bash
# Complete setup and run script for local testing

set -e

echo "🚀 DevOrchestrator - Complete Local Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Check Python
echo "📋 Step 1: Checking Python..."
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is not installed!${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo -e "${GREEN}✅ Python ${PYTHON_VERSION} found${NC}"
echo ""

# Step 2: Create virtual environment
echo "📦 Step 2: Setting up virtual environment..."
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo -e "${GREEN}✅ Virtual environment created${NC}"
else
    echo -e "${GREEN}✅ Virtual environment already exists${NC}"
fi
echo ""

# Step 3: Activate and install dependencies
echo "📥 Step 3: Installing dependencies..."
source venv/bin/activate
pip install --upgrade pip --quiet
pip install -r requirements.txt --quiet
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Step 4: Create .env if it doesn't exist
echo "📝 Step 4: Checking environment configuration..."
if [ ! -f ".env" ]; then
    echo "Creating .env file from template..."
    cp env.example .env
    echo -e "${YELLOW}⚠️  .env file created. Please add your GROQ_API_KEY!${NC}"
    echo ""
    echo "Edit .env and replace:"
    echo "  GROQ_API_KEY=your_groq_api_key_here"
    echo ""
    echo "With your actual key from: https://console.groq.com/keys"
    echo ""
    read -p "Press Enter to continue (you can add the key later)..."
else
    # Check if API key is set
    if grep -q "GROQ_API_KEY=your_groq_api_key_here" .env || grep -q "GROQ_API_KEY=$" .env; then
        echo -e "${YELLOW}⚠️  GROQ_API_KEY not set in .env file${NC}"
        echo "Please edit .env and add your API key from: https://console.groq.com/keys"
        echo ""
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

# Step 6: Check frontend
echo "🎨 Step 6: Checking frontend files..."
if [ -f "frontend/index.html" ]; then
    echo -e "${GREEN}✅ Frontend files found${NC}"
else
    echo -e "${RED}❌ Frontend files not found!${NC}"
    exit 1
fi
echo ""

# Step 7: Start the server
echo "🚀 Step 7: Starting DevOrchestrator server..."
echo ""
echo -e "${GREEN}=========================================="
echo "  Server starting on http://localhost:8000"
echo "==========================================${NC}"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start the server
python app.py

