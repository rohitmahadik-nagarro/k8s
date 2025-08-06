# Deploy K8s Assignment with ConfigMaps
# This script deploys the application with externalized database configuration

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
