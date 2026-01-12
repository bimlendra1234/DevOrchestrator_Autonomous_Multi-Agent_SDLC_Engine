#!/bin/bash
# DevOrchestrator Deployment Script
# This script automates the deployment process for various platforms

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="dev-orchestrator"
VERSION=$(grep 'version' pyproject.toml | head -1 | awk '{print $3}' | tr -d '"')
DOCKER_REGISTRY="${DOCKER_REGISTRY:-docker.io}"
DOCKER_USERNAME="${DOCKER_USERNAME:-yourusername}"
IMAGE_NAME="${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${PROJECT_NAME}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    command -v docker >/dev/null 2>&1 || { print_error "Docker not installed"; exit 1; }
    print_success "Docker installed"
    
    command -v docker-compose >/dev/null 2>&1 || { print_error "Docker Compose not installed"; exit 1; }
    print_success "Docker Compose installed"
    
    [ -f .env ] && print_success ".env file exists" || print_info "Please create .env file from .env.example"
}

# Build Docker image
build_docker_image() {
    print_header "Building Docker Image"
    print_info "Building ${IMAGE_NAME}:${IMAGE_TAG}"
    
    docker build \
        --build-arg VERSION=${VERSION} \
        -t ${IMAGE_NAME}:${IMAGE_TAG} \
        -t ${IMAGE_NAME}:latest \
        .
    
    print_success "Docker image built successfully"
}

# Push Docker image
push_docker_image() {
    print_header "Pushing Docker Image"
    print_info "Pushing ${IMAGE_NAME}:${IMAGE_TAG} to registry"
    
    docker login
    docker push ${IMAGE_NAME}:${IMAGE_TAG}
    docker push ${IMAGE_NAME}:latest
    
    print_success "Docker image pushed successfully"
}

# Run locally with Docker Compose
run_docker_compose() {
    print_header "Running with Docker Compose"
    
    if [ ! -f .env ]; then
        print_error ".env file not found"
        print_info "Creating .env from .env.example..."
        cp .env.example .env
        print_info "Please edit .env with your configuration"
        exit 1
    fi
    
    docker-compose up -d
    print_success "Services started successfully"
    print_info "Access the application at:"
    print_info "  - Frontend: http://localhost"
    print_info "  - API: http://localhost:8000"
    print_info "  - Health: http://localhost:8000/api/health"
}

# Deploy to AWS
deploy_aws() {
    print_header "Deploying to AWS"
    print_info "Prerequisites: AWS CLI configured with credentials"
    
    read -p "Enter AWS region (default: us-east-1): " AWS_REGION
    AWS_REGION=${AWS_REGION:-us-east-1}
    
    read -p "Enter AWS Account ID: " AWS_ACCOUNT_ID
    
    # Create ECR repository
    print_info "Creating ECR repository..."
    aws ecr create-repository \
        --repository-name ${PROJECT_NAME} \
        --region ${AWS_REGION} 2>/dev/null || true
    
    # Get ECR login token
    print_info "Logging into ECR..."
    aws ecr get-login-password --region ${AWS_REGION} | \
        docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
    
    # Build and push to ECR
    ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    ECR_IMAGE="${ECR_REGISTRY}/${PROJECT_NAME}:${VERSION}"
    
    print_info "Building and pushing Docker image to ECR..."
    docker build -t ${ECR_IMAGE} .
    docker push ${ECR_IMAGE}
    
    print_success "Image pushed to ECR: ${ECR_IMAGE}"
    print_info "Next steps:"
    print_info "  1. Create App Runner service: https://console.aws.amazon.com/apprunner"
    print_info "  2. Use image URI: ${ECR_IMAGE}"
    print_info "  3. Configure environment variables"
}

# Deploy to GCP
deploy_gcp() {
    print_header "Deploying to Google Cloud Run"
    print_info "Prerequisites: gcloud CLI configured"
    
    read -p "Enter GCP Project ID: " GCP_PROJECT_ID
    read -p "Enter GCP Region (default: us-central1): " GCP_REGION
    GCP_REGION=${GCP_REGION:-us-central1}
    
    # Build and push to GCR
    print_info "Building and pushing to Google Container Registry..."
    gcloud builds submit \
        --tag gcr.io/${GCP_PROJECT_ID}/${PROJECT_NAME}:${VERSION} \
        --project ${GCP_PROJECT_ID}
    
    # Deploy to Cloud Run
    print_info "Deploying to Cloud Run..."
    gcloud run deploy ${PROJECT_NAME} \
        --image gcr.io/${GCP_PROJECT_ID}/${PROJECT_NAME}:${VERSION} \
        --project ${GCP_PROJECT_ID} \
        --region ${GCP_REGION} \
        --platform managed \
        --port 8000 \
        --allow-unauthenticated \
        --set-env-vars GROQ_API_KEY=${GROQ_API_KEY}
    
    print_success "Deployed to Cloud Run successfully"
}

# Run tests
run_tests() {
    print_header "Running Tests"
    
    pip install pytest pytest-cov
    pytest tests/ -v --cov=agent --cov-report=html
    
    print_success "Tests completed"
}

# Show help
show_help() {
    cat << EOF
Usage: ./deploy.sh [COMMAND]

Commands:
    check           Check prerequisites
    build           Build Docker image
    push            Push Docker image to registry
    local           Run locally with Docker Compose
    aws             Deploy to AWS
    gcp             Deploy to Google Cloud Run
    test            Run test suite
    help            Show this help message

Examples:
    ./deploy.sh check
    ./deploy.sh local
    ./deploy.sh aws
    ./deploy.sh gcp
EOF
}

# Main
case "${1:-help}" in
    check)
        check_prerequisites
        ;;
    build)
        check_prerequisites
        build_docker_image
        ;;
    push)
        check_prerequisites
        build_docker_image
        push_docker_image
        ;;
    local)
        check_prerequisites
        run_docker_compose
        ;;
    aws)
        check_prerequisites
        build_docker_image
        deploy_aws
        ;;
    gcp)
        check_prerequisites
        build_docker_image
        deploy_gcp
        ;;
    test)
        run_tests
        ;;
    help|*)
        show_help
        ;;
esac
