# Script to update database configuration
param(
    [string]$DbHost = "k8s-db",
    [string]$DbPort = "5432", 
    [string]$DbName = "k8s_assignment",
    [string]$DbUser = "postgres",
    [string]$DbPassword
)

Write-Host "Updating database configuration..."
Write-Host "Host: $DbHost"
Write-Host "Port: $DbPort"
Write-Host "Database: $DbName"
Write-Host "User: $DbUser"

# Prompt for password if not provided
if (-not $DbPassword) {
    Write-Host "Database password is required." -ForegroundColor Yellow
    $securePassword = Read-Host "Enter database password" -AsSecureString
    $DbPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
}

# Encode password to base64
$encodedPassword = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($DbPassword))

# Create temporary ConfigMap YAML
$configMapContent = @"
apiVersion: v1
kind: ConfigMap
metadata:
  name: database-config
  namespace: default
data:
  DB_HOST: "$DbHost"
  DB_PORT: "$DbPort"
  DB_NAME: "$DbName"
  DB_USER: "$DbUser"
"@

# Create temporary Secret YAML
$secretContent = @"
apiVersion: v1
kind: Secret
metadata:
  name: database-secret
  namespace: default
type: Opaque
data:
  DB_PASSWORD: $encodedPassword
"@

# Write to temporary files
$configMapContent | Out-File -FilePath "temp-configmap.yaml" -Encoding UTF8
$secretContent | Out-File -FilePath "temp-secret.yaml" -Encoding UTF8

# Apply the updates
kubectl apply -f temp-configmap.yaml
kubectl apply -f temp-secret.yaml

# Clean up temporary files
Remove-Item "temp-configmap.yaml" -Force
Remove-Item "temp-secret.yaml" -Force

Write-Host "Configuration updated! You may need to restart the pods for changes to take effect:"
Write-Host "kubectl rollout restart deployment/k8s-api"
Write-Host "kubectl rollout restart statefulset/k8s-db"

# Clear password from memory
$DbPassword = $null
$securePassword = $null
