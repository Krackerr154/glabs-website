#!/bin/bash

# Quick Setup Script for Admin Backend
# Run this after npm install

echo "🚀 Setting up admin backend..."

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created. Please edit it with your credentials."
    echo ""
else
    echo "✅ .env file already exists"
fi

# Generate Prisma client
echo "🔧 Generating Prisma client..."
npm run db:generate

# Push database schema
echo "💾 Creating database..."
npm run db:push

# Seed database
echo "🌱 Seeding database with initial data..."
npm run db:seed

echo ""
echo "✨ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your admin credentials"
echo "2. Run 'npm run dev' to start the development server"
echo "3. Visit http://localhost:4321/admin/login to access the admin panel"
echo ""
echo "📚 See ADMIN-SETUP.md for detailed documentation"
