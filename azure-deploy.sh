#!/bin/bash
# Azure Container Instances deployment script for DevOrchestrator

set -e

# Configuration
RESOURCE_GROUP="dev-orchestrator-rg"
CONTAINER_NAME="dev-orchestrator"
REGISTRY_NAME="devorchestratoracr"  # Change this to your unique ACR name
IMAGE_NAME="dev-orchestrator"
REGION="eastus"

echo "🚀 Deploying DevOrchestrator to Azure Container Instances..."

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it from https://aka.ms/InstallAzureCLI"
    exit 1
fi

# Login to Azure (if not already logged in)
echo "📝 Checking Azure login status..."
az account show &> /dev/null || az login

# Get subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo "✅ Using subscription: $SUBSCRIPTION_ID"

# Create resource group
echo "📦 Creating resource group: $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $REGION || echo "Resource group already exists"

# Create Azure Container Registry (if it doesn't exist)
echo "🐳 Creating Azure Container Registry..."
az acr create --resource-group $RESOURCE_GROUP --name $REGISTRY_NAME --sku Basic --admin-enabled true || echo "ACR already exists"

# Login to ACR
echo "🔐 Logging into ACR..."
az acr login --name $REGISTRY_NAME

# Build and push image
echo "🔨 Building Docker image..."
docker build -t $REGISTRY_NAME.azurecr.io/$IMAGE_NAME:latest .

echo "📤 Pushing image to ACR..."
docker push $REGISTRY_NAME.azurecr.io/$IMAGE_NAME:latest

# Get ACR credentials
ACR_USERNAME=$(az acr credential show --name $REGISTRY_NAME --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name $REGISTRY_NAME --query passwords[0].value -o tsv)

# Check if GROQ_API_KEY is set
if [ -z "$GROQ_API_KEY" ]; then
    echo "⚠️  GROQ_API_KEY environment variable is not set!"
    echo "Please set it: export GROQ_API_KEY=your_key_here"
    read -p "Enter your GROQ_API_KEY: " GROQ_API_KEY
fi

# Deploy to Azure Container Instances
echo "🚀 Deploying container instance..."
az container create \
    --resource-group $RESOURCE_GROUP \
    --name $CONTAINER_NAME \
    --image $REGISTRY_NAME.azurecr.io/$IMAGE_NAME:latest \
    --registry-login-server $REGISTRY_NAME.azurecr.io \
    --registry-username $ACR_USERNAME \
    --registry-password $ACR_PASSWORD \
    --dns-name-label $CONTAINER_NAME \
    --ports 8000 \
    --cpu 2 \
    --memory 4 \
    --environment-variables \
        GROQ_API_KEY="$GROQ_API_KEY" \
        ENVIRONMENT=production \
        PORT=8000 \
        HOST=0.0.0.0 \
    --restart-policy Always

# Get the FQDN
FQDN=$(az container show --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME --query ipAddress.fqdn -o tsv)

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your application is available at: http://$FQDN:8000"
echo "📊 Health check: http://$FQDN:8000/api/health"
echo ""
echo "To view logs:"
echo "  az container logs --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME --follow"
echo ""
echo "To delete the deployment:"
echo "  az group delete --name $RESOURCE_GROUP --yes --no-wait"

