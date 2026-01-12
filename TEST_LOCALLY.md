# 🧪 Test DevOrchestrator Locally

Complete guide to test your app locally before deploying.

---

## 📋 Prerequisites Check

First, let's check what you have installed:

```bash
# Check Python version (need 3.11+)
python3 --version

# Check pip
pip3 --version

# Check if you have a Groq API key
# Get one at: https://console.groq.com/keys
```

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Create Virtual Environment

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
# On macOS/Linux:
source venv/bin/activate

# On Windows:
# venv\Scripts\activate
```

### Step 2: Install Dependencies

```bash
# Upgrade pip first
pip install --upgrade pip

# Install all dependencies
pip install -r requirements.txt
```

### Step 3: Set Up Environment Variables

```bash
# Copy the example file
cp env.example .env

# Edit .env and add your Groq API key
# Use your favorite editor:
nano .env
# or
code .env
# or
vim .env
```

**Important**: Edit `.env` and replace `your_groq_api_key_here` with your actual API key.

### Step 4: Create Required Directories

```bash
# Create directories for generated projects and logs
mkdir -p generated_projects logs
```

### Step 5: Run the App

```bash
# Start the server
python app.py
```

You should see:
```
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000
```

### Step 6: Test in Browser

Open your browser and visit:
- **Main page**: http://localhost:8000
- **Health check**: http://localhost:8000/api/health
- **API examples**: http://localhost:8000/api/examples

---

## ✅ Testing Checklist

### 1. Health Check

```bash
# Using curl
curl http://localhost:8000/api/health

# Should return:
# {"status":"healthy","version":"1.0.0"}
```

### 2. Frontend

- Open http://localhost:8000 in your browser
- You should see the DevOrchestrator web interface

### 3. API Examples

```bash
curl http://localhost:8000/api/examples

# Should return JSON with example prompts
```

### 4. Test Project Generation (Optional)

```bash
# Test the API endpoint
curl -X POST http://localhost:8000/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Create a simple hello world program in Python",
    "recursion_limit": 50
  }'
```

**Note**: This will use your Groq API key and may take a minute.

---

## 🐛 Troubleshooting

### Issue: Python version too old

```bash
# Check your Python version
python3 --version

# If less than 3.11, install Python 3.11+
# macOS:
brew install python@3.11

# Or download from: https://www.python.org/downloads/
```

### Issue: Module not found

```bash
# Make sure virtual environment is activated
source venv/bin/activate  # macOS/Linux
# venv\Scripts\activate   # Windows

# Reinstall dependencies
pip install -r requirements.txt
```

### Issue: GROQ_API_KEY not found

```bash
# Check if .env file exists
ls -la .env

# Check if API key is set
cat .env | grep GROQ_API_KEY

# Make sure .env is in the root directory
```

### Issue: Port 8000 already in use

```bash
# Find what's using port 8000
lsof -i :8000

# Kill the process (replace PID with actual process ID)
kill -9 <PID>

# Or use a different port
PORT=8001 python app.py
```

### Issue: Import errors

```bash
# Make sure you're in the project root directory
pwd

# Should show: .../DevOrchestrator_Autonomous_Multi_Agent_SDLC_Engine

# Check if agent directory exists
ls -la agent/
```

---

## 🧪 Advanced Testing

### Test with Python Script

Create a test file `test_local.py`:

```python
import requests
import json

BASE_URL = "http://localhost:8000"

def test_health():
    response = requests.get(f"{BASE_URL}/api/health")
    print(f"Health Check: {response.status_code}")
    print(f"Response: {response.json()}")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

def test_examples():
    response = requests.get(f"{BASE_URL}/api/examples")
    print(f"Examples: {response.status_code}")
    print(f"Response: {response.json()}")
    assert response.status_code == 200

def test_generate():
    payload = {
        "prompt": "Create a simple calculator in Python",
        "recursion_limit": 50
    }
    response = requests.post(
        f"{BASE_URL}/api/generate",
        json=payload
    )
    print(f"Generate: {response.status_code}")
    print(f"Response: {response.json()}")

if __name__ == "__main__":
    print("Testing DevOrchestrator API...")
    test_health()
    test_examples()
    # test_generate()  # Uncomment to test generation (uses API key)
    print("✅ All tests passed!")
```

Run it:
```bash
pip install requests  # If not already installed
python test_local.py
```

---

## 🔍 Check Logs

The app logs to console. Watch for:
- ✅ "Application startup complete" - App started successfully
- ✅ "INFO" messages - Normal operation
- ❌ "ERROR" messages - Something went wrong

---

## 📝 Quick Test Commands

```bash
# 1. Check if server is running
curl http://localhost:8000/api/health

# 2. Test frontend
open http://localhost:8000  # macOS
# or
xdg-open http://localhost:8000  # Linux
# or just open in browser manually

# 3. Test API examples
curl http://localhost:8000/api/examples | python -m json.tool

# 4. Check if directories exist
ls -la generated_projects/
ls -la logs/
```

---

## ✅ Success Indicators

You'll know everything is working when:

1. ✅ Server starts without errors
2. ✅ Health check returns `{"status":"healthy"}`
3. ✅ Frontend loads in browser
4. ✅ API examples endpoint works
5. ✅ No error messages in console

---

## 🚀 Next Steps

Once local testing works:

1. ✅ Test all endpoints
2. ✅ Try generating a project
3. ✅ Check generated files in `generated_projects/` directory
4. ✅ Review logs for any issues
5. ✅ Ready to deploy to Vercel!

---

## 🆘 Still Having Issues?

1. **Check Python version**: Must be 3.11+
2. **Check virtual environment**: Make sure it's activated
3. **Check dependencies**: Run `pip install -r requirements.txt` again
4. **Check .env file**: Make sure GROQ_API_KEY is set
5. **Check logs**: Look at console output for errors

---

**Once local testing works, you're ready to deploy! 🎉**

