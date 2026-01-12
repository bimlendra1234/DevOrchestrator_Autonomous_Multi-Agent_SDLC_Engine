# 🚀 START HERE - Local Testing Setup

## ✅ Everything is Ready!

All setup files have been created. Follow these simple steps:

---

## 🎯 Step 1: Run the Setup Script

```bash
./run_local.sh
```

This will automatically:
- ✅ Create virtual environment
- ✅ Install all dependencies  
- ✅ Create .env file
- ✅ Create required directories
- ✅ Start the server

**OR** do it manually (see below)

---

## 🔑 Step 2: Add Your API Key (IMPORTANT!)

Before the app will work, you need to add your Groq API key:

1. **Get your API key** (free): https://console.groq.com/keys

2. **Edit the .env file**:
   ```bash
   nano .env
   ```
   
3. **Find this line**:
   ```
   GROQ_API_KEY=your_groq_api_key_here
   ```
   
4. **Replace with your actual key**:
   ```
   GROQ_API_KEY=gsk_your_actual_key_here
   ```

5. **Save and exit** (Ctrl+X, then Y, then Enter in nano)

---

## ▶️ Step 3: Start the Server

If you used the automated script, it's already running!

If not, run:
```bash
source venv/bin/activate
python app.py
```

---

## 🌐 Step 4: Open the UI

Once the server is running, open your browser:

**👉 http://localhost:8000**

You should see the DevOrchestrator interface!

---

## ✅ Verify It's Working

1. **Health Check**: http://localhost:8000/api/health
   - Should show: `{"status":"healthy","version":"1.0.0"}`

2. **Examples**: http://localhost:8000/api/examples
   - Should show example prompts

3. **Frontend**: http://localhost:8000
   - Should show the full UI

---

## 🧪 Test the App

In a new terminal:
```bash
source venv/bin/activate
python test_local.py
```

This will run automated tests to verify everything works.

---

## 🐛 Quick Fixes

**"Module not found"**
```bash
source venv/bin/activate
pip install -r requirements.txt
```

**"GROQ_API_KEY not found"**
- Make sure you edited `.env` and added your actual API key

**"Port 8000 in use"**
```bash
lsof -i :8000
kill -9 <PID>
```

---

## 📚 More Help

- **Detailed Setup**: `SETUP_COMPLETE.md`
- **Testing Guide**: `TEST_LOCALLY.md`
- **Quick Test**: `QUICK_TEST.md`

---

## 🎉 You're Ready!

Once you see the UI at http://localhost:8000, you're all set!

**Next**: Deploy to Vercel when ready! 🚀

