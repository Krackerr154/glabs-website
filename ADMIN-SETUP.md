# Admin Backend Setup Guide

This guide explains how to set up and use the admin backend for content management.

## Tech Stack

- **Frontend**: Astro 5.x (Hybrid SSR mode)
- **Backend**: Astro API Routes
- **Database**: SQLite + Prisma ORM
- **Authentication**: Session-based (in-memory sessions for single admin)
- **Deployment**: Docker + Nginx

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment Variables

Copy the example environment file:

```bash
copy .env.example .env
```

Edit `.env` and set your admin credentials:

```env
DATABASE_URL="file:./dev.db"
ADMIN_EMAIL="your-email@example.com"
ADMIN_PASSWORD="your-secure-password"
SESSION_SECRET="generate-a-random-string-here"
```

**Important**: Change these credentials before deploying to production!

### 3. Set Up Database

Generate Prisma client and create the database:

```bash
npm run db:generate
npm run db:push
```

### 4. Seed Initial Data

Create the admin user and sample content:

```bash
npm run db:seed
```

This will create:
- Admin user with credentials from `.env`
- Sample note, experiment, and project

### 5. Start Development Server

```bash
npm run dev
```

The site will be available at:
- Public site: http://localhost:4321
- Admin login: http://localhost:4321/admin/login

## Admin Panel Usage

### Logging In

1. Navigate to `/admin/login`
2. Enter your email and password from `.env`
3. You'll be redirected to the admin dashboard

### Managing Content

#### Notes
- **List**: `/admin/notes` - View all notes
- **Create**: `/admin/notes/new` - Create a new note
- **Edit**: `/admin/notes/edit/[id]` - Edit existing note
- **Delete**: Click delete button in the list view

#### Experiments (Research)
- **List**: `/admin/experiments`
- **Create**: `/admin/experiments/new`
- **Edit**: `/admin/experiments/edit/[id]`
- **Delete**: Delete button in list view

#### Projects
- **List**: `/admin/projects`
- **Create**: `/admin/projects/new`
- **Edit**: `/admin/projects/edit/[id]`
- **Delete**: Delete button in list view

### Content Fields

#### Notes
- **Title**: Main heading (required)
- **Slug**: URL-friendly identifier (auto-generated if empty)
- **Description**: Short summary
- **Content**: Full content in Markdown format (required)
- **Tags**: Comma-separated tags
- **Published**: Toggle to make public

#### Experiments
- **Title**: Experiment name (required)
- **Slug**: URL identifier (auto-generated if empty)
- **Summary**: Brief overview
- **Content**: Full content in Markdown (required)
- **Published**: Toggle visibility

#### Projects
- **Title**: Project name (required)
- **Slug**: URL identifier (auto-generated if empty)
- **Description**: Project summary (required)
- **Content**: Detailed content in Markdown
- **Tech Stack**: Comma-separated technologies
- **Status**: completed / in-progress / planned
- **GitHub URL**: Link to repository (optional)
- **Live URL**: Link to live demo (optional)
- **Featured**: Show on homepage
- **Published**: Toggle visibility

## Public Pages

Content is automatically displayed on public pages when published:

- **Notes**: `/notes` and `/notes/[slug]`
- **Research**: `/research` and `/research/[slug]`
- **Projects**: `/projects` and `/projects/[slug]`
- **Homepage**: Featured projects and recent notes

## Database Management

### View Database

Use a SQLite viewer to inspect the database:

```bash
# Install sqlite3 if needed
# On Windows: choco install sqlite

# Open database
sqlite3 prisma/dev.db
```

### Reset Database

To start fresh:

```bash
# Delete database
Remove-Item prisma/dev.db

# Recreate and seed
npm run db:push
npm run db:seed
```

### Create Migration (Production)

When changing the schema:

```bash
npm run db:migrate
```

## Deployment

### Docker Deployment

The existing Docker setup works with the backend:

1. Build the image:
```bash
docker build -t glabs-website .
```

2. Run with environment variables:
```bash
docker run -p 3000:3000 \
  -e DATABASE_URL="file:/app/data/prod.db" \
  -e ADMIN_EMAIL="admin@example.com" \
  -e ADMIN_PASSWORD="secure-password" \
  -e SESSION_SECRET="random-secret-string" \
  -v $(pwd)/data:/app/data \
  glabs-website
```

3. Mount a volume for the database to persist data

### Docker Compose

Update `docker-compose.yml` to include environment variables and volume:

```yaml
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=file:/app/data/prod.db
      - ADMIN_EMAIL=${ADMIN_EMAIL}
      - ADMIN_PASSWORD=${ADMIN_PASSWORD}
      - SESSION_SECRET=${SESSION_SECRET}
    volumes:
      - ./data:/app/data
```

### VPS Deployment

1. SSH into your server
2. Clone the repository
3. Create `.env` file with production credentials
4. Run setup scripts
5. Start with Docker or PM2

## Security Considerations

### Production Checklist

- [ ] Change default admin credentials
- [ ] Use a strong `SESSION_SECRET` (generate with: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`)
- [ ] Enable HTTPS/SSL
- [ ] Set `NODE_ENV=production`
- [ ] Back up database regularly
- [ ] Use secure session cookies (already configured for production)
- [ ] Consider adding rate limiting for login attempts
- [ ] Review Nginx configuration for security headers

### Session Management

- Sessions are stored in-memory (suitable for single admin)
- Sessions expire after 7 days of inactivity
- For multi-server deployments, consider Redis for session storage

## Troubleshooting

### "Cannot find module '@prisma/client'"

Run:
```bash
npm run db:generate
```

### Login not working

1. Check `.env` credentials match what you're entering
2. Verify database was seeded: `npm run db:seed`
3. Check browser console for errors

### Database locked error

SQLite doesn't handle concurrent writes well. This shouldn't be an issue with a single admin user, but if it occurs:
- Restart the development server
- Check no other process is accessing the database

### Content not showing on public pages

1. Verify content is marked as "Published" in admin panel
2. Check database has data: `sqlite3 prisma/dev.db "SELECT * FROM Note"`
3. Clear browser cache
4. Check server logs for errors

## API Reference

### Authentication Endpoints

- `POST /api/auth/logout` - Logout current session

### Content API (Protected)

All admin routes require authentication. Requests without valid session redirect to `/admin/login`.

- Notes: `/api/notes/[id]/delete`
- Experiments: `/api/experiments/[id]/delete`
- Projects: `/api/projects/[id]/delete`

## Development Tips

### Hot Reload

The development server watches for file changes. Admin panel changes are reflected immediately.

### Markdown Preview

Content is rendered with the `marked` library. Test your markdown at https://marked.js.org/demo/

### Database Schema Changes

After modifying `prisma/schema.prisma`:

```bash
npm run db:push  # Development
npm run db:migrate  # Production (creates migration files)
```

### Adding New Fields

1. Update `prisma/schema.prisma`
2. Run `npm run db:push`
3. Update admin forms
4. Update public display templates

## Support

For issues or questions:
1. Check this README
2. Review error logs
3. Check browser developer console
4. Verify environment variables are set correctly

## License

Same as main project
