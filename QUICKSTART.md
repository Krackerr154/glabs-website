# 🚀 Quick Start Guide - Admin Backend

## Prerequisites
- Node.js 18+ installed
- npm or yarn package manager

## Step 1: Install Dependencies

```bash
npm install
```

This will install all required packages including:
- Astro with Node adapter
- Prisma + SQLite
- Authentication libraries

## Step 2: Set Up Environment

The `.env` file has been created with default credentials:

```env
DATABASE_URL="file:./dev.db"
ADMIN_EMAIL="admin@example.com"
ADMIN_PASSWORD="changeme123"
SESSION_SECRET="change-this-to-a-random-secret-in-production"
```

**⚠️ IMPORTANT**: Change these credentials before deploying!

## Step 3: Initialize Database

Run these commands in order:

```bash
# Generate Prisma client
npm run db:generate

# Create database tables
npm run db:push

# Seed with admin user and sample data
npm run db:seed
```

## Step 4: Start Development Server

```bash
npm run dev
```

The server will start at: **http://localhost:4321**

## Step 5: Access Admin Panel

1. Open browser to: **http://localhost:4321/admin/login**
2. Login with credentials from `.env`:
   - Email: `admin@example.com`
   - Password: `changeme123`
3. You'll be redirected to the admin dashboard

## Admin Routes

- **Dashboard**: `/admin` - Overview and statistics
- **Notes**: `/admin/notes` - Manage blog posts
- **Experiments**: `/admin/experiments` - Manage research
- **Projects**: `/admin/projects` - Manage portfolio

## Public Routes (Auto-Updated)

- **Homepage**: `/` - Shows featured projects and recent notes
- **Notes List**: `/notes` - All published notes
- **Note Detail**: `/notes/[slug]` - Individual note page
- **Research List**: `/research` - All published experiments
- **Research Detail**: `/research/[slug]` - Individual experiment
- **Projects List**: `/projects` - All published projects
- **Projects Detail**: `/projects/[slug]` - Individual project (uses existing system)

## Troubleshooting

### "Cannot find module '@prisma/client'"
```bash
npm run db:generate
```

### Login not working
1. Verify you ran `npm run db:seed`
2. Check credentials in `.env` match what you're typing
3. Check browser console for errors

### Database file missing
```bash
npm run db:push
npm run db:seed
```

### Port already in use
Change port in `astro.config.mjs` or kill the process using port 4321

## Production Deployment

1. **Update credentials** in `.env` or use environment variables
2. **Generate strong session secret**:
   ```bash
   node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
   ```
3. **Build the project**:
   ```bash
   npm run build
   ```
4. **Run with Docker** (existing setup works):
   ```bash
   docker build -t glabs-website .
   docker run -p 3000:3000 \
     -e DATABASE_URL="file:/app/data/prod.db" \
     -e ADMIN_EMAIL="your@email.com" \
     -e ADMIN_PASSWORD="your-secure-password" \
     -e SESSION_SECRET="your-random-secret" \
     -v $(pwd)/data:/app/data \
     glabs-website
   ```

## What's Next?

1. **Create content** - Use admin panel to add notes, experiments, and projects
2. **Customize** - Modify admin UI, add fields, adjust styling
3. **Deploy** - Follow deployment guide in `ADMIN-SETUP.md`

## Need Help?

- See detailed guide: `ADMIN-SETUP.md`
- Implementation details: `IMPLEMENTATION-SUMMARY.md`
- Check errors in browser console
- Review server logs in terminal

## Key Features

✅ Secure authentication with session management  
✅ Full CRUD for Notes, Experiments, Projects  
✅ Markdown content support  
✅ Publish/unpublish toggle  
✅ Featured projects for homepage  
✅ Auto-generated slugs  
✅ SQLite database (Docker-friendly)  
✅ Clean admin interface  
✅ Existing Docker deployment compatible  

---

**You're all set!** 🎉 Start by logging into `/admin/login` and creating your first content.
