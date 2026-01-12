#!/bin/bash
# Google Cloud Run deployment script for DevOrchestrator

set -e

# Configuration
PROJECT_ID=""  # Set your GCP project ID
SERVICE_NAME="dev-orchestrator"
REGION="us-central1"
IMAGE_NAME="gcr.io/$PROJECT_ID/$SERVICE_NAME"

echo "🚀 Deploying DevOrchestrator to Google Cloud Run..."

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ Google Cloud SDK is not installed. Please install it from https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if PROJECT_ID is set
if [ -z "$PROJECT_ID" ]; then
    echo "⚠️  PROJECT_ID is not set. Getting current project..."
    PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
    
    if [ -z "$PROJECT_ID" ]; then
        echo "❌ No GCP project found. Please set PROJECT_ID or run: gcloud config set project YOUR_PROJECT_ID"
        exit 1
    fi
fi

echo "✅ Using GCP project: $PROJECT_ID"

# Set the project
gcloud config set project $PROJECT_ID

# Enable required APIs
echo "🔧 Enabling required APIs..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com

# Check if GROQ_API_KEY is set
if [ -z "$GROQ_API_KEY" ]; then
    echo "⚠️  GROQ_API_KEY environment variable is not set!"
    echo "Please set it: export GROQ_API_KEY=your_key_here"
    read -p "Enter your GROQ_API_KEY: " GROQ_API_KEY
fi

# Build and push the image
echo "🔨 Building Docker image..."
gcloud builds submit --tag $IMAGE_NAME

# Deploy to Cloud Run
echo "🚀 Deploying to Cloud Run..."
gcloud run deploy $SERVICE_NAME \
    --image $IMAGE_NAME \
    --platform managed \
    --region $REGION \
    --allow-unauthenticated \
    --port 8000 \
    --memory 2Gi \
    --cpu 2 \
    --timeout 300 \
    --max-instances 10 \
    --set-env-vars "GROQ_API_KEY=$GROQ_API_KEY,ENVIRONMENT=production,PORT=8000,HOST=0.0.0.0"

# Get the service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --platform managed --region $REGION --format 'value(status.url)')

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your application is available at: $SERVICE_URL"
echo "📊 Health check: $SERVICE_URL/api/health"
echo ""
echo "To view logs:"
echo "  gcloud run logs read $SERVICE_NAME --region $REGION --limit 50"
echo ""
echo "To update the service:"
echo "  ./gcp-deploy.sh"

