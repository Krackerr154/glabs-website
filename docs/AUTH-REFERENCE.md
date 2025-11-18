# 🔐 G-Labs Authentication Quick Reference

## Current Credentials

### Admin Login
- **URL:** https://g-labs.my.id/admin/auth
- **Email:** `admin@g-labs.com`
- **Password:** `admin`

### Environment Variables
```bash
ADMIN_EMAIL="admin@g-labs.com"
ADMIN_PASSWORD="admin"
SESSION_SECRET="123"
DATABASE_URL="file:./prod.db"
```

## Quick Commands for NAT Machine

### Reset Admin Password
```bash
# On NAT machine (ubuntu@ubuntu:~$)
docker exec -it glabs-website npx prisma db seed
```

### Check if Login Works
```bash
# View container logs
docker logs -f glabs-website

# Should see: "Token saved: ..." when login succeeds
```

### Force Database Reset
```bash
docker exec -it glabs-website npx prisma db push --force-reset
docker exec -it glabs-website npm run db:seed
```

### Restart Container
```bash
cd /home/ubuntu/webcontent/main-page
docker-compose restart
```

## Testing Login

1. Open: https://g-labs.my.id/admin/auth
2. Enter:
   - Email: `admin@g-labs.com`
   - Password: `admin`
3. Should redirect to: `/admin/dashboard?token=...`
4. If successful, you'll see content statistics

## Troubleshooting

### "Invalid credentials"
- Check database was seeded: `docker exec -it glabs-website npx prisma db seed`
- Verify env variables: `docker exec -it glabs-website env | grep ADMIN`

### "Token not found"
- Database might be missing Session table
- Run: `docker exec -it glabs-website npx prisma db push`

### Redirect loop
- Clear browser cache and try again
- Check logs: `docker logs --tail 50 glabs-website`

## Database-Backed Sessions

Sessions are now stored in the SQLite database (`Session` table) instead of files. This means:
- ✅ Sessions persist across container restarts
- ✅ Works with Docker volumes
- ✅ No file permission issues
- ✅ Tokens expire after 24 hours

## Security Notes

**For Production:**
- The current SESSION_SECRET is `"123"` - this is intentionally simple
- Credentials are: `admin@g-labs.com` / `admin`
- All authentication data is in the SQLite database
- Change these if deploying publicly!

---

**Domain:** g-labs.my.id  
**Container:** glabs-website  
**Project Path:** /home/ubuntu/webcontent/main-page
