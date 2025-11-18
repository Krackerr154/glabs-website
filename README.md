# Gerald Arya - Personal Website

A modern, performant personal website built with Astro and Tailwind CSS. Features project showcases, research highlights, technical notes, and an admin panel for content management.

🌐 **Live Site**: [g-labs.my.id](https://g-labs.my.id)

## 🎨 Design Philosophy

- **Color Scheme**: Navy (#1e293b) and Cyan (#06b6d4)
- **Typography**: Inter font family for optimal readability
- **Accessibility**: WCAG-AA compliant with semantic HTML
- **Performance**: Optimized for fast LCP with minimal client-side JavaScript

## ✨ Key Features

- 🚀 **Static Site Generation** - Lightning-fast page loads with Astro
- 📝 **Admin Dashboard** - Built-in CMS for managing projects, notes, and research
- 🔐 **Secure Authentication** - Database-backed token authentication
- 📁 **Content Collections** - Organized markdown-based content management
- 🎯 **SEO Optimized** - Open Graph, Twitter Cards, JSON-LD structured data
- ♿ **Fully Accessible** - WCAG-AA compliance throughout
- 📱 **Mobile-First Design** - Responsive across all devices
- 🐳 **Docker Ready** - Containerized deployment with Docker Compose
- 🗄️ **SQLite Database** - Prisma ORM for data management

## 📁 Project Structure

```text
/
├── docs/                # Documentation files
├── prisma/              # Database schema and migrations
│   ├── schema.prisma    # Prisma schema definition
│   └── seed.js          # Database seeding script
├── public/              # Static assets (favicon, robots.txt)
├── scripts/             # Deployment and utility scripts
├── src/
│   ├── content/         # Markdown content collections
│   │   ├── notes/       # Technical notes and blog posts
│   │   ├── projects/    # Project showcases
│   │   └── config.ts    # Content schemas
│   ├── layouts/         # Page layouts
│   │   └── BaseLayout.astro
│   ├── lib/             # Core utilities
│   │   ├── auth.ts      # Authentication helpers
│   │   ├── db.ts        # Prisma database client
│   │   ├── tokens.ts    # Token management
│   │   └── utils.ts     # Helper functions
│   ├── pages/           # Application routes
│   │   ├── admin/       # Admin dashboard & CMS
│   │   ├── api/         # API endpoints
│   │   ├── notes/       # Notes listing and detail pages
│   │   ├── projects/    # Projects listing and detail pages
│   │   └── *.astro      # Public pages (home, about, contact, etc.)
│   ├── styles/          # Global CSS
│   └── utils/           # Frontend utilities
├── .github/             # GitHub configuration
├── Dockerfile           # Docker container definition
├── docker-compose.yml   # Docker Compose configuration
├── nginx.conf           # Nginx web server config
└── astro.config.mjs     # Astro framework configuration
```

## 🛠️ Development

### Prerequisites

- Node.js 18+ and npm
- Git

### Local Setup

```bash
# Clone repository
git clone https://github.com/Krackerr154/glabs-website.git
cd glabs-website

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env

# Initialize database
npx prisma generate
npx prisma db push
npm run db:seed

# Start development server
npm run dev
```

Visit `http://localhost:4321` to view the site.

### Available Commands

| Command | Action |
|---------|--------|
| `npm install` | Install dependencies |
| `npm run dev` | Start dev server at `localhost:4321` |
| `npm run build` | Build production site to `./dist/` |
| `npm run preview` | Preview production build locally |
| `npm run db:seed` | Seed database with sample data |
| `npx prisma studio` | Open Prisma Studio to view database |

## 🔐 Admin Dashboard

Access the admin panel at `/admin/auth` with default credentials:

- **Email**: `admin@g-labs.com`
- **Password**: `admin`

⚠️ **Important**: Change the default credentials in production by updating the `.env` file and reseeding the database.

### Admin Features

- 📝 Create, edit, and delete notes
- 🚀 Manage project showcases
- 🔬 Organize research experiments
- 📊 View content statistics
- 🔒 Secure token-based authentication

## 🐳 Docker Deployment

### Quick Start

```bash
# Build and start containers
docker-compose up -d

# View logs
docker logs -f glabs-website

# Stop containers
docker-compose down
```

The site will be available at `http://localhost:8080`

### Production Deployment

See the comprehensive deployment guides in the `docs/` directory:

- 📘 **[NAT-DEPLOYMENT.md](docs/NAT-DEPLOYMENT.md)** - Deploy to NAT/VPS environment
- 📗 **[DOCKER-DEPLOYMENT.md](docs/DOCKER-DEPLOYMENT.md)** - Full Docker deployment guide
- 📕 **[AUTH-REFERENCE.md](docs/AUTH-REFERENCE.md)** - Authentication quick reference

### Deployment Scripts

Located in `scripts/` directory:

| Script | Purpose |
|--------|---------|
| `deploy.sh` / `deploy.ps1` | Deploy to server |
| `setup-vps.sh` | Initial VPS setup |
| `check-status.sh` | Check deployment status |
| `logs.sh` | View container logs |
| `restart.sh` | Restart containers |

## ⚙️ Configuration

### Environment Variables

Create a `.env` file based on `.env.example`:

```env
# Database
DATABASE_URL="file:./dev.db"

# Admin Credentials
ADMIN_EMAIL="admin@g-labs.com"
ADMIN_PASSWORD="admin"

# Session Security
SESSION_SECRET="your-secret-key-here"

# Public URLs
PUBLIC_SITE_URL="https://g-labs.my.id"
```

### Database Management

```bash
# Generate Prisma client
npx prisma generate

# Apply schema changes
npx prisma db push

# Seed database
npm run db:seed

# Open Prisma Studio
npx prisma studio
```

### Content Management

Use the admin dashboard at `/admin/auth` to manage content through the web interface, or manually create markdown files:

#### Adding Projects

Create a new markdown file in `src/content/projects/`:

```markdown
---
title: "Project Title"
description: "Brief project description"
publishedAt: 2024-11-12
featured: true
technologies: ["Astro", "TypeScript", "Tailwind"]
githubUrl: "https://github.com/username/repo"
liveUrl: "https://example.com"
tags: ["web", "development"]
---

Your detailed project content here...
```

#### Adding Notes

Create a new markdown file in `src/content/notes/`:

```markdown
---
title: "Note Title"
description: "Brief note description"
publishedAt: 2024-11-12
draft: false
tags: ["javascript", "tutorial"]
category: "Development"
---

Your note content here...
```

## 🎯 Performance

- **Minimal JavaScript**: Client-side JS only where needed
- **Optimized Images**: Lazy loading and proper sizing
- **Static Generation**: Pre-rendered at build time
- **Caching**: Nginx configured for optimal caching
- **Compression**: Gzip enabled for text resources

## ♿ Accessibility

- Semantic HTML structure
- ARIA labels and roles
- Keyboard navigation support
- Focus indicators
- Skip-to-content link
- Alt text for images
- Proper heading hierarchy

## 📝 License

© 2025 Gerald Arya. All rights reserved.

## 🤝 Contact

- **Email**: [gerald.arya154@gmail.com](mailto:gerald.arya154@gmail.com)
- **LinkedIn**: [Gerald Arya Dewangga](https://www.linkedin.com/in/gerald-arya-dewangga-06842a283)
- **GitHub**: [Krackerr154](https://github.com/Krackerr154)

For inquiries, please use the contact form on the website or reach out directly via email.
