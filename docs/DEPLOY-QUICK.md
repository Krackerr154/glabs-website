# Quick Deployment Guide

## Prerequisites

Before deploying, ensure you have:
- SSH access to your VPS
- SSH key-based authentication configured
- Node.js installed locally (for building)

---

## 🚀 Quick Start (3 Steps)

### Step 1: Setup VPS (Run Once)

On your VPS, run:
```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/main-page/main/setup-vps.sh | bash
```

Or manually:
```bash
# Copy setup-vps.sh to your VPS
scp setup-vps.sh user@your-vps-ip:/tmp/

# SSH to VPS and run
ssh user@your-vps-ip
bash /tmp/setup-vps.sh
```

### Step 2: Configure Environment

Edit the environment file on VPS:
```bash
ssh user@your-vps-ip
nano /opt/glabs-website/.env
```

Update these values:
```env
PUBLIC_N8N_CONTACT_WEBHOOK=https://your-n8n-instance.com/webhook/contact
PUBLIC_SITE_URL=https://your-domain.com
```

### Step 3: Deploy

From your local machine:
```bash
# Set environment variables
export DEPLOY_HOST=your.vps.ip
export DEPLOY_USER=your-username

# Make script executable (first time only)
chmod +x deploy.sh

# Deploy!
./deploy.sh
```

**Done!** Your site is now live at `http://your-vps-ip:8080`

---

## 📝 Detailed Instructions

### Environment Variables

Create a `.env` file in your project root (copy from `.env.example`):

```bash
cp .env.example .env
```

Edit and add your production values:
```env
PUBLIC_N8N_CONTACT_WEBHOOK=https://your-n8n-instance.com/webhook/contact
PUBLIC_SITE_URL=https://glabs.id
```

### First-Time Setup

1. **Install Node.js dependencies locally:**
   ```bash
   npm install
   ```

2. **Test build locally:**
   ```bash
   npm run build
   ```

3. **Configure SSH access:**
   ```bash
   # Generate SSH key if you don't have one
   ssh-keygen -t ed25519 -C "your_email@example.com"
   
   # Copy to VPS
   ssh-copy-id user@your-vps-ip
   
   # Test connection
   ssh user@your-vps-ip
   ```

4. **Run VPS setup:**
   ```bash
   # Transfer setup script
   scp setup-vps.sh user@your-vps-ip:/tmp/
   
   # Execute on VPS
   ssh user@your-vps-ip 'bash /tmp/setup-vps.sh'
   ```

5. **Configure environment on VPS:**
   ```bash
   ssh user@your-vps-ip
   nano /opt/glabs-website/.env
   # Add your n8n webhook URL and other settings
   ```

### Deployment

```bash
# Set deployment target
export DEPLOY_HOST=192.168.1.100  # Your VPS IP
export DEPLOY_USER=glabs          # Your SSH user

# Deploy
./deploy.sh
```

The script will:
1. ✅ Build the project locally
2. ✅ Create deployment package
3. ✅ Transfer to VPS
4. ✅ Build Docker image
5. ✅ Start container
6. ✅ Run health checks

---

## 🛠️ Management Commands

### Check Status

```bash
export DEPLOY_HOST=your-vps-ip
./check-status.sh
```

### View Logs

```bash
ssh user@your-vps-ip
cd /opt/glabs-website
docker-compose logs -f
```

### Restart Container

```bash
ssh user@your-vps-ip
cd /opt/glabs-website
docker-compose restart
```

### Stop Container

```bash
ssh user@your-vps-ip
cd /opt/glabs-website
docker-compose down
```

### Update Deployment

Just run deploy.sh again:
```bash
./deploy.sh
```

---

## 🔒 Setting Up HTTPS with Reverse Proxy

If you have a public VPS with domain name:

### On Public VPS (with domain)

1. **Install Nginx:**
   ```bash
   sudo apt update
   sudo apt install nginx certbot python3-certbot-nginx
   ```

2. **Create Nginx config:**
   ```bash
   sudo nano /etc/nginx/sites-available/glabs
   ```

   Add:
   ```nginx
   server {
       listen 80;
       server_name your-domain.com www.your-domain.com;
       
       location / {
           proxy_pass http://10.8.0.2:8080;  # WireGuard IP of NAT VPS
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

3. **Enable site and get SSL:**
   ```bash
   sudo ln -s /etc/nginx/sites-available/glabs /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl reload nginx
   sudo certbot --nginx -d your-domain.com -d www.your-domain.com
   ```

---

## 🐛 Troubleshooting

### Build fails locally

```bash
# Clear cache and rebuild
rm -rf node_modules dist .astro
npm install
npm run build
```

### Cannot connect to VPS

```bash
# Test SSH connection
ssh -v user@your-vps-ip

# Check firewall
ssh user@your-vps-ip 'sudo ufw status'
```

### Docker build fails

```bash
# SSH to VPS and check Docker
ssh user@your-vps-ip
docker --version
docker-compose --version

# Check logs
cd /opt/glabs-website
docker-compose logs
```

### Container not healthy

```bash
# Check container logs
ssh user@your-vps-ip
cd /opt/glabs-website
docker-compose logs --tail=100

# Restart container
docker-compose restart

# Full rebuild
docker-compose down
docker-compose up -d --build --force-recreate
```

### Port 8080 already in use

```bash
# Find what's using the port
ssh user@your-vps-ip 'sudo lsof -i :8080'

# Change port in docker-compose.yml
nano docker-compose.yml
# Change "8080:80" to "8081:80" or another port
```

---

## 📊 Monitoring

### Check container health

```bash
ssh user@your-vps-ip 'docker inspect glabs-website | grep -A 10 Health'
```

### Monitor resource usage

```bash
ssh user@your-vps-ip 'docker stats glabs-website'
```

### Check disk space

```bash
ssh user@your-vps-ip 'df -h'
```

### Clean up old Docker images

```bash
ssh user@your-vps-ip 'docker system prune -a'
```

---

## 🔄 CI/CD with GitHub Actions

For automated deployments on git push, see `.github/workflows/deploy.yml`

Set these secrets in GitHub:
- `VPS_SSH_KEY` - Your private SSH key
- `VPS_HOST` - VPS IP address
- `VPS_USER` - SSH username
- `N8N_CONTACT_WEBHOOK` - n8n webhook URL

Then every push to `main` branch will auto-deploy!

---

## 📞 Support

- Issues: Open GitHub issue
- Email: contact@glabs.id
- Documentation: See DEPLOYMENT.md for full details

---

## ✅ Checklist

Before deploying, ensure:

- [ ] VPS has Docker and Docker Compose installed
- [ ] SSH key-based auth is configured
- [ ] `.env` file is configured with n8n webhook
- [ ] Firewall allows port 8080 (or your chosen port)
- [ ] Project builds successfully locally (`npm run build`)
- [ ] You have DEPLOY_HOST and DEPLOY_USER env vars set

Then just run: `./deploy.sh` 🚀
