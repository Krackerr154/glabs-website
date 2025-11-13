# Deployment Guide

This document provides comprehensive deployment instructions for the Gerald Arya personal website.

## Prerequisites

- Node.js 20.x or higher
- Docker and Docker Compose (for containerized deployment)
- Git

## Local Development

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` and configure your n8n webhook URL:

```env
PUBLIC_N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/contact
PUBLIC_SITE_URL=http://localhost:4321
```

### 3. Run Development Server

```bash
npm run dev
```

The site will be available at `http://localhost:4321`

### 4. Build for Production

```bash
npm run build
```

The static site will be generated in the `./dist` directory.

### 5. Preview Production Build

```bash
npm run preview
```

## Docker Deployment

### Using Docker Compose (Recommended)

1. Build and start the container:

```bash
docker-compose up -d
```

2. The site will be available at `http://localhost:3000`

3. View logs:

```bash
docker-compose logs -f
```

4. Stop the container:

```bash
docker-compose down
```

### Manual Docker Build

1. Build the image:

```bash
docker build -t gerald-arya-portfolio .
```

2. Run the container:

```bash
docker run -d -p 3000:80 --name portfolio gerald-arya-portfolio
```

## Production Deployment

### Option 1: Static Hosting (Netlify, Vercel, etc.)

1. Build the site:

```bash
npm run build
```

2. Deploy the `dist` folder to your hosting provider.

3. Configure environment variables in your hosting dashboard.

### Option 2: VPS with Docker

1. SSH into your server:

```bash
ssh user@your-server.com
```

2. Clone the repository:

```bash
git clone https://github.com/yourusername/portfolio.git
cd portfolio
```

3. Configure environment:

```bash
cp .env.example .env
nano .env  # Edit with production values
```

4. Build and run with Docker Compose:

```bash
docker-compose up -d
```

5. (Optional) Set up reverse proxy with Nginx or Caddy for SSL.

### Option 3: Cloud Platforms

#### AWS S3 + CloudFront

1. Build the site:

```bash
npm run build
```

2. Upload to S3:

```bash
aws s3 sync dist/ s3://your-bucket-name --delete
```

3. Configure CloudFront distribution for CDN.

#### Google Cloud Storage

1. Build the site:

```bash
npm run build
```

2. Upload to GCS:

```bash
gsutil -m rsync -r -d dist/ gs://your-bucket-name
```

## n8n Webhook Setup

### 1. Create n8n Workflow

1. Open your n8n instance
2. Create a new workflow
3. Add a **Webhook** node:
   - Method: POST
   - Path: /contact
   - Response Mode: On received

4. Add processing nodes (e.g., email, database, Slack notification)

5. Activate the workflow

### 2. Get Webhook URL

Copy the webhook URL from n8n (e.g., `https://your-n8n.com/webhook/contact`)

### 3. Update Environment

Add the webhook URL to your `.env` file:

```env
PUBLIC_N8N_WEBHOOK_URL=https://your-n8n.com/webhook/contact
```

## Content Management

### Adding Projects

Create a new markdown file in `src/content/projects/`:

```bash
touch src/content/projects/my-new-project.md
```

Add frontmatter and content:

```markdown
---
title: "My New Project"
description: "Project description"
publishedAt: 2024-11-12
featured: false
technologies: ["Technology1", "Technology2"]
githubUrl: "https://github.com/user/repo"
liveUrl: "https://example.com"
tags: ["tag1", "tag2"]
---

Your project content here...
```

### Adding Notes

Create a new markdown file in `src/content/notes/`:

```bash
touch src/content/notes/my-new-note.md
```

Add frontmatter and content:

```markdown
---
title: "My New Note"
description: "Note description"
publishedAt: 2024-11-12
draft: false
tags: ["tag1", "tag2"]
category: "Category Name"
---

Your note content here...
```

## Monitoring and Maintenance

### Check Site Health

```bash
# Check Docker container status
docker-compose ps

# View logs
docker-compose logs -f web

# Check resource usage
docker stats gerald-arya-portfolio
```

### Updates

1. Pull latest changes:

```bash
git pull origin main
```

2. Rebuild and redeploy:

```bash
docker-compose down
docker-compose up -d --build
```

## Performance Optimization

### 1. Image Optimization

- Use WebP format where possible
- Implement lazy loading
- Serve responsive images

### 2. Caching

The nginx configuration includes:
- 1-year cache for static assets
- Gzip compression
- Proper cache headers

### 3. CDN (Optional)

Consider using a CDN like:
- Cloudflare
- AWS CloudFront
- Fastly

## Security

### SSL/TLS Certificate

For production, use Let's Encrypt with Certbot:

```bash
sudo certbot --nginx -d geraldarya.com -d www.geraldarya.com
```

### Security Headers

Security headers are configured in `nginx.conf`:
- X-Frame-Options
- X-Content-Type-Options
- X-XSS-Protection
- Referrer-Policy

## Troubleshooting

### Build Errors

Clear cache and rebuild:

```bash
rm -rf node_modules .astro dist
npm install
npm run build
```

### Docker Issues

Remove containers and rebuild:

```bash
docker-compose down -v
docker-compose up -d --build
```

### Content Not Showing

1. Check markdown frontmatter is valid
2. Ensure dates are in correct format
3. Verify content is not marked as draft

## Backup

### Automated Backup Script

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/portfolio"

# Backup content
tar -czf "$BACKUP_DIR/content_$DATE.tar.gz" src/content/

# Backup environment
cp .env "$BACKUP_DIR/.env_$DATE"

echo "Backup completed: $DATE"
```

## Support

For issues or questions:
- GitHub Issues: https://github.com/yourusername/portfolio/issues
- Email: contact@geraldarya.com

## License

© 2025 Gerald Arya. All rights reserved.
