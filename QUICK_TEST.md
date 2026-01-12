# ⚡ Quick Local Test - 3 Steps

Test your DevOrchestrator app locally in 3 simple steps!

---

## 🚀 Step 1: Setup (Run Once)

```bash
# Run the setup script
./setup_local.sh
```

This will:
- ✅ Create virtual environment
- ✅ Install all dependencies
- ✅ Create .env file
- ✅ Create required directories

**OR do it manually:**

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Create .env file
cp env.example .env

# Create directories
mkdir -p generated_projects logs
```

---

## 🔑 Step 2: Add Your API Key

Edit the `.env` file and add your Groq API key:

```bash
# Open .env file
nano .env
# or
code .env
# or
vim .env
```

**Change this line:**
```
GROQ_API_KEY=your_groq_api_key_here
```

**To:**
```
GROQ_API_KEY=gsk_your_actual_api_key_here
```

**Get your API key:** https://console.groq.com/keys

---

## ▶️ Step 3: Run & Test

### Start the Server

```bash
# Make sure virtual environment is activated
source venv/bin/activate

# Run the app
python app.py
```

You should see:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
```

### Test It

**Option 1: Use the test script**
```bash
# In a new terminal (keep server running)
source venv/bin/activate
python test_local.py
```

**Option 2: Test manually**

1. **Open browser**: http://localhost:8000
2. **Health check**: http://localhost:8000/api/health
3. **Examples**: http://localhost:8000/api/examples

**Option 3: Use curl**
```bash
# Health check
curl http://localhost:8000/api/health

# Examples
curl http://localhost:8000/api/examples
```

---

## ✅ Success!

If you see:
- ✅ Server starts without errors
- ✅ Health check returns `{"status":"healthy"}`
- ✅ Frontend loads in browser
- ✅ No error messages

**You're ready to deploy! 🎉**

---

## 🐛 Quick Fixes

**"Module not found"**
```bash
source venv/bin/activate
pip install -r requirements.txt
```

**"GROQ_API_KEY not found"**
```bash
# Check .env file exists and has your key
cat .env | grep GROQ_API_KEY
```

**"Port 8000 in use"**
```bash
# Find and kill process
lsof -i :8000
kill -9 <PID>
```

---

**That's it! Once local testing works, deploy to Vercel! 🚀**

