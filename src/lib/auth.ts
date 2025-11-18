/**
 * Authentication utilities
 * Note: This project uses both cookie-based and token-based authentication
 * - Token-based (preferred): Used by /admin/auth, /admin/dashboard
 * - Cookie-based (legacy): Used by some admin pages
 */
import type { AstroCookies } from 'astro';
import bcrypt from 'bcryptjs';
import { prisma } from './db';

const SESSION_COOKIE_NAME = 'session';
const SESSION_MAX_AGE = 60 * 60 * 24 * 7; // 7 days

/**
 * Authenticate user with email and password
 * Returns user ID if credentials are valid, null otherwise
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

// ===== Cookie-based session functions (legacy) =====

function generateSessionId(): string {
  return Math.random().toString(36).substring(2) + Date.now().toString(36);
}

export async function createSession(userId: string): Promise<string> {
  const sessionId = generateSessionId();
  const expiresAt = new Date(Date.now() + SESSION_MAX_AGE * 1000);
  const sessionData = JSON.stringify({ userId, expiresAt: expiresAt.toISOString() });
  return Buffer.from(sessionData).toString('base64');
}

export function getSession(cookies: AstroCookies): { userId: string } | null {
  const sessionId = cookies.get(SESSION_COOKIE_NAME)?.value;
  if (!sessionId) return null;
  
  try {
    const sessionData = JSON.parse(Buffer.from(sessionId, 'base64').toString());
    const expiresAt = new Date(sessionData.expiresAt);
    
    if (expiresAt < new Date()) {
      return null;
    }
    
    return { userId: sessionData.userId };
  } catch (error) {
    return null;
  }
}

export function setSessionCookie(cookies: AstroCookies, sessionId: string): void {
  cookies.set(SESSION_COOKIE_NAME, sessionId, {
    path: '/',
    httpOnly: true,
    secure: false,
    sameSite: 'lax',
    maxAge: SESSION_MAX_AGE
  });
}

export function clearSessionCookie(cookies: AstroCookies): void {
  cookies.delete(SESSION_COOKIE_NAME, { path: '/' });
}

export function isAuthenticated(cookies: AstroCookies): boolean {
  return getSession(cookies) !== null;
}

export function requireAuth(cookies: AstroCookies): { userId: string } {
  const session = getSession(cookies);
  if (!session) {
    throw new Error('Unauthorized');
  }
  return session;
}
