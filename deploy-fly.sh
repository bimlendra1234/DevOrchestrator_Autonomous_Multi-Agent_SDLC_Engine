#!/bin/bash
# Fly.io deployment script for DevOrchestrator

set -e

echo "🚀 Deploying DevOrchestrator to Fly.io..."

# Check if fly CLI is installed
if ! command -v fly &> /dev/null; then
    echo "❌ Fly CLI is not installed."
    echo "Install it from: https://fly.io/docs/hands-on/install-flyctl/"
    echo ""
    echo "macOS:"
    echo "  curl -L https://fly.io/install.sh | sh"
    exit 1
fi

# Check if logged in
if ! fly auth whoami &> /dev/null; then
    echo "📝 Please login to Fly.io..."
    fly auth login
fi

# Check if app already exists
if fly apps list | grep -q "dev-orchestrator"; then
    echo "✅ App 'dev-orchestrator' already exists"
    APP_EXISTS=true
else
    echo "📦 Creating new Fly.io app..."
    fly launch --no-deploy --name dev-orchestrator --region ord
    APP_EXISTS=false
fi

# Check if GROQ_API_KEY is set
if [ -z "$GROQ_API_KEY" ]; then
    echo "⚠️  GROQ_API_KEY environment variable is not set!"
    read -p "Enter your GROQ_API_KEY: " GROQ_API_KEY
fi

# Set secrets
echo "🔐 Setting environment variables..."
fly secrets set GROQ_API_KEY="$GROQ_API_KEY" -a dev-orchestrator

# Deploy
echo "🚀 Deploying to Fly.io..."
fly deploy -a dev-orchestrator

# Get URL
echo ""
echo "✅ Deployment complete!"
echo "🌐 Your app is available at:"
fly open -a dev-orchestrator

echo ""
echo "To view logs:"
echo "  fly logs -a dev-orchestrator"
echo ""
echo "To scale:"
echo "  fly scale count 2 -a dev-orchestrator"

