// Authentication utilities for session management
import type { AstroCookies } from 'astro';
import bcrypt from 'bcryptjs';
import { prisma } from './db';

const SESSION_COOKIE_NAME = 'session';
const SESSION_MAX_AGE = 60 * 60 * 24 * 7; // 7 days

/**
 * Generate a random session ID
 */
function generateSessionId(): string {
  return Math.random().toString(36).substring(2) + Date.now().toString(36);
}

/**
 * Create a new session for a user
 */
export async function createSession(userId: string): Promise<string> {
  const sessionId = generateSessionId();
  const expiresAt = new Date(Date.now() + SESSION_MAX_AGE * 1000);
  
  // Store session in database (create a simple Session table would be better, but for now use a simple approach)
  // For simplicity, we'll just encode the session info in the sessionId itself
  const sessionData = JSON.stringify({ userId, expiresAt: expiresAt.toISOString() });
  const encodedSession = Buffer.from(sessionData).toString('base64');
  
  console.log('DEBUG: createSession - sessionId:', sessionId, 'encoded:', encodedSession);
  
  return encodedSession;
}

/**
 * Get session from cookies and validate it
 */
export function getSession(cookies: AstroCookies): { userId: string } | null {
  const sessionId = cookies.get(SESSION_COOKIE_NAME)?.value;
  const simpleCookie = cookies.get('simple')?.value;
  
  console.log('DEBUG: getSession - sessionId:', sessionId);
  console.log('DEBUG: getSession - simpleCookie:', simpleCookie);
  
  // Try any of the cookies
  const actualSessionId = sessionId || simpleCookie;
  
  if (!actualSessionId) return null;
  
  try {
    // Decode the session data
    const sessionData = JSON.parse(Buffer.from(actualSessionId, 'base64').toString());
    const expiresAt = new Date(sessionData.expiresAt);
    
    console.log('DEBUG: getSession - found session data:', { userId: sessionData.userId, expiresAt });
    
    // Check if session is expired
    if (expiresAt < new Date()) {
      console.log('DEBUG: getSession - session expired');
      return null;
    }
    
    return { userId: sessionData.userId };
  } catch (error) {
    console.log('DEBUG: getSession - failed to decode session:', error);
    return null;
  }
}

/**
 * Delete a session (with encoded sessions, we don't need to track them)
 */
export function deleteSession(sessionId: string): void {
  // With encoded sessions, we don't need to delete anything
  console.log('DEBUG: deleteSession - session deleted (no-op):', sessionId);
}

/**
 * Set session cookie
 */
export function setSessionCookie(cookies: AstroCookies, sessionId: string): void {
  console.log('DEBUG: setSessionCookie - sessionId:', sessionId);
  
  // Set the session cookie with proper options
  cookies.set(SESSION_COOKIE_NAME, sessionId, {
    path: '/',
    httpOnly: true,
    secure: false, // Set to false for development, true for production
    sameSite: 'lax',
    maxAge: SESSION_MAX_AGE
  });
  
  // Also set a simple test cookie
  cookies.set('simple', sessionId, { path: '/' });
  
  console.log('DEBUG: setSessionCookie - cookies set with options');
}

/**
 * Clear session cookie
 */
export function clearSessionCookie(cookies: AstroCookies): void {
  const sessionId = cookies.get(SESSION_COOKIE_NAME)?.value;
  if (sessionId) {
    deleteSession(sessionId);
  }
  cookies.delete(SESSION_COOKIE_NAME, { path: '/' });
}

/**
 * Authenticate user with email and password
 */
export async function authenticate(email: string, password: string): Promise<string | null> {
  const user = await prisma.user.findUnique({
    where: { email },
  });
  
  if (!user) return null;
  
  const isValid = await bcrypt.compare(password, user.password);
  
  if (!isValid) return null;
  
  return user.id;
}

/**
 * Check if user is authenticated
 */
export function isAuthenticated(cookies: AstroCookies): boolean {
  return getSession(cookies) !== null;
}

/**
 * Require authentication (use in API routes)
 */
export function requireAuth(cookies: AstroCookies): { userId: string } {
  const session = getSession(cookies);
  
  if (!session) {
    throw new Error('Unauthorized');
  }
  
  return session;
}
