// API route to delete a project
import type { APIRoute } from 'astro';
import { requireAuth } from '../../../../lib/auth';
import { prisma } from '../../../../lib/db';

export const GET: APIRoute = async ({ params, cookies, redirect }) => {
  try {
    requireAuth(cookies);
  } catch {
    return redirect('/admin/login');
  }
  
  const { id } = params;
  if (id) {
    try {
      await prisma.project.delete({ where: { id } });
    } catch (error) {
      console.error('Error deleting project:', error);
    }
  }
  
  return redirect('/admin/projects');
};

export const prerender = false;
