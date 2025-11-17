// Database-backed token storage for Docker persistence
import { prisma } from './db';

export async function saveToken(token: string, userId: string, expiresAt: Date): Promise<void> {
  // Clean up expired tokens
  await prisma.session.deleteMany({
    where: {
      expiresAt: {
        lt: new Date(),
      },
    },
  });

  // Create new session
  await prisma.session.create({
    data: {
      token,
      userId,
      expiresAt,
    },
  });
  
  console.log('Token saved:', token);
}

export async function validateToken(token: string): Promise<{ userId: string } | null> {
  try {
    const session = await prisma.session.findUnique({
      where: { token },
    });

    if (!session) {
      console.log('Token not found:', token);
      return null;
    }

    if (session.expiresAt < new Date()) {
      console.log('Token expired:', token);
      // Token expired, remove it
      await prisma.session.delete({
        where: { token },
      });
      return null;
    }

    console.log('Token valid:', token);
    return { userId: session.userId };
  } catch (e) {
    console.log('Error validating token:', e);
    return null;
  }
}

export function generateToken(): string {
  return Math.random().toString(36).substring(2) + Date.now().toString(36);
}
