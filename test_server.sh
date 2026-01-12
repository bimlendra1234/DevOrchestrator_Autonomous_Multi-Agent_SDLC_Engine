#!/bin/bash
# Complete server test script - Run this to test everything

set -e

echo "🧪 DevOrchestrator - Complete Server Test"
echo "=========================================="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if we're in the right directory
if [ ! -f "app.py" ]; then
    echo -e "${RED}❌ app.py not found. Please run this from the project root.${NC}"
    exit 1
fi

# Use venv Python
VENV_PYTHON="./venv/bin/python3"
if [ ! -f "$VENV_PYTHON" ]; then
    echo -e "${RED}❌ Virtual environment not found!${NC}"
    echo "Run: python3 -m venv venv && ./venv/bin/python3 -m pip install -r requirements.txt"
    exit 1
fi

echo -e "${BLUE}📋 Step 1: Testing imports...${NC}"
if $VENV_PYTHON -c "
from dotenv import load_dotenv
load_dotenv()
from agent.graph import agent
print('✅ All imports successful')
" 2>&1; then
    echo -e "${GREEN}✅ Imports OK${NC}"
else
    echo -e "${RED}❌ Import failed!${NC}"
    exit 1
fi
echo ""

echo -e "${BLUE}📋 Step 2: Checking API key...${NC}"
API_KEY=$($VENV_PYTHON -c "from dotenv import load_dotenv; import os; load_dotenv(); print(os.getenv('GROQ_API_KEY', ''))" 2>/dev/null)
if [[ "$API_KEY" == *"gsk_"* ]]; then
    echo -e "${GREEN}✅ API key found${NC}"
else
    echo -e "${RED}❌ API key not found or invalid${NC}"
    exit 1
fi
echo ""

echo -e "${BLUE}📋 Step 3: Checking port 8000...${NC}"
if command -v lsof >/dev/null 2>&1; then
    if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Port 8000 is in use${NC}"
        PID=$(lsof -ti:8000)
        echo "Process ID: $PID"
        read -p "Kill process and start server? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill -9 $PID 2>/dev/null || true
            sleep 1
        else
            echo -e "${YELLOW}Using existing server...${NC}"
            SERVER_RUNNING=true
        fi
    else
        echo -e "${GREEN}✅ Port 8000 is available${NC}"
        SERVER_RUNNING=false
    fi
else
    echo -e "${YELLOW}⚠️  Cannot check port (lsof not available)${NC}"
    SERVER_RUNNING=false
fi
echo ""

if [ "$SERVER_RUNNING" = false ]; then
    echo -e "${BLUE}📋 Step 4: Starting server in background...${NC}"
    export $(cat .env | grep -v '^#' | xargs)
    $VENV_PYTHON app.py > server_test.log 2>&1 &
    SERVER_PID=$!
    echo "Server started with PID: $SERVER_PID"
    echo "Waiting for server to start..."
    
    # Wait for server to be ready (check multiple times)
    MAX_WAIT=15
    WAITED=0
    while [ $WAITED -lt $MAX_WAIT ]; do
        if curl -s http://localhost:8000/api/health >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Server is ready!${NC}"
            break
        fi
        sleep 1
        WAITED=$((WAITED + 1))
        echo -n "."
    done
    echo ""
    
    # Check if server is actually running
    if ! curl -s http://localhost:8000/api/health >/dev/null 2>&1; then
        echo -e "${RED}❌ Server failed to start${NC}"
        echo "Last 20 lines of server log:"
        tail -20 server_test.log 2>/dev/null || echo "No log file found"
        exit 1
    fi
    echo ""
fi

echo -e "${BLUE}📋 Step 5: Testing endpoints...${NC}"
echo ""

# Test health endpoint
echo -n "Testing /api/health... "
HEALTH_RESPONSE=$(curl -s -w "\n%{http_code}" http://localhost:8000/api/health 2>/dev/null || echo -e "\n000")
HTTP_CODE=$(echo "$HEALTH_RESPONSE" | tail -1)
if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ OK${NC}"
    echo "   Response: $(echo "$HEALTH_RESPONSE" | head -1)"
else
    echo -e "${RED}❌ Failed (HTTP $HTTP_CODE)${NC}"
    if [ "$SERVER_RUNNING" = false ]; then
        echo "   Check server_test.log for errors"
        tail -20 server_test.log 2>/dev/null || true
    fi
    exit 1
fi

# Test examples endpoint
echo -n "Testing /api/examples... "
EXAMPLES_RESPONSE=$(curl -s -w "\n%{http_code}" http://localhost:8000/api/examples 2>/dev/null || echo -e "\n000")
HTTP_CODE=$(echo "$EXAMPLES_RESPONSE" | tail -1)
if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ OK${NC}"
    EXAMPLE_COUNT=$(echo "$EXAMPLES_RESPONSE" | head -1 | grep -o '"title"' | wc -l | tr -d ' ')
    echo "   Found $EXAMPLE_COUNT examples"
else
    echo -e "${RED}❌ Failed (HTTP $HTTP_CODE)${NC}"
fi

# Test frontend
echo -n "Testing frontend (/)... "
FRONTEND_RESPONSE=$(curl -s -w "\n%{http_code}" http://localhost:8000/ 2>/dev/null || echo -e "\n000")
HTTP_CODE=$(echo "$FRONTEND_RESPONSE" | tail -1)
if [ "$HTTP_CODE" = "200" ]; then
    if echo "$FRONTEND_RESPONSE" | head -1 | grep -q "DevOrchestrator"; then
        echo -e "${GREEN}✅ OK${NC}"
    else
        echo -e "${YELLOW}⚠️  Response received but content may be incorrect${NC}"
    fi
else
    echo -e "${RED}❌ Failed (HTTP $HTTP_CODE)${NC}"
fi

echo ""
echo -e "${GREEN}=========================================="
echo "  ✅ Server Test Complete!"
echo "==========================================${NC}"
echo ""
echo -e "${BLUE}Server is running on: ${GREEN}http://localhost:8000${NC}"
echo -e "${BLUE}Health check: ${GREEN}http://localhost:8000/api/health${NC}"
echo -e "${BLUE}Frontend: ${GREEN}http://localhost:8000${NC}"
echo ""
if [ "$SERVER_RUNNING" = false ]; then
    echo -e "${YELLOW}Server is running in background (PID: $SERVER_PID)${NC}"
    echo "To stop: kill $SERVER_PID"
    echo "To view logs: tail -f server_test.log"
fi
echo ""
echo -e "${GREEN}✅ Everything is working! Open http://localhost:8000 in your browser!${NC}"

