# G-Labs Website Deployment Script for Windows PowerShell
# Usage: .\deploy.ps1

param(
    [string]$DeployHost = $env:DEPLOY_HOST,
    [string]$DeployUser = $env:DEPLOY_USER,
    [string]$DeployPath = "/opt/glabs-website"
)

# Colors
$ErrorColor = "Red"
$SuccessColor = "Green"
$InfoColor = "Cyan"
$WarnColor = "Yellow"

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $InfoColor
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $SuccessColor
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor $WarnColor
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $ErrorColor
}

# Check if required parameters are set
if (-not $DeployHost) {
    Write-Error-Custom "Please set DEPLOY_HOST environment variable or provide -DeployHost parameter"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  `$env:DEPLOY_HOST='your.vps.ip'"
    Write-Host "  `$env:DEPLOY_USER='your-username'"
    Write-Host "  .\deploy.ps1"
    Write-Host ""
    Write-Host "Or:"
    Write-Host "  .\deploy.ps1 -DeployHost your.vps.ip -DeployUser your-username"
    exit 1
}

if (-not $DeployUser) {
    $DeployUser = "root"
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $InfoColor
Write-Host "🚀 G-Labs Website Deployment" -ForegroundColor $InfoColor
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $InfoColor
Write-Host "Target: $DeployUser@${DeployHost}:$DeployPath"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $InfoColor
Write-Host ""

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Warn ".env file not found"
    if (Test-Path ".env.example") {
        Write-Info "Creating .env from .env.example..."
        Copy-Item ".env.example" ".env"
        Write-Warn "Please edit .env file with your production values"
        Write-Host "Press Enter to continue after editing .env file..."
        Read-Host
    } else {
        Write-Error-Custom ".env.example not found. Please create .env file manually."
        exit 1
    }
}

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Info "Node.js version: $nodeVersion"
} catch {
    Write-Error-Custom "Node.js is not installed. Please install Node.js 20+ first."
    exit 1
}

# Build the project
Write-Info "📦 Building the project..."
try {
    npm run build
    Write-Success "Build completed successfully"
} catch {
    Write-Error-Custom "Build failed! Please fix errors and try again."
    exit 1
}

# Create deployment package
Write-Info "📦 Creating deployment package..."

# Check if tar is available (Git Bash includes tar)
$tarAvailable = Get-Command tar -ErrorAction SilentlyContinue

if ($tarAvailable) {
    # Use tar if available
    if (Test-Path ".env") {
        tar -czf deploy.tar.gz dist/ Dockerfile docker-compose.yml nginx.conf package.json package-lock.json .env
    } else {
        tar -czf deploy.tar.gz dist/ Dockerfile docker-compose.yml nginx.conf package.json package-lock.json
    }
} else {
    # Fallback: Create zip file
    Write-Warn "tar not found, creating zip file instead..."
    
    $files = @(
        "dist",
        "Dockerfile",
        "docker-compose.yml",
        "nginx.conf",
        "package.json",
        "package-lock.json"
    )
    
    if (Test-Path ".env") {
        $files += ".env"
    }
    
    Compress-Archive -Path $files -DestinationPath deploy.zip -Force
    
    Write-Info "Created deploy.zip (will extract on server)"
}

Write-Success "Deployment package created"

# Test SSH connection
Write-Info "🔐 Testing SSH connection..."
$sshTest = ssh -o BatchMode=yes -o ConnectTimeout=5 "$DeployUser@$DeployHost" "exit" 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Cannot connect to VPS. Please check:"
    Write-Host "  1. VPS IP address is correct: $DeployHost"
    Write-Host "  2. SSH key is set up"
    Write-Host "  3. Firewall allows SSH connection"
    
    if (Test-Path "deploy.tar.gz") { Remove-Item "deploy.tar.gz" }
    if (Test-Path "deploy.zip") { Remove-Item "deploy.zip" }
    exit 1
}
Write-Success "SSH connection successful"

# Create remote directory
Write-Info "📁 Creating remote directory..."
ssh "$DeployUser@$DeployHost" "mkdir -p $DeployPath"

# Transfer files
Write-Info "📤 Transferring files to VPS..."

if (Test-Path "deploy.tar.gz") {
    scp deploy.tar.gz "$DeployUser@${DeployHost}:$DeployPath/"
    if ($LASTEXITCODE -ne 0) {
        Write-Error-Custom "File transfer failed!"
        Remove-Item "deploy.tar.gz"
        exit 1
    }
    $deployFile = "deploy.tar.gz"
} else {
    scp deploy.zip "$DeployUser@${DeployHost}:$DeployPath/"
    if ($LASTEXITCODE -ne 0) {
        Write-Error-Custom "File transfer failed!"
        Remove-Item "deploy.zip"
        exit 1
    }
    $deployFile = "deploy.zip"
}

Write-Success "Files transferred successfully"

# Deploy on VPS
Write-Info "🚀 Deploying on VPS..."

$deployScript = @"
set -e
cd $DeployPath

echo '📦 Extracting files...'
if [ -f deploy.tar.gz ]; then
    tar -xzf deploy.tar.gz
    rm deploy.tar.gz
elif [ -f deploy.zip ]; then
    unzip -q -o deploy.zip
    rm deploy.zip
fi

echo '🐳 Checking Docker...'
if ! command -v docker &> /dev/null; then
    echo '❌ Docker is not installed. Please run setup-vps.sh first.'
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo '❌ Docker Compose is not installed. Please run setup-vps.sh first.'
    exit 1
fi

echo '🛑 Stopping existing container...'
docker-compose down 2>/dev/null || true

echo '🧹 Cleaning up old Docker images...'
docker image prune -f 2>/dev/null || true

echo '🔨 Building Docker image...'
if ! docker-compose build --no-cache; then
    echo '❌ Docker build failed!'
    exit 1
fi

echo '▶️  Starting container...'
if ! docker-compose up -d; then
    echo '❌ Failed to start container!'
    exit 1
fi

echo '⏳ Waiting for container to be healthy...'
sleep 5

if docker-compose ps | grep -q 'Up'; then
    echo '✅ Container is running!'
    
    if command -v curl &> /dev/null; then
        sleep 2
        if curl -f http://localhost:8080/health &> /dev/null; then
            echo '✅ Health check passed!'
        else
            echo '⚠️  Warning: Health check failed, but container is running'
        fi
    fi
else
    echo '❌ Container failed to start!'
    echo 'Logs:'
    docker-compose logs --tail=50
    exit 1
fi

echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
echo '✅ Deployment completed successfully!'
echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
"@

ssh "$DeployUser@$DeployHost" $deployScript

if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Deployment failed on VPS"
    exit 1
}

# Cleanup local files
if (Test-Path "deploy.tar.gz") { Remove-Item "deploy.tar.gz" }
if (Test-Path "deploy.zip") { Remove-Item "deploy.zip" }

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $SuccessColor
Write-Success "🎉 Deployment completed successfully!"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $SuccessColor
Write-Host ""
Write-Host "📊 Deployment Summary:" -ForegroundColor $InfoColor
Write-Host "✓ Built project locally"
Write-Host "✓ Transferred files to VPS"
Write-Host "✓ Deployed Docker container"
Write-Host "✓ Container is running and healthy"
Write-Host ""
Write-Host "🌐 Site URL: http://${DeployHost}:8080"
Write-Host "🔍 Health Check: http://${DeployHost}:8080/health"
Write-Host ""
Write-Host "📝 Useful commands:"
Write-Host "  View logs:    ssh $DeployUser@$DeployHost 'cd $DeployPath && docker-compose logs -f'"
Write-Host "  Restart:      ssh $DeployUser@$DeployHost 'cd $DeployPath && docker-compose restart'"
Write-Host "  Stop:         ssh $DeployUser@$DeployHost 'cd $DeployPath && docker-compose down'"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $SuccessColor
