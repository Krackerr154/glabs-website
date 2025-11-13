# 🚀 Pre-Deployment Checklist

Use this checklist before deploying to production.

## ✅ Local Development

- [ ] All dependencies installed (`npm install`)
- [ ] Project builds successfully (`npm run build`)
- [ ] Dev server runs without errors (`npm run dev`)
- [ ] All pages load correctly
- [ ] No console errors in browser
- [ ] Content validates (check terminal for schema errors)

## ✅ Configuration

- [ ] `.env` file created and configured
- [ ] n8n webhook URL added to `.env`
- [ ] Site URL configured (if using custom domain)
- [ ] All environment variables correct for production

## ✅ Content

- [ ] At least 1 project added with proper frontmatter
- [ ] At least 1 note added with proper frontmatter
- [ ] About page customized with your information
- [ ] Research page updated with your research interests
- [ ] Contact form tested locally
- [ ] All images optimized and in `/public` folder
- [ ] No placeholder content remaining

## ✅ VPS Preparation

- [ ] VPS is accessible via SSH
- [ ] SSH key-based authentication set up
- [ ] Firewall configured (ports 22, 80, 443, 8080 open)
- [ ] VPS has at least 1GB RAM
- [ ] VPS has at least 10GB free disk space
- [ ] VPS OS is up to date

## ✅ Scripts Ready

- [ ] All `.sh` scripts made executable (`chmod +x *.sh`)
- [ ] `DEPLOY_HOST` environment variable set
- [ ] `DEPLOY_USER` environment variable set
- [ ] SSH connection to VPS tested

## ✅ Initial VPS Setup

- [ ] `setup-vps.sh` executed on VPS
- [ ] Docker installed on VPS
- [ ] Docker Compose installed on VPS
- [ ] Project directory created (`/opt/glabs-website`)
- [ ] Environment file configured on VPS

## ✅ Deployment Test

- [ ] First deployment completed successfully
- [ ] Container is running (`docker-compose ps`)
- [ ] Health check passes (`http://vps-ip:8080/health`)
- [ ] Site accessible at `http://vps-ip:8080`
- [ ] All pages load correctly on VPS
- [ ] Contact form works (test submission)

## ✅ Reverse Proxy (Optional but Recommended)

- [ ] Public VPS has Nginx installed
- [ ] WireGuard tunnel active between VPSs
- [ ] Nginx configured to proxy to NAT VPS
- [ ] SSL certificate obtained (Let's Encrypt)
- [ ] HTTPS working correctly
- [ ] HTTP redirects to HTTPS
- [ ] Domain DNS configured correctly

## ✅ Security

- [ ] SSH password authentication disabled
- [ ] Firewall active and configured
- [ ] Only necessary ports open
- [ ] `.env` file not committed to Git
- [ ] Strong passwords used everywhere
- [ ] fail2ban configured (optional)

## ✅ Monitoring

- [ ] Container logs accessible
- [ ] Health check endpoint working
- [ ] Resource usage checked (`docker stats`)
- [ ] Disk space sufficient
- [ ] Consider uptime monitoring (optional)

## ✅ Documentation

- [ ] Team knows how to deploy
- [ ] Deployment process documented
- [ ] Emergency contacts listed
- [ ] Backup strategy in place

## ✅ Post-Deployment

- [ ] Site loads fast (< 3 seconds)
- [ ] Mobile view tested
- [ ] Desktop view tested
- [ ] All links working
- [ ] Forms submitting correctly
- [ ] SEO meta tags present
- [ ] Lighthouse score > 90

## 🎯 Ready to Deploy!

If all items are checked, you're ready to deploy:

```bash
# Linux/Mac
export DEPLOY_HOST=your.vps.ip
export DEPLOY_USER=your-username
./deploy.sh

# Windows PowerShell
$env:DEPLOY_HOST='your.vps.ip'
$env:DEPLOY_USER='your-username'
.\deploy.ps1
```

---

## 🆘 Quick Troubleshooting

### Build Fails Locally
```bash
rm -rf node_modules dist .astro
npm install
npm run build
```

### Cannot SSH to VPS
```bash
ssh -v user@vps-ip  # verbose mode to see what's wrong
```

### Container Won't Start
```bash
ssh user@vps-ip
cd /opt/glabs-website
docker-compose logs
```

### Site Not Accessible
- Check firewall: `sudo ufw status`
- Check container: `docker-compose ps`
- Check health: `curl http://localhost:8080/health`

---

## 📝 After Deployment

1. **Test everything**:
   - Browse all pages
   - Test contact form
   - Check mobile view
   - Verify SSL (if using HTTPS)

2. **Monitor for 24 hours**:
   ```bash
   ./check-status.sh
   ./logs.sh
   ```

3. **Set up regular backups**:
   - Content directory
   - Environment files
   - Database (if any)

4. **Plan for updates**:
   - Schedule maintenance windows
   - Test updates on staging first
   - Keep VPS OS updated

---

**Last Updated**: November 13, 2024  
**Version**: 1.0.0
