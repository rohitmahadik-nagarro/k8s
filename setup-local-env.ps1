# Local Development Environment Setup Script
# This script sets up environment variables for local development
# to match the ConfigMap/Secret pattern used in Kubernetes

Write-Host "Setting up local development environment variables..."

# Database configuration (matching ConfigMap values)
$env:DB_HOST = "localhost"
$env:DB_PORT = "5432"
$env:DB_NAME = "k8s_assignment"
$env:DB_USER = "postgres"

# Prompt for password securely (no default password in config files)
if (-not $env:DB_PASSWORD) {
    Write-Host "Database password not set in environment." -ForegroundColor Yellow
    Write-Host "Please enter the database password for local development:"
    $securePassword = Read-Host "Password" -AsSecureString
    $env:DB_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
}

# ASP.NET Core environment
$env:ASPNETCORE_ENVIRONMENT = "Development"

Write-Host "Environment variables set:" -ForegroundColor Green
Write-Host "DB_HOST: $env:DB_HOST"
Write-Host "DB_PORT: $env:DB_PORT"
Write-Host "DB_NAME: $env:DB_NAME"
Write-Host "DB_USER: $env:DB_USER"
Write-Host "DB_PASSWORD: [SECURED - Length: $($env:DB_PASSWORD.Length) characters]"
Write-Host "ASPNETCORE_ENVIRONMENT: $env:ASPNETCORE_ENVIRONMENT"

Write-Host ""
Write-Host "You can now run your application with:" -ForegroundColor Cyan
Write-Host "dotnet run"
Write-Host ""
Write-Host "Or run with Visual Studio - the environment variables will be available."
Write-Host ""
Write-Host "Note: Password is required and not stored in configuration files for security."
