const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient();

async function checkUser() {
  try {
    console.log('🔍 Checking database for admin user...\n');

    // Get all users
    const users = await prisma.user.findMany();
    console.log(`Found ${users.length} user(s) in database\n`);

    if (users.length === 0) {
      console.log('❌ No users found! Database needs to be seeded.');
      console.log('\nRun: npm run db:seed\n');
      return;
    }

    // Check each user
    for (const user of users) {
      console.log('📧 Email:', user.email);
      console.log('👤 Name:', user.name);
      console.log('🔑 Password Hash:', user.password.substring(0, 20) + '...');
      
      // Test password "admin"
      const testPassword = 'admin';
      const isValid = await bcrypt.compare(testPassword, user.password);
      console.log(`✓ Password "admin" works:`, isValid ? '✅ YES' : '❌ NO');
      
      // Test if it's bcrypt hash
      const isBcrypt = user.password.startsWith('$2');
      console.log(`✓ Is bcrypt hash:`, isBcrypt ? '✅ YES' : '❌ NO');
      
      console.log('---\n');
    }

    // Show expected credentials
    console.log('📋 Expected credentials from environment:');
    console.log('   Email:', process.env.ADMIN_EMAIL || 'admin@g-labs.com');
    console.log('   Password:', process.env.ADMIN_PASSWORD || 'admin');
    console.log('   Session Secret:', process.env.SESSION_SECRET || '123');

  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await prisma.$disconnect();
  }
}

checkUser();
