// API route to delete a note
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
  
  if (!id) {
    return redirect('/admin/notes');
  }
  
  try {
    await prisma.note.delete({
      where: { id },
    });
  } catch (error) {
    console.error('Error deleting note:', error);
  }
  
  return redirect('/admin/notes');
};

export const prerender = false;
