# DevOrchestrator - Quick Start Guide

## 🚀 Start in 5 Minutes

### Step 1: Get Your Groq API Key
1. Go to [console.groq.com](https://console.groq.com/keys)
2. Sign up (free)
3. Copy your API key

### Step 2: Clone & Setup
```bash
git clone https://github.com/yourusername/dev-orchestrator.git
cd dev-orchestrator
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Step 3: Configure
```bash
cp .env.example .env
# Edit .env and paste your GROQ_API_KEY
```

### Step 4: Run
```bash
python app.py
```

Open **http://localhost:8000** in your browser! 🎉

---

## 🐳 Docker Approach (Even Easier)

```bash
docker-compose up -d
# Wait 30 seconds for startup
# Visit http://localhost
```

That's it!

---

## 📚 Next Steps

1. **Try Examples**: Use the example projects in the UI
2. **Read Docs**: Check [DEPLOYMENT.md](DEPLOYMENT.md) for detailed guides
3. **Deploy to Cloud**: Follow cloud-specific guides for AWS, GCP, Azure
4. **Customize**: Modify prompts in `/agent` folder
5. **Scale**: Use Kubernetes for production

---

## 🆘 Troubleshooting

**Port 8000 in use?**
```bash
lsof -i :8000
kill -9 <PID>
```

**Groq API Key not working?**
```bash
echo $GROQ_API_KEY
# Should show your key
```

**Docker issues?**
```bash
docker system prune -a
docker-compose build --no-cache
```

---

## 💬 Need Help?

- 📖 Full docs: [DEPLOYMENT.md](DEPLOYMENT.md)
- 🐛 Found a bug? [Create an issue](https://github.com)
- 💡 Have an idea? [Start a discussion](https://github.com)

Happy coding! 🚀
