#!/bin/bash

# G-Labs Website - View Logs Script
# Quick script to view container logs

REMOTE_USER="${DEPLOY_USER:-root}"
REMOTE_HOST="${DEPLOY_HOST:-your-vps-ip}"
REMOTE_PATH="${DEPLOY_PATH:-/opt/glabs-website}"

if [ "$REMOTE_HOST" = "your-vps-ip" ]; then
    echo "Error: Please set DEPLOY_HOST environment variable"
    echo "Usage: export DEPLOY_HOST=your.vps.ip && ./logs.sh"
    exit 1
fi

echo "📋 Viewing logs for G-Labs Website on $REMOTE_HOST..."
echo "Press Ctrl+C to exit"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ssh -t ${REMOTE_USER}@${REMOTE_HOST} "cd ${REMOTE_PATH} && docker-compose logs -f --tail=100"
