import { defineCollection, z } from 'astro:content';

const projects = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    publishedAt: z.date(),
    featured: z.boolean().default(false),
    technologies: z.array(z.string()),
    githubUrl: z.string().url().optional(),
    liveUrl: z.string().url().optional(),
    image: z.string().optional(),
    tags: z.array(z.string()).default([])
  })
});

const notes = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    publishedAt: z.date(),
    updatedAt: z.date().optional(),
    draft: z.boolean().default(false),
    tags: z.array(z.string()).default([]),
    category: z.string().optional()
  })
});

export const collections = {
  projects,
  notes
};
