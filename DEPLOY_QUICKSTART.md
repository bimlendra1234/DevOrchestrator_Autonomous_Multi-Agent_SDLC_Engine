# 🚀 Quick Deployment Guide for Recruiters

This guide will help you deploy DevOrchestrator to showcase it to Microsoft or Google recruiters in **under 10 minutes**.

## 🎯 Choose Your Platform

### For Google Recruiters → **Google Cloud Run** (Recommended)
- ✅ Free tier available
- ✅ Serverless, auto-scaling
- ✅ Perfect for showcasing to Google
- ⏱️ Deployment time: ~5 minutes

### For Microsoft Recruiters → **Azure Container Instances**
- ✅ Free tier available
- ✅ Easy deployment
- ✅ Perfect for showcasing to Microsoft
- ⏱️ Deployment time: ~5 minutes

### For Easy Deployment → **Railway** or **Render**
- ✅ No credit card required (Railway)
- ✅ One-click deployment
- ✅ Perfect for quick demos
- ⏱️ Deployment time: ~3 minutes

---

## 📋 Prerequisites

1. **Groq API Key** (Required)
   - Get it free at: https://console.groq.com/keys
   - Save it somewhere safe

2. **Platform Account** (Choose one):
   - Google Cloud: https://cloud.google.com (Free $300 credit)
   - Azure: https://azure.microsoft.com/free (Free $200 credit)
   - Railway: https://railway.app (Free tier)
   - Render: https://render.com (Free tier)

---

## 🟢 Option 1: Google Cloud Run (For Google Recruiters)

### Step 1: Install Google Cloud SDK
```bash
# macOS
brew install google-cloud-sdk

# Or download from: https://cloud.google.com/sdk/docs/install
```

### Step 2: Login and Setup
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

### Step 3: Deploy
```bash
# Make script executable
chmod +x gcp-deploy.sh

# Set your project ID
export PROJECT_ID=your-gcp-project-id
export GROQ_API_KEY=your_groq_api_key

# Deploy!
./gcp-deploy.sh
```

**That's it!** Your app will be live at a URL like:
`https://dev-orchestrator-xxxxx-uc.a.run.app`

---

## 🔵 Option 2: Azure Container Instances (For Microsoft Recruiters)

### Step 1: Install Azure CLI
```bash
# macOS
brew install azure-cli

# Or download from: https://aka.ms/InstallAzureCLI
```

### Step 2: Login
```bash
az login
```

### Step 3: Deploy
```bash
# Make script executable
chmod +x azure-deploy.sh

# Set your API key
export GROQ_API_KEY=your_groq_api_key

# Deploy!
./azure-deploy.sh
```

**That's it!** Your app will be live at a URL like:
`http://dev-orchestrator.eastus.azurecontainer.io:8000`

---

## 🟡 Option 3: Railway (Easiest - No Credit Card)

### Step 1: Connect GitHub
1. Go to https://railway.app
2. Click "Start a New Project"
3. Select "Deploy from GitHub repo"
4. Connect your repository

### Step 2: Configure Environment Variables
In Railway dashboard:
- Go to your project → Variables
- Add: `GROQ_API_KEY` = `your_groq_api_key`
- Add: `PORT` = `8000`

### Step 3: Deploy
Railway will automatically:
- Detect the Dockerfile
- Build the image
- Deploy to production

**That's it!** Railway will give you a URL like:
`https://dev-orchestrator-production.up.railway.app`

---

## 🟣 Option 4: Render (Also Easy)

### Step 1: Connect GitHub
1. Go to https://render.com
2. Click "New +" → "Web Service"
3. Connect your GitHub repository

### Step 2: Configure
- **Name**: `dev-orchestrator`
- **Environment**: `Docker`
- **Region**: Choose closest to you
- **Branch**: `main` or `master`

### Step 3: Add Environment Variables
- `GROQ_API_KEY` = `your_groq_api_key`
- `PORT` = `8000`
- `ENVIRONMENT` = `production`

### Step 4: Deploy
Click "Create Web Service"

**That's it!** Render will give you a URL like:
`https://dev-orchestrator.onrender.com`

---

## ✅ Verify Deployment

After deployment, test your app:

```bash
# Health check
curl https://your-app-url/api/health

# Should return:
# {"status":"healthy","version":"1.0.0"}
```

Visit the URL in your browser to see the frontend!

---

## 🎤 Demo Script for Recruiters

When showing your deployed app:

1. **Open the URL** in your browser
2. **Show the UI**: "This is a full-stack application with a modern frontend"
3. **Test generation**: Enter a prompt like "Create a todo app"
4. **Show the API**: Visit `/api/health` and `/api/examples`
5. **Mention deployment**: "It's deployed on [Platform] with auto-scaling and health checks"

---

## 🔧 Troubleshooting

### Issue: Build fails
```bash
# Check Dockerfile
docker build -t test-image .
docker run -p 8000:8000 -e GROQ_API_KEY=test test-image
```

### Issue: API key not working
- Verify your Groq API key at: https://console.groq.com/keys
- Check environment variables in your platform dashboard

### Issue: Port conflicts
- Make sure `PORT` environment variable is set correctly
- Cloud Run uses `PORT` automatically
- Railway/Render also use `PORT`

---

## 📊 Cost Estimates

| Platform | Free Tier | Paid Tier (if needed) |
|----------|-----------|----------------------|
| **Google Cloud Run** | 2M requests/month | ~$0.40 per million requests |
| **Azure Container Instances** | $200 credit | ~$0.000012/second |
| **Railway** | $5 credit/month | $5/month for hobby |
| **Render** | Free tier (spins down) | $7/month for always-on |

**Recommendation**: Start with Railway or Render for free, then move to GCP/Azure for production.

---

## 🎯 Next Steps

1. ✅ Deploy to your chosen platform
2. ✅ Test the deployment
3. ✅ Update your README with the live URL
4. ✅ Create a demo video (optional but impressive)
5. ✅ Add the URL to your resume/LinkedIn

---

## 📞 Need Help?

- Check the main [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed instructions
- Review [PORTFOLIO_SHOWCASE.md](./PORTFOLIO_SHOWCASE.md) for presentation tips
- Open an issue on GitHub if you encounter problems

---

**Good luck with your interviews! 🚀**

