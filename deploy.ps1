# Deploy K8s Assignment with ConfigMaps
# This script deploys the application with externalized database configuration

# Step 0: Install NGINX Ingress controller if not present
Write-Host "Checking for NGINX Ingress controller..." -ForegroundColor Yellow
$ingressPods = kubectl get pods -A | Select-String -Pattern "ingress-nginx-controller"
if (-not $ingressPods) {
    Write-Host "NGINX Ingress controller not found. Installing..." -ForegroundColor Yellow
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml
    Write-Host "Waiting for NGINX Ingress controller to be ready..." -ForegroundColor Yellow
    kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=180s
} else {
    Write-Host "NGINX Ingress controller is already installed." -ForegroundColor Green
}

# Step 1: Apply ConfigMap and Secret first
kubectl apply -f yaml/database-configmap.yaml
kubectl apply -f yaml/database-secret.yaml

# Step 2: Apply PVC
kubectl apply -f yaml/postgres-pvc.yaml

# Step 3: Apply Database deployment
kubectl apply -f yaml/k8s-assignment-db-deployment.yaml

# Step 4: Wait for database to be ready
kubectl wait --for=condition=ready pod -l app=k8s-db --timeout=300s

# Step 5: Apply API deployment
kubectl apply -f yaml/k8s-assignment-api-deployment.yaml

# Step 6: Wait for API to be ready
kubectl wait --for=condition=ready pod -l app=k8s-api --timeout=300s

Write-Host "Deployment completed!"
Write-Host "Check the status with: kubectl get pods"
Write-Host "Get service details: kubectl get services"
