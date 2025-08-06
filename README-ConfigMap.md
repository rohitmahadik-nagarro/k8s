# K8s Assignment - Externalized Database Configuration

This project now uses Kubernetes ConfigMaps and Secrets to externalize database configuration, making it configurable without modifying application code or deployment files.

## Architecture

- **ConfigMap** (`database-config`): Contains non-sensitive database configuration (host, port, database name, username)
- **Secret** (`database-secret`): Contains sensitive information (password)
- **API Deployment**: References ConfigMap and Secret via environment variables
- **Database Deployment**: Uses the same ConfigMap and Secret for consistency

## Files Structure

```
yaml/
├── database-configmap.yaml      # Database configuration (non-sensitive)
├── database-secret.yaml         # Database password (sensitive)
├── k8s-assignment-api-deployment.yaml    # Updated API deployment
├── k8s-assignment-db-deployment.yaml     # Updated DB deployment
├── postgres-pvc.yaml            # Persistent volume claim
└── ...
```

## Deployment

### Quick Deployment
```powershell
.\deploy.ps1
```

### Manual Deployment
```powershell
# 1. Apply ConfigMap and Secret
kubectl apply -f yaml/database-configmap.yaml
kubectl apply -f yaml/database-secret.yaml

# 2. Apply PVC
kubectl apply -f yaml/postgres-pvc.yaml

# 3. Deploy database
kubectl apply -f yaml/k8s-assignment-db-deployment.yaml

# 4. Deploy API
kubectl apply -f yaml/k8s-assignment-api-deployment.yaml
```

## Configuration Management

### View Current Configuration
```powershell
# View ConfigMap
kubectl get configmap database-config -o yaml

# View Secret (base64 encoded)
kubectl get secret database-secret -o yaml
```

### Update Database Configuration

#### Option 1: Using the Update Script
```powershell
# Update with default values
.\update-db-config.ps1

# Update with custom values
.\update-db-config.ps1 -DbHost "new-db-host" -DbPort "5432" -DbName "new_db" -DbUser "new_user" -DbPassword "new_password"
```

#### Option 2: Manual Update
```powershell
# Edit ConfigMap
kubectl edit configmap database-config

# Edit Secret
kubectl edit secret database-secret
```

#### Option 3: Apply New Configuration Files
Update the YAML files and apply them:
```powershell
kubectl apply -f yaml/database-configmap.yaml
kubectl apply -f yaml/database-secret.yaml
```

### Restart Pods After Configuration Changes
```powershell
# Restart API pods
kubectl rollout restart deployment/k8s-api

# Restart database pod (if needed)
kubectl rollout restart statefulset/k8s-db
```

## Environment Variables in Pods

The following environment variables are now available in the API pods:

- `DB_HOST`: Database hostname
- `DB_PORT`: Database port
- `DB_NAME`: Database name
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password
- `ConnectionStrings__DefaultConnection`: Complete connection string

## Security Benefits

1. **Separation of Concerns**: Configuration is separate from application code and deployment definitions
2. **Secret Management**: Passwords are stored in Kubernetes Secrets (base64 encoded)
3. **Environment-Specific**: Different environments can have different ConfigMaps/Secrets
4. **Version Control**: Sensitive data doesn't need to be in version control
5. **Runtime Updates**: Configuration can be updated without rebuilding container images

## Example: Different Environments

### Development Environment
```yaml
# dev-database-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: database-config
  namespace: development
data:
  DB_HOST: "dev-postgres"
  DB_PORT: "5432"
  DB_NAME: "k8s_assignment_dev"
  DB_USER: "dev_user"
```

### Production Environment
```yaml
# prod-database-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: database-config
  namespace: production
data:
  DB_HOST: "prod-postgres-cluster"
  DB_PORT: "5432"
  DB_NAME: "k8s_assignment_prod"
  DB_USER: "prod_user"
```

## Troubleshooting

### Check Configuration
```powershell
# Check if ConfigMap exists
kubectl get configmap database-config

# Check if Secret exists
kubectl get secret database-secret

# View environment variables in running pod
kubectl exec -it <pod-name> -- env | grep DB_
```

### Check Pod Logs
```powershell
# API logs
kubectl logs -l app=k8s-api

# Database logs
kubectl logs -l app=k8s-db
```

### Verify Connection String
```powershell
# Check the constructed connection string in API pod
kubectl exec -it <api-pod-name> -- env | grep ConnectionStrings__DefaultConnection
```
