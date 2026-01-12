#!/bin/bash
# Vercel deployment script for DevOrchestrator

set -e

echo "🚀 Deploying DevOrchestrator to Vercel..."

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📦 Vercel CLI is not installed."
    echo "Installing Vercel CLI..."
    
    # Check if npm is available
    if command -v npm &> /dev/null; then
        npm install -g vercel
    else
        echo "❌ npm is not installed. Please install Node.js first."
        echo ""
        echo "Or use npx (no installation needed):"
        echo "  npx vercel --prod"
        exit 1
    fi
fi

# Check if logged in
if ! vercel whoami &> /dev/null; then
    echo "📝 Please login to Vercel..."
    vercel login
fi

# Check if GROQ_API_KEY is set
if [ -z "$GROQ_API_KEY" ]; then
    echo "⚠️  GROQ_API_KEY environment variable is not set!"
    read -p "Enter your GROQ_API_KEY: " GROQ_API_KEY
fi

# Set environment variable
echo "🔐 Setting environment variables..."
vercel env add GROQ_API_KEY production <<< "$GROQ_API_KEY" || echo "Variable may already exist"

# Deploy
echo "🚀 Deploying to Vercel..."
vercel --prod --yes

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Your app is live at the URL shown above!"
echo ""
echo "To view deployments:"
echo "  vercel ls"
echo ""
echo "To view logs:"
echo "  vercel logs"
echo ""
echo "To add more environment variables:"
echo "  vercel env add VARIABLE_NAME"

