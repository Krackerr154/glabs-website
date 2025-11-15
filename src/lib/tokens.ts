// Simple file-based token storage to persist between requests
import { existsSync, readFileSync, writeFileSync } from 'fs';
import { join } from 'path';

const TOKENS_FILE = join(process.cwd(), 'tokens.json');

interface TokenData {
  userId: string;
  expiresAt: string; // ISO string
}

interface TokenStore {
  [token: string]: TokenData;
}

export function saveToken(token: string, userId: string, expiresAt: Date): void {
  let tokens: TokenStore = {};
  
  // Load existing tokens
  if (existsSync(TOKENS_FILE)) {
    try {
      tokens = JSON.parse(readFileSync(TOKENS_FILE, 'utf-8'));
    } catch (e) {
      console.log('Error reading tokens file, starting fresh');
    }
  }
  
  // Add new token
  tokens[token] = {
    userId,
    expiresAt: expiresAt.toISOString()
  };
  
  // Clean expired tokens
  const now = new Date();
  Object.keys(tokens).forEach(key => {
    if (new Date(tokens[key].expiresAt) < now) {
      delete tokens[key];
    }
  });
  
  // Save to file
  writeFileSync(TOKENS_FILE, JSON.stringify(tokens, null, 2));
  console.log('Token saved:', token);
}

export function validateToken(token: string): { userId: string } | null {
  if (!existsSync(TOKENS_FILE)) {
    console.log('No tokens file found');
    return null;
  }
  
  try {
    const tokens: TokenStore = JSON.parse(readFileSync(TOKENS_FILE, 'utf-8'));
    const tokenData = tokens[token];
    
    if (!tokenData) {
      console.log('Token not found:', token);
      return null;
    }
    
    if (new Date(tokenData.expiresAt) < new Date()) {
      console.log('Token expired:', token);
      return null;
    }
    
    console.log('Token valid:', token);
    return { userId: tokenData.userId };
  } catch (e) {
    console.log('Error reading tokens:', e);
    return null;
  }
}

export function generateToken(): string {
  return Math.random().toString(36).substring(2) + Date.now().toString(36);
}
