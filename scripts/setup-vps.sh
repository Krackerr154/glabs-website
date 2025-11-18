#!/bin/bash

# G-Labs VPS Initial Setup Script
# Run this ONCE on your VPS to prepare for deployments
# Usage: bash setup-vps.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 G-Labs VPS Initial Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    log_warn "Running as root. Creating non-root user is recommended."
fi

# Update system
log_info "📦 Updating system packages..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update -qq
    sudo apt-get upgrade -y -qq
    log_success "System updated (Debian/Ubuntu)"
elif command -v yum &> /dev/null; then
    sudo yum update -y -q
    log_success "System updated (CentOS/RHEL)"
else
    log_warn "Unknown package manager. Skipping system update."
fi

# Install Docker if not present
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    log_success "Docker already installed: $DOCKER_VERSION"
else
    log_info "🐳 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    
    # Add current user to docker group
    sudo usermod -aG docker $USER || true
    
    log_success "Docker installed successfully"
    log_warn "You may need to log out and back in for docker group changes to take effect"
fi

# Install Docker Compose if not present
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    log_success "Docker Compose already installed: $COMPOSE_VERSION"
else
    log_info "🐙 Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    log_success "Docker Compose installed successfully"
fi

# Install useful utilities
log_info "🛠️  Installing utilities (curl, wget, git, htop)..."
if command -v apt-get &> /dev/null; then
    sudo apt-get install -y -qq curl wget git htop net-tools
elif command -v yum &> /dev/null; then
    sudo yum install -y -q curl wget git htop net-tools
fi
log_success "Utilities installed"

# Create project directory
log_info "📁 Creating project directory..."
sudo mkdir -p /opt/glabs-website
sudo chown $USER:$USER /opt/glabs-website
log_success "Project directory created: /opt/glabs-website"

# Create environment file template
log_info "📝 Creating environment file template..."
cat > /opt/glabs-website/.env << 'EOF'
# G-Labs Website Environment Configuration
# Edit these values for your production environment

NODE_ENV=production

# n8n Webhook URL for contact form
# Get this from your n8n instance after creating the webhook workflow
PUBLIC_N8N_CONTACT_WEBHOOK=https://your-n8n-instance.com/webhook/contact

# Site URL (optional, for metadata)
PUBLIC_SITE_URL=https://your-domain.com
EOF

log_success "Environment file template created at /opt/glabs-website/.env"

# Configure firewall (if ufw is available)
if command -v ufw &> /dev/null; then
    log_info "🔥 Configuring firewall..."
    
    # Check if ufw is active
    if sudo ufw status | grep -q "Status: active"; then
        log_info "Firewall is active, adding rules..."
        
        # Allow SSH (if not already allowed)
        sudo ufw allow 22/tcp comment 'SSH' 2>/dev/null || true
        
        # Allow HTTP and HTTPS for web server
        sudo ufw allow 80/tcp comment 'HTTP' 2>/dev/null || true
        sudo ufw allow 443/tcp comment 'HTTPS' 2>/dev/null || true
        
        # Allow Docker container port
        sudo ufw allow 8080/tcp comment 'G-Labs Website' 2>/dev/null || true
        
        log_success "Firewall rules added"
    else
        log_warn "Firewall (ufw) is installed but not active"
        log_info "To enable: sudo ufw enable"
    fi
else
    log_warn "ufw not found. Please configure firewall manually."
fi

# Create deployment log directory
log_info "📋 Creating log directory..."
sudo mkdir -p /var/log/glabs-website
sudo chown $USER:$USER /var/log/glabs-website
log_success "Log directory created"

# Test Docker installation
log_info "🧪 Testing Docker installation..."
if docker run --rm hello-world > /dev/null 2>&1; then
    log_success "Docker is working correctly"
else
    log_error "Docker test failed. You may need to:"
    echo "  1. Log out and log back in"
    echo "  2. Run: newgrp docker"
    echo "  3. Reboot the server"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ VPS Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Next Steps:"
echo ""
echo "1. Edit the environment file with your settings:"
echo "   nano /opt/glabs-website/.env"
echo ""
echo "2. Set up your n8n webhook:"
echo "   - Create a webhook workflow in n8n"
echo "   - Copy the webhook URL"
echo "   - Add it to the .env file"
echo ""
echo "3. Deploy from your local machine:"
echo "   export DEPLOY_HOST=$(hostname -I | awk '{print $1}')"
echo "   export DEPLOY_USER=$USER"
echo "   ./deploy.sh"
echo ""
echo "4. (Optional) Set up reverse proxy for HTTPS:"
echo "   - Install Nginx on public VPS"
echo "   - Configure SSL with Let's Encrypt"
echo "   - Proxy to this server via WireGuard"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔍 System Information:"
echo "  Docker Version: $(docker --version | cut -d' ' -f3)"
echo "  Docker Compose: $(docker-compose --version | cut -d' ' -f3)"
echo "  Project Path: /opt/glabs-website"
echo "  Server IP: $(hostname -I | awk '{print $1}')"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
