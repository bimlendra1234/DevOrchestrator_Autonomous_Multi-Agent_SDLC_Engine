# 🚀 Deploy DevOrchestrator to Vercel

Complete guide to deploy your DevOrchestrator project on Vercel.

---

## 📋 Prerequisites

1. **GitHub Account** - Your code needs to be on GitHub
2. **Vercel Account** - Sign up at [vercel.com](https://vercel.com) (free)
3. **Groq API Key** - Get free at [console.groq.com](https://console.groq.com/keys)

---

## 🚀 Method 1: Deploy via Vercel Dashboard (Easiest)

### Step 1: Push Code to GitHub

```bash
# Make sure your code is on GitHub
git add .
git commit -m "Ready for Vercel deployment"
git push origin main
```

### Step 2: Sign Up / Login to Vercel

1. Go to [vercel.com](https://vercel.com)
2. Click **"Sign Up"** or **"Log In"**
3. Choose **"Continue with GitHub"**
4. Authorize Vercel to access your GitHub

### Step 3: Import Your Project

1. Click **"Add New..."** → **"Project"**
2. Find your **DevOrchestrator** repository
3. Click **"Import"**

### Step 4: Configure Project

Vercel will auto-detect your `vercel.json` configuration. You may need to adjust:

**Project Settings:**
- **Framework Preset**: Other (or leave blank)
- **Root Directory**: `./` (root)
- **Build Command**: Leave empty (Docker handles it)
- **Output Directory**: Leave empty
- **Install Command**: Leave empty

**Environment Variables:**
Click **"Environment Variables"** and add:
- `GROQ_API_KEY` = `your_groq_api_key_here`
- `PORT` = `8000` (optional, Vercel sets this automatically)
- `ENVIRONMENT` = `production`

### Step 5: Deploy!

1. Click **"Deploy"**
2. Wait 3-5 minutes for the build
3. Vercel will show you the deployment URL

**🎉 Done!** Your app is live at: `https://your-app.vercel.app`

---

## 🖥️ Method 2: Deploy via Vercel CLI

### Step 1: Install Vercel CLI

```bash
# Install globally
npm install -g vercel

# Or use npx (no installation needed)
npx vercel
```

### Step 2: Login to Vercel

```bash
vercel login
```

This will open your browser to authenticate.

### Step 3: Deploy

```bash
# From your project directory
vercel

# For production deployment
vercel --prod
```

### Step 4: Set Environment Variables

```bash
# Set your Groq API key
vercel env add GROQ_API_KEY

# When prompted, enter your API key
# Select: Production, Preview, and Development

# Verify
vercel env ls
```

### Step 5: Redeploy with Environment Variables

```bash
vercel --prod
```

**🎉 Done!** Your app is live!

---

## 🔧 Configuration Details

### vercel.json

Your project includes a `vercel.json` file configured for Docker deployment:

```json
{
  "version": 2,
  "builds": [
    {
      "src": "Dockerfile",
      "use": "@vercel/docker"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/"
    }
  ]
}
```

This tells Vercel to:
- Use Docker for building
- Route all requests to your FastAPI app
- Support API routes and WebSocket connections

### Dockerfile

Your Dockerfile is already configured to work with Vercel:
- Uses `PORT` environment variable (Vercel sets this automatically)
- Exposes port 8000
- Includes health check endpoint

---

## ✅ Verify Deployment

After deployment, test your app:

1. **Health Check**
   ```
   https://your-app.vercel.app/api/health
   ```
   Should return: `{"status":"healthy","version":"1.0.0"}`

2. **Frontend**
   ```
   https://your-app.vercel.app
   ```
   Should show the DevOrchestrator web interface

3. **API Examples**
   ```
   https://your-app.vercel.app/api/examples
   ```
   Should return example prompts

---

## 🔄 Updating Your Deployment

### Automatic Updates

Vercel automatically deploys when you push to GitHub:
1. Push to your `main` branch
2. Vercel detects the change
3. Automatically builds and deploys
4. You get a new deployment URL

### Manual Updates

```bash
# Deploy latest changes
vercel --prod

# Or push to GitHub (triggers auto-deploy)
git push origin main
```

---

## 🎯 Custom Domain (Optional)

### Add Custom Domain

1. Go to your project on Vercel dashboard
2. Click **"Settings"** → **"Domains"**
3. Enter your domain name
4. Follow DNS configuration instructions
5. Vercel will automatically set up SSL

**Benefits:**
- Professional URL (e.g., `dev-orchestrator.com`)
- Free SSL certificate
- Better for showcasing to recruiters

---

## 🔍 Troubleshooting

### Build Fails

**Issue**: Docker build fails
```bash
# Test Docker build locally first
docker build -t test .
docker run -p 8000:8000 -e GROQ_API_KEY=test test
```

**Solution**: 
- Check that `Dockerfile` is in the root directory
- Verify `requirements.txt` exists
- Check build logs in Vercel dashboard

### App Doesn't Work

**Issue**: API returns errors
- Check environment variables in Vercel dashboard
- Verify `GROQ_API_KEY` is set correctly
- Check function logs in Vercel dashboard

**Solution**:
1. Go to Vercel dashboard → Your project → "Deployments"
2. Click on latest deployment → "Functions" tab
3. Check logs for errors

### Port Issues

**Issue**: App can't bind to port
- Vercel automatically sets `PORT` environment variable
- Your Dockerfile should use `${PORT:-8000}` (already configured)

### Timeout Issues

**Issue**: Long-running requests timeout
- Vercel has a 10-second timeout for Hobby plan
- Pro plan has 60-second timeout
- Your `vercel.json` sets `maxDuration: 300` (requires Pro plan)

**Solution**:
- Upgrade to Pro plan for longer timeouts
- Or optimize your code to complete faster

---

## 📊 Vercel Plans

| Feature | Hobby (Free) | Pro ($20/month) |
|---------|--------------|-----------------|
| **Deployments** | Unlimited | Unlimited |
| **Bandwidth** | 100GB | 1TB |
| **Function Execution** | 100GB-hours | 1000GB-hours |
| **Timeout** | 10 seconds | 60 seconds (configurable) |
| **Custom Domain** | ✅ Yes | ✅ Yes |
| **SSL** | ✅ Free | ✅ Free |
| **Analytics** | ❌ No | ✅ Yes |

**For showcasing**: Hobby (free) plan is perfect!

---

## 🎤 Showcasing to Recruiters

When showing your Vercel deployment:

1. **Share the URL**: `https://your-app.vercel.app`
2. **Mention**: "Deployed on Vercel, one of the most popular deployment platforms"
3. **Highlight**: 
   - Automatic deployments from GitHub
   - Global CDN for fast performance
   - Free SSL certificate
   - Professional infrastructure

---

## 📝 Quick Reference

### Deploy Commands

```bash
# First deployment
vercel

# Production deployment
vercel --prod

# View deployments
vercel ls

# View logs
vercel logs

# Remove deployment
vercel remove
```

### Environment Variables

```bash
# Add variable
vercel env add GROQ_API_KEY

# List variables
vercel env ls

# Remove variable
vercel env rm GROQ_API_KEY
```

---

## 🚀 Next Steps

After deployment:

1. ✅ **Test your app** - Make sure everything works
2. ✅ **Add to README** - Update with your Vercel URL
3. ✅ **Share with recruiters** - Your app is live!
4. ✅ **Set up custom domain** (optional) - More professional

---

## 💡 Pro Tips

1. **Enable Preview Deployments**: Test changes before production
2. **Use Vercel Analytics**: Track usage (Pro plan)
3. **Set up Monitoring**: Use Vercel's built-in monitoring
4. **Optimize Images**: Use Vercel's image optimization
5. **Enable Caching**: Configure caching headers for better performance

---

## 🆘 Need Help?

- **Vercel Docs**: https://vercel.com/docs
- **Vercel Support**: https://vercel.com/support
- **Community**: https://github.com/vercel/vercel/discussions

---

**Your DevOrchestrator is now live on Vercel! 🎉**

Share your URL: `https://your-app.vercel.app`

