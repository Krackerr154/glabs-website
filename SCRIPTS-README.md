# 🚀 Deployment Scripts

Quick reference for all deployment scripts.

## 📜 Available Scripts

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `setup-vps.sh` | Initial VPS setup | Run **once** on new VPS |
| `deploy.sh` | Deploy website | Every time you want to deploy |
| `check-status.sh` | Check deployment status | Anytime to verify status |
| `logs.sh` | View container logs | For debugging/monitoring |
| `restart.sh` | Restart container | When container needs restart |

---

## 🎯 Quick Start

### 1️⃣ First Time Setup (On VPS)

```bash
# Copy setup script to VPS
scp setup-vps.sh user@your-vps-ip:/tmp/

# SSH and run setup
ssh user@your-vps-ip
bash /tmp/setup-vps.sh

# Configure environment
nano /opt/glabs-website/.env
# Add your n8n webhook URL
```

### 2️⃣ Deploy from Local Machine

```bash
# Make scripts executable (first time only)
chmod +x *.sh

# Set environment
export DEPLOY_HOST=your.vps.ip
export DEPLOY_USER=your-username

# Deploy!
./deploy.sh
```

### 3️⃣ Verify Deployment

```bash
./check-status.sh
```

---

## 📋 Script Details

### `setup-vps.sh`

**Purpose:** Prepare VPS for first deployment

**What it does:**
- ✅ Updates system packages
- ✅ Installs Docker and Docker Compose
- ✅ Creates project directory (`/opt/glabs-website`)
- ✅ Sets up environment file template
- ✅ Configures firewall (if ufw available)
- ✅ Creates log directory

**Usage:**
```bash
# On VPS
bash setup-vps.sh

# Or remotely
ssh user@vps 'bash -s' < setup-vps.sh
```

**After running:**
1. Edit `/opt/glabs-website/.env` with your values
2. Ready for deployment!

---

### `deploy.sh`

**Purpose:** Build and deploy website to VPS

**What it does:**
- ✅ Builds project locally (`npm run build`)
- ✅ Creates deployment package
- ✅ Transfers files to VPS via SSH
- ✅ Builds Docker image on VPS
- ✅ Stops old container
- ✅ Starts new container
- ✅ Runs health checks

**Prerequisites:**
- Node.js installed locally
- SSH access to VPS
- VPS setup completed (`setup-vps.sh`)

**Usage:**
```bash
# Set environment variables
export DEPLOY_HOST=192.168.1.100
export DEPLOY_USER=myuser

# Deploy
./deploy.sh
```

**Environment Variables:**
- `DEPLOY_HOST` - VPS IP address (required)
- `DEPLOY_USER` - SSH username (default: root)
- `DEPLOY_PATH` - Remote path (default: /opt/glabs-website)

**Output:**
```
🚀 Starting G-Labs Website Deployment...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Building the project...
✅ Build completed successfully
📤 Transferring files to VPS...
🚀 Deploying on VPS...
✅ Deployment completed successfully!
```

---

### `check-status.sh`

**Purpose:** Check deployment status and health

**What it shows:**
- Container status (running/stopped)
- Resource usage (CPU/Memory)
- Health check status
- Recent logs (last 20 lines)

**Usage:**
```bash
export DEPLOY_HOST=your.vps.ip
./check-status.sh
```

**Sample Output:**
```
📊 Container Status:
Name             State    Ports
glabs-website    Up       0.0.0.0:8080->80/tcp

💾 Resource Usage:
CPU: 2.5%    MEM: 45MB / 2GB

🏥 Health Status:
✅ Health check: PASSED
```

---

### `logs.sh`

**Purpose:** View real-time container logs

**What it does:**
- Connects to VPS
- Shows last 100 log lines
- Follows logs in real-time

**Usage:**
```bash
export DEPLOY_HOST=your.vps.ip
./logs.sh
```

**To exit:** Press `Ctrl+C`

**Useful for:**
- Debugging deployment issues
- Monitoring requests
- Checking for errors

---

### `restart.sh`

**Purpose:** Quickly restart the container

**What it does:**
- Connects to VPS
- Restarts Docker container
- Shows container status

**Usage:**
```bash
export DEPLOY_HOST=your.vps.ip
./restart.sh
```

**When to use:**
- After changing environment variables
- When container is unresponsive
- After VPS reboot

---

## 🔧 Configuration

### Environment Variables

Set these before running scripts:

```bash
# Required
export DEPLOY_HOST=192.168.1.100    # Your VPS IP

# Optional (have defaults)
export DEPLOY_USER=myuser            # SSH user (default: root)
export DEPLOY_PATH=/opt/glabs-website # Remote path
```

### Persistent Configuration

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# G-Labs Deployment Config
export DEPLOY_HOST=192.168.1.100
export DEPLOY_USER=glabs
export DEPLOY_PATH=/opt/glabs-website
```

Then reload:
```bash
source ~/.bashrc
```

---

## 🎬 Complete Workflow Example

### Initial Setup (First Time)

```bash
# 1. Setup VPS
scp setup-vps.sh user@192.168.1.100:/tmp/
ssh user@192.168.1.100 'bash /tmp/setup-vps.sh'

# 2. Configure environment on VPS
ssh user@192.168.1.100
nano /opt/glabs-website/.env
# Add: PUBLIC_N8N_CONTACT_WEBHOOK=https://...
exit

# 3. Make scripts executable locally
chmod +x *.sh

# 4. Set deployment config
export DEPLOY_HOST=192.168.1.100
export DEPLOY_USER=user
```

### Regular Development Workflow

```bash
# 1. Make changes to code
git pull  # or make changes

# 2. Test locally
npm run dev

# 3. Deploy to VPS
./deploy.sh

# 4. Check status
./check-status.sh

# 5. View logs if needed
./logs.sh
```

### Maintenance Workflow

```bash
# Check site status
./check-status.sh

# View logs
./logs.sh

# Restart if needed
./restart.sh

# Redeploy after fixes
./deploy.sh
```

---

## 🐛 Troubleshooting

### "Cannot connect to VPS"

```bash
# Test SSH connection
ssh user@your-vps-ip

# Check if host is reachable
ping your-vps-ip

# Verify SSH key
ssh -v user@your-vps-ip
```

### "Build failed"

```bash
# Clear caches
rm -rf node_modules dist .astro
npm install
npm run build

# Check Node.js version
node --version  # Should be 20+
```

### "Container won't start"

```bash
# SSH to VPS and check
ssh user@vps
cd /opt/glabs-website

# View detailed logs
docker-compose logs

# Check if port is in use
sudo lsof -i :8080

# Force rebuild
docker-compose down
docker-compose up -d --build --force-recreate
```

### "Permission denied"

```bash
# Make scripts executable
chmod +x *.sh

# Check SSH key permissions
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

---

## 📚 Additional Resources

- **Full Deployment Guide**: See `DEPLOY-QUICK.md`
- **Detailed Documentation**: See `DEPLOYMENT.md`
- **Project README**: See `README.md`

---

## 🔒 Security Notes

- ✅ Always use SSH key-based authentication
- ✅ Never commit `.env` files to Git
- ✅ Keep VPS system updated
- ✅ Use firewall (ufw)
- ✅ Consider using fail2ban for SSH protection

---

## 💡 Pro Tips

1. **Save time with aliases:**
   ```bash
   alias deploy="export DEPLOY_HOST=192.168.1.100 && ./deploy.sh"
   alias status="export DEPLOY_HOST=192.168.1.100 && ./check-status.sh"
   alias logs="export DEPLOY_HOST=192.168.1.100 && ./logs.sh"
   ```

2. **Quick deploy command:**
   ```bash
   # One-liner
   DEPLOY_HOST=192.168.1.100 DEPLOY_USER=user ./deploy.sh
   ```

3. **Monitor in real-time:**
   ```bash
   watch -n 5 './check-status.sh'
   ```

4. **Quick SSH to project:**
   ```bash
   alias glabs-ssh="ssh user@192.168.1.100 'cd /opt/glabs-website && bash'"
   ```

---

**Last Updated:** November 13, 2024  
**Version:** 1.0.0
