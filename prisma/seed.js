// Seed script to create admin user and sample data
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Get admin credentials from environment
  const adminEmail = process.env.ADMIN_EMAIL || 'admin@example.com';
  const adminPassword = process.env.ADMIN_PASSWORD || 'changeme123';

  // Hash the password
  const hashedPassword = await bcrypt.hash(adminPassword, 10);

  // Create or update admin user
  const user = await prisma.user.upsert({
    where: { email: adminEmail },
    update: { password: hashedPassword },
    create: {
      email: adminEmail,
      password: hashedPassword,
    },
  });

  console.log('✅ Admin user created/updated:', user.email);

  // Create sample note
  await prisma.note.upsert({
    where: { slug: 'welcome-to-my-blog' },
    update: {},
    create: {
      title: 'Welcome to My Blog',
      slug: 'welcome-to-my-blog',
      description: 'An introduction to my personal blog and what you can expect to find here.',
      content: `# Welcome to My Blog

This is my first blog post! I'll be sharing insights about technology, development, and research.

## What to Expect

- Technical tutorials and guides
- Research findings and experiments
- Project updates and showcases
- Thoughts on the tech industry

Stay tuned for more content!`,
      tags: JSON.stringify(['introduction', 'welcome', 'meta']),
      published: true,
    },
  });

  // Create sample experiment
  await prisma.experiment.upsert({
    where: { slug: 'performance-optimization-study' },
    update: {},
    create: {
      title: 'Web Performance Optimization Study',
      slug: 'performance-optimization-study',
      summary: 'Analyzing various techniques to improve web application performance',
      content: `# Performance Optimization Study

## Objective
Identify and test various performance optimization techniques for modern web applications.

## Methodology
- Baseline performance measurements
- Implementation of optimization strategies
- Comparative analysis

## Key Findings
- Code splitting reduced initial load time by 40%
- Image optimization saved 2MB per page load
- Caching strategies improved repeat visit performance by 60%

## Conclusion
Performance optimization is crucial for user experience and should be considered from the start of development.`,
      published: true,
    },
  });

  // Create sample projects matching the markdown content collection slugs
  await prisma.project.upsert({
    where: { slug: 'portfolio-website' },
    update: {},
    create: {
      title: 'Portfolio Website',
      slug: 'portfolio-website',
      description: 'A modern, responsive portfolio website built with Astro and Tailwind CSS',
      content: `Personal portfolio showcasing projects and technical writing.`,
      techStack: JSON.stringify(['Astro', 'TypeScript', 'Tailwind CSS', 'Prisma']),
      status: 'completed',
      featured: true,
      published: true,
      githubUrl: 'https://github.com/Krackerr154/glabs-website',
      liveUrl: 'https://g-labs.my.id',
    },
  });

  await prisma.project.upsert({
    where: { slug: 'task-management-api' },
    update: {},
    create: {
      title: 'Task Management API',
      slug: 'task-management-api',
      description: 'RESTful API for task management with authentication',
      content: `A robust task management API built with modern technologies.`,
      techStack: JSON.stringify(['Node.js', 'Express', 'MongoDB', 'JWT']),
      status: 'completed',
      featured: false,
      published: true,
      githubUrl: 'https://github.com/Krackerr154/task-api',
    },
  });

  console.log('✅ Sample data created');
  console.log('\n🎉 Seeding completed!');
  console.log('\n📝 Admin credentials:');
  console.log(`   Email: ${adminEmail}`);
  console.log(`   Password: ${adminPassword}`);
}

main()
  .catch((e) => {
    console.error('❌ Error seeding database:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
