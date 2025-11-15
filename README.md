# Gerald Arya - Personal Website

A modern, performant personal website built with Astro and Tailwind CSS. Features include project showcases, research highlights, technical notes, and an integrated contact form.

## 🎨 Design

- **Color Scheme**: Navy (#1e293b) and Cyan (#06b6d4)
- **Typography**: Inter font family
- **Accessibility**: WCAG-AA compliant
- **Performance**: Optimized for fast LCP with minimal JavaScript

## 🚀 Features

- ✅ **Static Site Generation** - Lightning-fast load times
- ✅ **Content Collections** - Markdown-based content management for projects and notes
- ✅ **Dynamic Routing** - Slug-based routing for projects and notes
- ✅ **SEO Optimized** - Open Graph, Twitter Cards, JSON-LD structured data
- ✅ **Accessible** - WCAG-AA compliance with semantic HTML
- ✅ **Responsive** - Mobile-first design
- ✅ **Contact Integration** - n8n webhook for form submissions
- ✅ **Docker Ready** - Containerized with Docker Compose
- ✅ **One-Command Deployment** - Automated deployment scripts
- ✅ **Navy/Cyan Theme** - Professional color scheme with animated gradients

## 📁 Project Structure

```text
/
├── public/              # Static assets
├── src/
│   ├── components/      # Reusable components
│   ├── content/         # Markdown content
│   │   ├── projects/    # Project markdown files
│   │   ├── notes/       # Note markdown files
│   │   └── config.ts    # Content collection schemas
│   ├── layouts/         # Page layouts
│   │   └── BaseLayout.astro
│   ├── pages/           # Page routes
│   │   ├── index.astro
│   │   ├── projects.astro
│   │   ├── projects/[slug].astro
│   │   ├── notes.astro
│   │   ├── notes/[slug].astro
│   │   ├── research.astro
│   │   ├── about.astro
│   │   ├── contact.astro
│   │   └── 404.astro
│   ├── styles/          # Global styles
│   │   └── global.css
│   └── utils/           # Utility functions
├── .github/
│   └── copilot-instructions.md
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
└── astro.config.mjs
```

## 🛠️ Commands

| Command | Action |
|---------|--------|
| `npm install` | Install dependencies |
| `npm run dev` | Start dev server at `localhost:4321` |
| `npm run build` | Build production site to `./dist/` |
| `npm run preview` | Preview production build locally |
| `npm run astro ...` | Run Astro CLI commands |

## � VPS Deployment (Recommended)

### Quick Deploy (3 Steps)

1. **Setup VPS** (one-time):
```bash
scp setup-vps.sh user@your-vps-ip:/tmp/
ssh user@your-vps-ip 'bash /tmp/setup-vps.sh'
```

2. **Configure environment** on VPS:
```bash
ssh user@your-vps-ip 'nano /opt/glabs-website/.env'
```

3. **Deploy**:
```bash
# Linux/Mac
chmod +x deploy.sh
export DEPLOY_HOST=your.vps.ip
export DEPLOY_USER=your-username
./deploy.sh

# Windows PowerShell
$env:DEPLOY_HOST='your.vps.ip'
$env:DEPLOY_USER='your-username'
.\deploy.ps1
```

**Done!** Site live at `http://your-vps-ip:8080`

📖 **Full Guide**: See [DEPLOY-QUICK.md](DEPLOY-QUICK.md) for detailed instructions

### Available Deployment Scripts

| Script | Purpose |
|--------|---------|
| `setup-vps.sh` | Initial VPS setup (run once) |
| `deploy.sh` / `deploy.ps1` | Deploy website |
| `check-status.sh` | Check deployment status |
| `logs.sh` | View container logs |
| `restart.sh` | Restart container |

📚 **Scripts Guide**: See [SCRIPTS-README.md](SCRIPTS-README.md)

## 🐳 Local Docker Testing

### Build and run with Docker Compose:

```bash
docker-compose up -d
```

The site will be available at `http://localhost:8080`

### Build Docker image manually:

```bash
docker build -t glabs-website .
docker run -p 8080:80 glabs-website
```

## ⚙️ Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure:

```env
PUBLIC_N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/contact
PUBLIC_SITE_URL=https://geraldarya.com
```

### Content Management

#### Adding Projects

Create a new markdown file in `src/content/projects/`:

```markdown
---
title: "Project Title"
description: "Project description"
publishedAt: 2024-11-12
featured: true
technologies: ["Astro", "TypeScript"]
githubUrl: "https://github.com/username/repo"
liveUrl: "https://example.com"
tags: ["web", "development"]
---

Your project content here...
```

#### Adding Notes

Create a new markdown file in `src/content/notes/`:

```markdown
---
title: "Note Title"
description: "Note description"
publishedAt: 2024-11-12
draft: false
tags: ["tag1", "tag2"]
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
