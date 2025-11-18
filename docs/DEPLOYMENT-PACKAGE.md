# 🚀 Deployment Package - Quick Reference

Everything you need to deploy G-Labs Website to your VPS.

---

## 📦 What's Included

### Deployment Scripts
- ✅ `deploy.sh` - Main deployment script (Linux/Mac)
- ✅ `deploy.ps1` - PowerShell deployment script (Windows)
- ✅ `setup-vps.sh` - Initial VPS setup script
- ✅ `check-status.sh` - Check deployment status
- ✅ `logs.sh` - View container logs
- ✅ `restart.sh` - Restart container

### Docker Configuration
- ✅ `Dockerfile` - Multi-stage Docker build
- ✅ `docker-compose.yml` - Container orchestration
- ✅ `nginx.conf` - Production web server config

### Documentation
- ✅ `DEPLOY-QUICK.md` - Quick deployment guide (START HERE!)
- ✅ `SCRIPTS-README.md` - Detailed scripts documentation
- ✅ `DEPLOYMENT-CHECKLIST.md` - Pre-deployment checklist
- ✅ `DEPLOYMENT.md` - Full deployment documentation
- ✅ `README.md` - Project overview

---

## ⚡ Quick Start (5 Minutes)

### 1. Setup VPS (One-Time)
```bash
# Transfer setup script
scp setup-vps.sh user@your-vps-ip:/tmp/

# Run setup
ssh user@your-vps-ip 'bash /tmp/setup-vps.sh'

# Configure environment
ssh user@your-vps-ip 'nano /opt/glabs-website/.env'
# Add your n8n webhook URL
```

### 2. Deploy from Local Machine

**Linux/Mac:**
```bash
chmod +x *.sh
export DEPLOY_HOST=your.vps.ip
export DEPLOY_USER=your-username
./deploy.sh
```

**Windows PowerShell:**
```powershell
$env:DEPLOY_HOST='your.vps.ip'
$env:DEPLOY_USER='your-username'
.\deploy.ps1
```

### 3. Verify
```bash
# Check status
./check-status.sh

# View logs
./logs.sh

# Visit site
# http://your-vps-ip:8080
```

---

## 📚 Documentation Guide

| Document | When to Read |
|----------|--------------|
| **DEPLOY-QUICK.md** | 👉 **START HERE** - Quick deployment guide |
| **SCRIPTS-README.md** | Learn about all deployment scripts |
| **DEPLOYMENT-CHECKLIST.md** | Before deploying to production |
| **DEPLOYMENT.md** | Detailed deployment options |
| **README.md** | Project overview and features |

---

## 🎯 Common Tasks

### Deploy/Update Site
```bash
./deploy.sh
```

### Check if Site is Running
```bash
./check-status.sh
```

### View Real-Time Logs
```bash
./logs.sh
```

### Restart Container
```bash
./restart.sh
```

### SSH to Project Directory
```bash
ssh user@vps 'cd /opt/glabs-website && bash'
```

---

## 🔧 Environment Variables

Set these before deploying:

```bash
# Required
export DEPLOY_HOST=192.168.1.100  # Your VPS IP

# Optional (have defaults)
export DEPLOY_USER=myuser          # SSH username (default: root)
export DEPLOY_PATH=/opt/glabs-website  # Remote path
```

Or add to your shell profile (`~/.bashrc` or `~/.zshrc`):
```bash
# G-Labs Deployment
export DEPLOY_HOST=192.168.1.100
export DEPLOY_USER=glabs
```

---

## 📁 VPS Directory Structure

After deployment, your VPS will have:
```
/opt/glabs-website/
├── dist/                    # Built website files
├── Dockerfile               # Docker build instructions
├── docker-compose.yml       # Container configuration
├── nginx.conf              # Web server config
├── package.json            # Dependencies
├── .env                    # Environment variables
└── (Docker images/containers)
```

---

## 🌐 Access URLs

After deployment:

- **Site**: `http://your-vps-ip:8080`
- **Health Check**: `http://your-vps-ip:8080/health`

With reverse proxy:
- **Site**: `https://your-domain.com`
- **Health Check**: `https://your-domain.com/health`

---

## 🆘 Troubleshooting

### "Cannot connect to VPS"
```bash
# Test connection
ssh user@your-vps-ip

# Check if host is up
ping your-vps-ip
```

### "Build failed"
```bash
# Clear and rebuild
rm -rf node_modules dist .astro
npm install
npm run build
```

### "Container won't start"
```bash
# SSH to VPS
ssh user@vps
cd /opt/glabs-website

# View logs
docker-compose logs

# Force rebuild
docker-compose down
docker-compose up -d --build --force-recreate
```

### "Port 8080 in use"
```bash
# Find what's using it
ssh user@vps 'sudo lsof -i :8080'

# Or change port in docker-compose.yml
```

---

## 🔒 Security Checklist

Before going to production:

- ✅ SSH key-based auth (no passwords)
- ✅ Firewall configured (`ufw`)
- ✅ `.env` file not in Git
- ✅ Strong passwords everywhere
- ✅ SSL certificate (for HTTPS)
- ✅ Security headers in nginx
- ✅ Regular system updates

---

## 📊 Monitoring Commands

```bash
# Container status
docker-compose ps

# Resource usage
docker stats glabs-website

# Recent logs
docker-compose logs --tail=50

# Disk space
df -h

# System resources
htop
```

---

## 🔄 Update Workflow

```bash
# 1. Pull latest code (or make changes)
git pull

# 2. Test locally
npm run dev

# 3. Deploy to VPS
./deploy.sh

# 4. Verify
./check-status.sh
```

---

## 📞 Getting Help

1. **Check documentation**: Start with `DEPLOY-QUICK.md`
2. **Review checklist**: Use `DEPLOYMENT-CHECKLIST.md`
3. **View logs**: Run `./logs.sh` to see errors
4. **Test locally**: Ensure `npm run build` works first

---

## 💡 Pro Tips

1. **Save deployment config**:
   ```bash
   # Add to ~/.bashrc
   alias glabs-deploy="export DEPLOY_HOST=192.168.1.100 && ./deploy.sh"
   ```

2. **Quick status check**:
   ```bash
   alias glabs-status="export DEPLOY_HOST=192.168.1.100 && ./check-status.sh"
   ```

3. **Quick SSH**:
   ```bash
   alias glabs-ssh="ssh user@192.168.1.100 'cd /opt/glabs-website && bash'"
   ```

4. **Monitor continuously**:
   ```bash
   watch -n 5 './check-status.sh'
   ```

---

## 📈 What Happens During Deployment

1. ✅ Builds project locally (`npm run build`)
2. ✅ Creates deployment package (tar.gz)
3. ✅ Transfers files to VPS via SSH
4. ✅ Extracts files on VPS
5. ✅ Stops existing container
6. ✅ Builds new Docker image
7. ✅ Starts new container
8. ✅ Runs health checks
9. ✅ Reports success/failure

**Total time**: ~2-3 minutes

---

## ✅ Success Indicators

After deployment, you should see:

```
✅ Build completed successfully
✅ Files transferred successfully
✅ Container is running!
✅ Health check passed!
🎉 Deployment completed successfully!
```

Then verify:
- Site loads at `http://your-vps-ip:8080`
- All pages accessible
- Contact form works
- No errors in logs

---

## 🎓 Learning Path

1. **First deployment**: Follow `DEPLOY-QUICK.md` step-by-step
2. **Understand scripts**: Read `SCRIPTS-README.md`
3. **Advanced setup**: Review `DEPLOYMENT.md`
4. **Production ready**: Use `DEPLOYMENT-CHECKLIST.md`
5. **Automation**: Set up GitHub Actions (see `.github/workflows/`)

---

## 🚀 You're Ready!

Everything is prepared for easy deployment. Just:

1. Run `setup-vps.sh` on your VPS (once)
2. Configure `.env` file on VPS
3. Run `deploy.sh` from your local machine

**That's it!** Your site will be live in minutes.

---

**Questions?** Check `DEPLOY-QUICK.md` for detailed instructions.

**Last Updated**: November 13, 2024  
**Version**: 1.0.0
