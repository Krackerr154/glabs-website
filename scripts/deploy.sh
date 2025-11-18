#!/bin/bash

# G-Labs Website Deployment Script
# This script automates the deployment process to your VPS

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - Update these values
REMOTE_USER="${DEPLOY_USER:-root}"
REMOTE_HOST="${DEPLOY_HOST:-your-vps-ip}"
REMOTE_PATH="${DEPLOY_PATH:-/opt/glabs-website}"
PROJECT_NAME="glabs-website"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required environment variables are set
if [ "$REMOTE_HOST" = "your-vps-ip" ]; then
    log_error "Please set DEPLOY_HOST environment variable or update deploy.sh"
    echo ""
    echo "Usage:"
    echo "  export DEPLOY_HOST=your.vps.ip"
    echo "  export DEPLOY_USER=your-username"
    echo "  ./deploy.sh"
    exit 1
fi

log_info "🚀 Starting G-Labs Website Deployment..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target: $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if .env file exists
if [ ! -f ".env" ]; then
    log_warn ".env file not found. Creating from .env.example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        log_info "Please edit .env file with your production values"
        read -p "Press Enter to continue after editing .env file..."
    else
        log_error ".env.example not found. Please create .env file manually."
        exit 1
    fi
fi

# Build the project locally
log_info "📦 Building the project..."
if ! npm run build; then
    log_error "Build failed! Please fix errors and try again."
    exit 1
fi
log_success "Build completed successfully"

# Create deployment package
log_info "📦 Creating deployment package..."
tar -czf deploy.tar.gz \
    dist/ \
    Dockerfile \
    docker-compose.yml \
    nginx.conf \
    package.json \
    package-lock.json \
    .env 2>/dev/null || tar -czf deploy.tar.gz \
    dist/ \
    Dockerfile \
    docker-compose.yml \
    nginx.conf \
    package.json \
    package-lock.json

log_success "Deployment package created"

# Test SSH connection
log_info "🔐 Testing SSH connection..."
if ! ssh -o BatchMode=yes -o ConnectTimeout=5 ${REMOTE_USER}@${REMOTE_HOST} exit 2>/dev/null; then
    log_error "Cannot connect to VPS. Please check:"
    echo "  1. VPS IP address is correct"
    echo "  2. SSH key is set up"
    echo "  3. Firewall allows SSH connection"
    rm deploy.tar.gz
    exit 1
fi
log_success "SSH connection successful"

# Transfer files to VPS
log_info "📤 Transferring files to VPS..."
ssh ${REMOTE_USER}@${REMOTE_HOST} "mkdir -p ${REMOTE_PATH}"

if ! scp -q deploy.tar.gz ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/; then
    log_error "File transfer failed!"
    rm deploy.tar.gz
    exit 1
fi
log_success "Files transferred successfully"

# Deploy on VPS
log_info "🚀 Deploying on VPS..."
ssh ${REMOTE_USER}@${REMOTE_HOST} << 'ENDSSH'
set -e

# Navigate to project directory
cd /opt/glabs-website

# Extract deployment package
echo "📦 Extracting files..."
tar -xzf deploy.tar.gz
rm deploy.tar.gz

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please run setup-vps.sh first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please run setup-vps.sh first."
    exit 1
fi

# Stop existing container
echo "🛑 Stopping existing container..."
docker-compose down 2>/dev/null || true

# Remove old images to free up space
echo "🧹 Cleaning up old Docker images..."
docker image prune -f 2>/dev/null || true

# Build new image
echo "🔨 Building Docker image..."
if ! docker-compose build --no-cache; then
    echo "❌ Docker build failed!"
    exit 1
fi

# Start new container
echo "▶️  Starting container..."
if ! docker-compose up -d; then
    echo "❌ Failed to start container!"
    exit 1
fi

# Wait for container to be healthy
echo "⏳ Waiting for container to be healthy..."
sleep 5

# Check container status
if docker-compose ps | grep -q "Up"; then
    echo "✅ Container is running!"
    
    # Test health endpoint
    if command -v curl &> /dev/null; then
        sleep 2
        if curl -f http://localhost:8080/health &> /dev/null; then
            echo "✅ Health check passed!"
        else
            echo "⚠️  Warning: Health check failed, but container is running"
        fi
    fi
else
    echo "❌ Container failed to start!"
    echo "Logs:"
    docker-compose logs --tail=50
    exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Deployment completed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ENDSSH

# Cleanup local deployment package
rm deploy.tar.gz

log_success "🎉 Deployment completed successfully!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Deployment Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Built project locally"
echo "✓ Transferred files to VPS"
echo "✓ Deployed Docker container"
echo "✓ Container is running and healthy"
echo ""
echo "🌐 Site URL: http://${REMOTE_HOST}:8080"
echo "🔍 Health Check: http://${REMOTE_HOST}:8080/health"
echo ""
echo "📝 Useful commands:"
echo "  View logs:    ssh ${REMOTE_USER}@${REMOTE_HOST} 'cd ${REMOTE_PATH} && docker-compose logs -f'"
echo "  Restart:      ssh ${REMOTE_USER}@${REMOTE_HOST} 'cd ${REMOTE_PATH} && docker-compose restart'"
echo "  Stop:         ssh ${REMOTE_USER}@${REMOTE_HOST} 'cd ${REMOTE_PATH} && docker-compose down'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
