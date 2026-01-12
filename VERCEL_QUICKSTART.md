# ⚡ Vercel Quick Start - 5 Minutes

Get your DevOrchestrator live on Vercel in 5 minutes!

---

## 🚀 Step-by-Step

### 1. Push to GitHub (1 minute)

```bash
git add .
git commit -m "Ready for Vercel deployment"
git push origin main
```

### 2. Sign Up on Vercel (1 minute)

1. Go to: **https://vercel.com**
2. Click **"Sign Up"**
3. Choose **"Continue with GitHub"**
4. Authorize Vercel

### 3. Deploy (2 minutes)

1. Click **"Add New..."** → **"Project"**
2. Find **DevOrchestrator** repository
3. Click **"Import"**
4. Scroll down to **"Environment Variables"**
5. Add:
   - Name: `GROQ_API_KEY`
   - Value: `your_groq_api_key_here` (get from https://console.groq.com/keys)
6. Click **"Deploy"**

### 4. Wait & Get URL (1 minute)

- Wait 3-5 minutes for build
- Vercel will show: **"Congratulations! Your project has been deployed"**
- Copy your URL: `https://your-app.vercel.app`

**🎉 DONE! Your app is live!**

---

## ✅ Test It

Visit:
- Main page: `https://your-app.vercel.app`
- Health check: `https://your-app.vercel.app/api/health`
- Examples: `https://your-app.vercel.app/api/examples`

---

## 🔄 Auto-Updates

Vercel automatically deploys when you push to GitHub:
- Push to `main` branch → Auto-deploy
- Get preview URLs for pull requests
- All deployments are tracked

---

## 🎤 Show to Recruiters

Just share your URL:
> "I've deployed my DevOrchestrator project on Vercel. You can see it live at [your-url]. It's a multi-agent AI system that generates complete codebases."

---

## 🆘 Problems?

**Build fails?**
- Check that `Dockerfile` is in root directory
- Verify `requirements.txt` exists
- Check build logs in Vercel dashboard

**App doesn't work?**
- Verify `GROQ_API_KEY` is set in environment variables
- Check function logs in Vercel dashboard
- Test API key at https://console.groq.com/keys

**Need help?**
- See [VERCEL_DEPLOY.md](./VERCEL_DEPLOY.md) for detailed guide
- Vercel docs: https://vercel.com/docs

---

**That's it! You're ready to showcase! 🚀**

