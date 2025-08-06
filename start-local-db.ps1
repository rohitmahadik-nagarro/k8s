# Start local PostgreSQL database using Docker
# This creates a database that matches your Kubernetes configuration

param(
    [string]$ContainerName = "postgres-local",
    [string]$DbName = "k8s_assignment",
    [string]$DbUser = "postgres", 
    [string]$DbPassword,
    [int]$Port = 5432
)

Write-Host "Starting local PostgreSQL database..."
Write-Host "Container Name: $ContainerName"
Write-Host "Database: $DbName"
Write-Host "User: $DbUser"
Write-Host "Port: $Port"

# Prompt for password if not provided
if (-not $DbPassword) {
    Write-Host "Database password is required." -ForegroundColor Yellow
    $securePassword = Read-Host "Enter database password" -AsSecureString
    $DbPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
}

# Check if container already exists
$existingContainer = docker ps -a --filter "name=$ContainerName" --format "{{.Names}}"

if ($existingContainer -eq $ContainerName) {
    Write-Host "Container '$ContainerName' already exists. Starting it..."
    docker start $ContainerName
} else {
    Write-Host "Creating new PostgreSQL container..."
    docker run --name $ContainerName `
        -e POSTGRES_DB=$DbName `
        -e POSTGRES_USER=$DbUser `
        -e POSTGRES_PASSWORD=$DbPassword `
        -p ${Port}:5432 `
        -d postgres:16
}

# Wait for database to be ready
Write-Host "Waiting for database to be ready..."
Start-Sleep -Seconds 5

# Test connection
Write-Host "Testing database connection..."
$env:PGPASSWORD = $DbPassword
$testResult = docker exec $ContainerName psql -h localhost -U $DbUser -d $DbName -c "SELECT 1;" 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Database is ready!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Database connection details:" -ForegroundColor Yellow
    Write-Host "Host: localhost"
    Write-Host "Port: $Port"
    Write-Host "Database: $DbName"
    Write-Host "Username: $DbUser"
    Write-Host "Password: [SECURED - Length: $($DbPassword.Length) characters]"
    Write-Host ""
    Write-Host "To connect your application, run:" -ForegroundColor Cyan
    Write-Host ".\setup-local-env.ps1"
    Write-Host "dotnet run"
    Write-Host ""
    Write-Host "To stop the database:" -ForegroundColor Gray
    Write-Host "docker stop $ContainerName"
    Write-Host ""
    Write-Host "To remove the database:" -ForegroundColor Gray
    Write-Host "docker rm -f $ContainerName"
} else {
    Write-Host "❌ Failed to connect to database. Check Docker logs:" -ForegroundColor Red
    Write-Host "docker logs $ContainerName"
}
