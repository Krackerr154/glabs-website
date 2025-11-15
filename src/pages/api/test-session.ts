import type { APIRoute } from 'astro';
import { createSession, setSessionCookie } from '../../lib/auth';

export const GET: APIRoute = async ({ cookies }) => {
  // Create a test session
  const sessionId = await createSession('e190d779-8a9d-4ed3-91f6-8ea7807ce534');
  setSessionCookie(cookies, sessionId);
  
  return new Response(JSON.stringify({ 
    success: true, 
    sessionId,
    message: 'Test session created. Try accessing /admin now.'
  }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' }
  });
};
