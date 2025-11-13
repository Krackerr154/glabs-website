# Contributing Guide

Thank you for your interest in contributing to this project!

## Development Setup

1. **Fork and Clone**

```bash
git clone https://github.com/yourusername/portfolio.git
cd portfolio
```

2. **Install Dependencies**

```bash
npm install
```

3. **Create Environment File**

```bash
cp .env.example .env
```

4. **Start Development Server**

```bash
npm run dev
```

## Project Structure

```
src/
├── components/      # Reusable components
├── content/         # Markdown content (projects, notes)
├── layouts/         # Page layouts
├── pages/           # Routes and pages
├── styles/          # Global styles
└── utils/           # Utility functions
```

## Code Style

### TypeScript/JavaScript

- Use TypeScript for type safety
- Follow existing code style
- Use meaningful variable names
- Add comments for complex logic

### CSS/Tailwind

- Use Tailwind utility classes
- Follow mobile-first approach
- Maintain consistent spacing
- Use custom CSS classes sparingly

### Astro Components

- Keep components focused and reusable
- Use proper TypeScript types
- Document component props
- Follow accessibility best practices

## Making Changes

### 1. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes

- Write clean, maintainable code
- Follow the existing code style
- Test your changes locally
- Ensure accessibility compliance

### 3. Test Thoroughly

```bash
# Run development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

### 4. Commit Your Changes

```bash
git add .
git commit -m "feat: add new feature description"
```

Use conventional commit messages:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

## Adding Content

### Projects

1. Create a new file in `src/content/projects/`
2. Add required frontmatter fields
3. Write your content in Markdown
4. Test locally

### Notes

1. Create a new file in `src/content/notes/`
2. Add required frontmatter fields
3. Write your content in Markdown
4. Test locally

## Accessibility Guidelines

- Use semantic HTML
- Provide alt text for images
- Ensure keyboard navigation
- Maintain color contrast (WCAG-AA)
- Test with screen readers

## Performance Guidelines

- Optimize images before adding
- Minimize client-side JavaScript
- Use static generation where possible
- Test with Lighthouse

## Questions?

Feel free to open an issue for any questions or clarifications!
