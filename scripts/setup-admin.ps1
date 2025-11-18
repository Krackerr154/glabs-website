# Quick Setup Script for Admin Backend
# Run this after npm install

Write-Host "🚀 Setting up admin backend..." -ForegroundColor Cyan

# Check if .env exists
if (-not (Test-Path ".env")) {
    Write-Host "📝 Creating .env file from template..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "✅ .env file created. Please edit it with your credentials." -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
}

# Generate Prisma client
Write-Host "🔧 Generating Prisma client..." -ForegroundColor Cyan
npm run db:generate

# Push database schema
Write-Host "💾 Creating database..." -ForegroundColor Cyan
npm run db:push

# Seed database
Write-Host "🌱 Seeding database with initial data..." -ForegroundColor Cyan
npm run db:seed

Write-Host ""
Write-Host "✨ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Edit .env file with your admin credentials" -ForegroundColor White
Write-Host "2. Run 'npm run dev' to start the development server" -ForegroundColor White
Write-Host "3. Visit http://localhost:4321/admin/auth to access the admin panel" -ForegroundColor White
Write-Host ""
Write-Host "📚 See ADMIN-SETUP.md for detailed documentation" -ForegroundColor Yellow
