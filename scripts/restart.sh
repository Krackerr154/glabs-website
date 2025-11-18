#!/bin/bash

# G-Labs Website - Quick Restart Script

REMOTE_USER="${DEPLOY_USER:-root}"
REMOTE_HOST="${DEPLOY_HOST:-your-vps-ip}"
REMOTE_PATH="${DEPLOY_PATH:-/opt/glabs-website}"

if [ "$REMOTE_HOST" = "your-vps-ip" ]; then
    echo "Error: Please set DEPLOY_HOST environment variable"
    exit 1
fi

echo "🔄 Restarting G-Labs Website on $REMOTE_HOST..."

ssh ${REMOTE_USER}@${REMOTE_HOST} << 'ENDSSH'
cd /opt/glabs-website
echo "Restarting container..."
docker-compose restart
sleep 3
echo ""
echo "Status:"
docker-compose ps
ENDSSH

echo "✅ Restart complete!"
