# Copilot Instructions

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

This is Gerald Arya's personal website built with Astro and Tailwind CSS.

## Project Structure & Guidelines

### Design System
- Use navy (#1e293b) and cyan (#06b6d4) color scheme throughout
- Follow WCAG-AA accessibility standards
- Optimize for fast LCP and minimal JavaScript usage
- Maintain responsive design with mobile-first approach

### Content Management
- Projects and notes use markdown content collections with frontmatter
- All content should be SEO-optimized with proper meta tags
- Include Open Graph and JSON-LD structured data for all pages

### Architecture
- Use Astro's static site generation capabilities
- Minimize client-side JavaScript - prefer server-side rendering
- Implement proper semantic HTML structure
- Use Tailwind utilities for styling

### Performance Requirements
- Target fast LCP (Largest Contentful Paint)
- Optimize images and assets
- Use proper caching strategies
- Minimize bundle size

### Accessibility
- Ensure WCAG-AA compliance
- Use proper heading hierarchy
- Include alt text for images
- Implement keyboard navigation
- Use semantic HTML elements

### Content Collections
- Projects: Include title, description, tech stack, links, and featured image
- Notes: Include title, description, tags, and publish date
- Both should support slug-based routing
