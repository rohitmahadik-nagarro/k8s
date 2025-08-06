# Docker Compose Setup Script
# This script sets up environment variables and runs docker-compose

param(
    [string]$DbPassword,
    [string]$DbHost = "db",
    [string]$DbPort = "5432",
    [string]$DbName = "k8s_assignment", 
    [string]$DbUser = "postgres"
)

Write-Host "Setting up Docker Compose environment..." -ForegroundColor Green

# Prompt for password if not provided
if (-not $DbPassword) {
    Write-Host "Database password is required for Docker Compose." -ForegroundColor Yellow
    $securePassword = Read-Host "Enter database password" -AsSecureString
    $DbPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
}

# Set environment variables for docker-compose
$env:DB_HOST = $DbHost
$env:DB_PORT = $DbPort
$env:DB_NAME = $DbName
$env:DB_USER = $DbUser
$env:DB_PASSWORD = $DbPassword

Write-Host "Environment variables set:" -ForegroundColor Cyan
Write-Host "DB_HOST: $env:DB_HOST"
Write-Host "DB_PORT: $env:DB_PORT"
Write-Host "DB_NAME: $env:DB_NAME"
Write-Host "DB_USER: $env:DB_USER"
Write-Host "DB_PASSWORD: [SECURED - Length: $($DbPassword.Length) characters]"

Write-Host ""
Write-Host "Starting Docker Compose..." -ForegroundColor Yellow
docker-compose up --build

# Clear password from memory
$DbPassword = $null
$securePassword = $null
