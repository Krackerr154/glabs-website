#!/bin/bash

# Quick deployment status check script
# Run this on your local machine to check VPS deployment status

REMOTE_USER="${DEPLOY_USER:-root}"
REMOTE_HOST="${DEPLOY_HOST:-your-vps-ip}"
REMOTE_PATH="${DEPLOY_PATH:-/opt/glabs-website}"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ "$REMOTE_HOST" = "your-vps-ip" ]; then
    echo -e "${RED}Error:${NC} Please set DEPLOY_HOST environment variable"
    echo "Usage: export DEPLOY_HOST=your.vps.ip && ./check-status.sh"
    exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Checking G-Labs Website Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ssh ${REMOTE_USER}@${REMOTE_HOST} << 'ENDSSH'
cd /opt/glabs-website 2>/dev/null || { echo "❌ Project directory not found"; exit 1; }

echo "📊 Container Status:"
docker-compose ps

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💾 Resource Usage:"
docker stats glabs-website --no-stream

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🏥 Health Status:"
if curl -sf http://localhost:8080/health > /dev/null 2>&1; then
    echo "✅ Health check: PASSED"
else
    echo "❌ Health check: FAILED"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Recent Logs (last 20 lines):"
docker-compose logs --tail=20 web

ENDSSH

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Status check complete"
echo "🌐 Site URL: http://${REMOTE_HOST}:8080"
