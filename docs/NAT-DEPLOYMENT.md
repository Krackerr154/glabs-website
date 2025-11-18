# Quick Deployment Steps for NAT Machine

## 🎯 What Changed

The authentication system has been updated to use **database-backed sessions** instead of file-based tokens. This ensures login works properly in Docker environments.

## ⚡ Commands to Run on Your NAT Machine

### Step 1: Update Code
```bash
cd /home/ubuntu/webcontent/main-page
git pull origin main
```

### Step 2: Update Prisma Schema
```bash
# Generate new Prisma client with Session model
docker exec -it glabs-website npx prisma generate

# Apply database changes (adds Session table)
docker exec -it glabs-website npx prisma db push
```

### Step 3: Rebuild Container
```bash
# Stop container
docker-compose down

# Rebuild with new code
docker-compose build --no-cache

# Start container
docker-compose up -d
```

### Step 4: Verify
```bash
# Check logs
docker logs -f glabs-website

# You should see "Prisma schema loaded" without errors
```

### Step 5: Test Login
1. Go to: `https://g-labs.my.id/admin/auth`
2. Login with:
   - **Email:** `admin@g-labs.com`
   - **Password:** `admin`

## 🔧 If Login Still Doesn't Work

### Reset Admin User
```bash
# Enter container
docker exec -it glabs-website sh

# Inside container, run:
npx prisma db seed
```

### Check Database
```bash
# Verify database file exists
docker exec -it glabs-website ls -la /app/*.db

# Should show: prod.db (or dev.db)
```

### View Logs for Errors
```bash
docker logs --tail 100 glabs-website
```

## 📝 What Was Fixed

1. **Session Storage**: Changed from file-based (`tokens.json`) to database-backed (`Session` table in SQLite)
2. **Async Operations**: Updated all token validation to use async/await with database queries
3. **Docker Persistence**: Sessions now survive container restarts
4. **Admin Pages**: Updated all admin pages to use new async token validation

## 🎉 Expected Behavior

After deployment:
- ✅ Login form at `/admin/auth` accepts credentials
- ✅ Redirects to `/admin/dashboard?token=...` with valid token
- ✅ Token validates successfully from database
- ✅ Admin pages accessible with token parameter
- ✅ Sessions persist across container restarts

## 🆘 Troubleshooting

### Error: "Property 'session' does not exist"
```bash
# Regenerate Prisma client
docker exec -it glabs-website npx prisma generate
docker-compose restart
```

### Error: "Token not found"
```bash
# Reset database
docker exec -it glabs-website npx prisma db push --force-reset
docker exec -it glabs-website npm run db:seed
```

### Container Won't Start
```bash
# Check logs
docker logs glabs-website

# Common fix: rebuild
docker-compose build --no-cache
docker-compose up -d
```

---

**Test the changes locally first** by running `npm run dev` on your development machine to ensure everything works before deploying to production!
