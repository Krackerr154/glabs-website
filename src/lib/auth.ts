// Authentication utilities for session management
import type { AstroCookies } from 'astro';
import bcrypt from 'bcryptjs';
import { prisma } from './db';

const SESSION_COOKIE_NAME = 'session';
const SESSION_MAX_AGE = 60 * 60 * 24 * 7; // 7 days

/**
 * Simple session store (in-memory for single admin user)
 * In production with multiple servers, use Redis or database-backed sessions
 */
const sessions = new Map<string, { userId: string; expiresAt: Date }>();

/**
 * Generate a random session ID
 */
function generateSessionId(): string {
  return Math.random().toString(36).substring(2) + Date.now().toString(36);
}

/**
 * Create a new session for a user
 */
export function createSession(userId: string): string {
  const sessionId = generateSessionId();
  const expiresAt = new Date(Date.now() + SESSION_MAX_AGE * 1000);
  
  sessions.set(sessionId, { userId, expiresAt });
  
  console.log('DEBUG: createSession - sessionId:', sessionId);
  console.log('DEBUG: createSession - sessions size after:', sessions.size);
  
  return sessionId;
}

/**
 * Get session from cookies and validate it
 */
export function getSession(cookies: AstroCookies): { userId: string } | null {
  const sessionId = cookies.get(SESSION_COOKIE_NAME)?.value;
  const testCookie = cookies.get('test')?.value;
  const simpleCookie = cookies.get('simple')?.value;
  
  console.log('DEBUG: getSession - sessionId:', sessionId);
  console.log('DEBUG: getSession - testCookie:', testCookie);
  console.log('DEBUG: getSession - simpleCookie:', simpleCookie);
  console.log('DEBUG: getSession - sessions size:', sessions.size);
  console.log('DEBUG: getSession - sessions keys:', Array.from(sessions.keys()));
  
  // Try any of the cookies
  const actualSessionId = sessionId || simpleCookie;
  
  if (!actualSessionId) return null;
  
  const session = sessions.get(actualSessionId);
  
  console.log('DEBUG: getSession - found session:', !!session);
  
  if (!session) return null;
  
  // Check if session is expired
  if (session.expiresAt < new Date()) {
    sessions.delete(actualSessionId);
    return null;
  }
  
  return { userId: session.userId };
}

/**
 * Delete a session
 */
export function deleteSession(sessionId: string): void {
  sessions.delete(sessionId);
}

/**
 * Set session cookie
 */
export function setSessionCookie(cookies: AstroCookies, sessionId: string): void {
  console.log('DEBUG: setSessionCookie - sessionId:', sessionId);
  
  // Try multiple cookie approaches
  cookies.set(SESSION_COOKIE_NAME, sessionId);
  cookies.set('test', 'value123');
  cookies.set('simple', sessionId, { path: '/' });
  
  console.log('DEBUG: setSessionCookie - cookies set');
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
