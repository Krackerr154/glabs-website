// API route to delete an experiment
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
      await prisma.experiment.delete({ where: { id } });
    } catch (error) {
      console.error('Error deleting experiment:', error);
    }
  }
  
  return redirect('/admin/experiments');
};

export const prerender = false;
