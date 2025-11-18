# Docker Deployment Guide for g-labs.my.id

This guide will help you deploy your G-Labs website to your Ubuntu NAT machine using Docker.

## 📋 Prerequisites

On your NAT machine (Ubuntu):
- Docker and Docker Compose installed
- Git installed
- Access to `/home/ubuntu/webcontent/main-page/`

## 🚀 Deployment Steps

### 1. Update Code on NAT Machine

```bash
# SSH to your NAT machine
ssh ubuntu@your-nat-machine

# Navigate to project directory
cd /home/ubuntu/webcontent/main-page

# Pull latest changes (or clone if fresh install)
git pull origin main
# OR for fresh install:
# git clone https://github.com/Krackerr154/glabs-website.git .
```

### 2. Update Environment Variables

Create or update `.env` file:

```bash
# Create .env file
cat > .env << 'EOF'
# Database
DATABASE_URL="file:./prod.db"

# Admin Credentials
ADMIN_EMAIL="admin@g-labs.com"
ADMIN_PASSWORD="admin"

# Session Secret
SESSION_SECRET="123"

# Domain
PUBLIC_SITE_URL="https://g-labs.my.id"
EOF
```

### 3. Update Database Schema

```bash
# Generate Prisma client
docker exec -it glabs-website npx prisma generate

# Push schema to database (creates Session table)
docker exec -it glabs-website npx prisma db push

# Seed database with admin user
docker exec -it glabs-website npm run db:seed
```

### 4. Rebuild and Restart Container

```bash
# Stop current container
docker-compose down

# Rebuild with latest code
docker-compose build --no-cache

# Start container
docker-compose up -d

# Check logs
docker logs -f glabs-website
```

## 🔐 Login to Admin Panel

1. Visit: `https://g-labs.my.id/admin/auth`
2. Use credentials from `.env`:
   - Email: `admin@g-labs.com`
   - Password: `admin`

## 📊 Key Changes for Docker

### Database-Backed Sessions
- Sessions now stored in SQLite database (not file system)
- Persists across container restarts
- Token expiration: 24 hours

### Environment Variables
The container uses these variables:
```
ADMIN_EMAIL - Admin login email
ADMIN_PASSWORD - Admin login password  
DATABASE_URL - SQLite database location
PUBLIC_SITE_URL - Your domain URL
```

## 🛠 Troubleshooting

### Can't Login
```bash
# Check if database exists
docker exec -it glabs-website ls -la /app/*.db

# Recreate database
docker exec -it glabs-website npx prisma db push --force-reset
docker exec -it glabs-website npm run db:seed
```

### Check Container Logs
```bash
# View live logs
docker logs -f glabs-website

# View last 100 lines
docker logs --tail 100 glabs-website
```

### Reset Admin Password
```bash
# Enter container
docker exec -it glabs-website sh

# Run password reset script (you'll need to create this)
node scripts/reset-password.js
```

### Database Issues
```bash
# Backup database first!
docker exec -it glabs-website cp /app/prod.db /app/prod.db.backup

# Reset database
docker exec -it glabs-website npx prisma db push --force-reset
docker exec -it glabs-website npm run db:seed
```

## 📁 Volume Mounts

Make sure your `docker-compose.yml` has these volumes:

```yaml
volumes:
  - ./prod.db:/app/prod.db          # Database persistence
  - ./uploads:/app/public/uploads    # User uploads (if any)
```

## 🔄 Quick Update Script

Save this as `update.sh`:

```bash
#!/bin/bash
cd /home/ubuntu/webcontent/main-page
git pull origin main
docker-compose down
docker-compose build --no-cache
docker-compose up -d
echo "✅ Deployment complete! Check logs:"
docker logs --tail 50 glabs-website
```

Make it executable:
```bash
chmod +x update.sh
```

Then run:
```bash
./update.sh
```

## 🌐 Domain Configuration

Ensure your reverse proxy (nginx/caddy) is configured to forward to the container:

```nginx
# Example nginx config
server {
    listen 443 ssl http2;
    server_name g-labs.my.id;
    
    location / {
        proxy_pass http://localhost:4321;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## ✅ Verification

After deployment, check:

1. **Website loads**: https://g-labs.my.id
2. **Admin login works**: https://g-labs.my.id/admin/auth
3. **Database persists**: Login, add content, restart container, verify content still there

## 📞 Support

If you encounter issues:
1. Check container logs: `docker logs glabs-website`
2. Verify environment variables: `docker exec -it glabs-website env`
3. Check database file: `docker exec -it glabs-website ls -la /*.db`

---

**Current Setup:**
- Container: `glabs-website`
- Project Path: `/home/ubuntu/webcontent/main-page`
- Domain: `g-labs.my.id`
- OS: Ubuntu
