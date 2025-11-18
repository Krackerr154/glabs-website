# Deployment Scripts

This directory contains scripts for deploying and managing the G-Labs website.

## 📜 Available Scripts

### Deployment Scripts

#### `deploy.sh` (Linux/Mac)
Deploy the website to a remote server.

```bash
export DEPLOY_HOST=your.server.ip
export DEPLOY_USER=username
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

#### `deploy.ps1` (Windows PowerShell)
Deploy the website from Windows.

```powershell
$env:DEPLOY_HOST='your.server.ip'
$env:DEPLOY_USER='username'
.\scripts\deploy.ps1
```

#### `deploy.bat` (Windows Command Prompt)
Deploy the website from Windows CMD.

```cmd
set DEPLOY_HOST=your.server.ip
set DEPLOY_USER=username
scripts\deploy.bat
```

### Server Management Scripts

#### `check-status.sh`
Check the status of deployed containers.

```bash
./scripts/check-status.sh
```

#### `logs.sh`
View container logs.

```bash
./scripts/logs.sh
```

#### `restart.sh`
Restart the website containers.

```bash
./scripts/restart.sh
```

### Setup Scripts

#### `setup-vps.sh`
Initial VPS setup (one-time).

```bash
scp scripts/setup-vps.sh user@server:/tmp/
ssh user@server 'bash /tmp/setup-vps.sh'
```

#### `setup-admin.sh` / `setup-admin.ps1`
Set up admin user credentials.

```bash
# Linux/Mac
./scripts/setup-admin.sh

# Windows
.\scripts\setup-admin.ps1
```

## 🔧 Environment Variables

The deployment scripts use the following environment variables:

- `DEPLOY_HOST` - Target server IP or hostname
- `DEPLOY_USER` - SSH username for server access
- `DEPLOY_PATH` - Remote deployment path (default: `/home/ubuntu/webcontent/main-page`)

## 📖 Usage Examples

### First-Time Deployment

```bash
# 1. Set up VPS
scp scripts/setup-vps.sh ubuntu@g-labs.my.id:/tmp/
ssh ubuntu@g-labs.my.id 'bash /tmp/setup-vps.sh'

# 2. Deploy website
export DEPLOY_HOST=g-labs.my.id
export DEPLOY_USER=ubuntu
./scripts/deploy.sh
```

### Update Deployment

```bash
# Pull latest changes and restart
ssh ubuntu@g-labs.my.id 'cd /home/ubuntu/webcontent/main-page && git pull && docker-compose up -d --build'
```

### Check Status

```bash
ssh ubuntu@g-labs.my.id 'docker ps'
ssh ubuntu@g-labs.my.id 'docker logs glabs-website'
```

## 🐛 Troubleshooting

### Permission Denied
```bash
chmod +x scripts/*.sh
```

### SSH Connection Issues
```bash
# Test SSH connection
ssh -v ubuntu@g-labs.my.id

# Check SSH key
ssh-add -l
```

### Container Issues
```bash
# View logs
docker logs -f glabs-website

# Restart container
docker-compose restart

# Rebuild container
docker-compose down
docker-compose up -d --build
```

## 📚 Additional Resources

- [NAT Deployment Guide](../docs/NAT-DEPLOYMENT.md)
- [Docker Deployment Guide](../docs/DOCKER-DEPLOYMENT.md)
- [Authentication Reference](../docs/AUTH-REFERENCE.md)
