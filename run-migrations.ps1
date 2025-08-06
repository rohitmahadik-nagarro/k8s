# Database Migration Script
# This script sets up environment variables and runs EF Core migrations

param(
    [string]$DbPassword,
    [string]$DbHost = "localhost",
    [string]$DbPort = "5432",
    [string]$DbName = "k8s_assignment",
    [string]$DbUser = "postgres"
)

Write-Host "Setting up environment for database migrations..." -ForegroundColor Green

# Prompt for password if not provided
if (-not $DbPassword) {
    Write-Host "Database password is required for migrations." -ForegroundColor Yellow
    $securePassword = Read-Host "Enter database password" -AsSecureString
    $DbPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
}

# Set environment variables for EF Core
$env:DB_HOST = $DbHost
$env:DB_PORT = $DbPort
$env:DB_NAME = $DbName
$env:DB_USER = $DbUser
$env:DB_PASSWORD = $DbPassword

Write-Host "Environment variables set for migrations:" -ForegroundColor Cyan
Write-Host "DB_HOST: $env:DB_HOST"
Write-Host "DB_PORT: $env:DB_PORT"
Write-Host "DB_NAME: $env:DB_NAME"
Write-Host "DB_USER: $env:DB_USER"
Write-Host "DB_PASSWORD: [SECURED]"

Write-Host ""
Write-Host "Running database migrations..." -ForegroundColor Yellow

# Run migrations
dotnet ef database update

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Database migrations completed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Database migration failed!" -ForegroundColor Red
}

# Clear password from memory
$DbPassword = $null
$securePassword = $null
