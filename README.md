Github code repository - https://github.com/rohitmahadik-nagarro/k8s

Docker hub URL - https://hub.docker.com/r/rohitmahadik/k8s

Service API tier URL - http://k8s-api.local/api/employee

Demo Recording - https://nagarro-my.sharepoint.com/:v:/p/rohit_mahadik/EXnqAoOB4gxOu1MpQo_sdlsBo7G_3ewtR4vPt593PBJxsg

# Kubernetes Setup for API and Database Deployment

This repository contains the Kubernetes configuration files required to deploy a PostgreSQL database and an API service on a Kubernetes cluster. It also includes ingress configuration using the NGINX Ingress Controller to expose the API externally.

## Prerequisites

- A running Kubernetes cluster
- `kubectl` configured to interact with your cluster
- Internet access to fetch remote manifests and images

## Setup Instructions

Follow these steps to deploy the PostgreSQL database and API service on your Kubernetes cluster:

1. **Apply ConfigMap for Database Configuration**  
   Apply the ConfigMap that contains the database configuration settings.

```bash
kubectl apply -f database-configmap.yaml
```



2. **Apply Secret for Database Credentials**  
Apply the Secret manifest which contains the database username and password.

```bash
kubectl apply -f database-secret.yaml
```



3. **Create Persistent Volume Claim for PostgreSQL**  
Apply the PVC manifest to request persistent storage for the database.

```bash
kubectl apply -f postgres-pvc.yaml
```



4. **Deploy the PostgreSQL Database**  
Deploy the PostgreSQL StatefulSet or Deployment.
```bash
kubectl apply -f k8s-assignment-db-deployment.yaml
```


5. **Deploy the API Service**  
Apply the deployment manifest for the API service.

```bash
kubectl apply -f k8s-assignment-api-deployment.yaml
```



6. **Install NGINX Ingress Controller**  
Install the official NGINX Ingress Controller using manifests or Helm chart. For example:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-vX.Y.Z/deploy/static/provider/cloud/deploy.yaml
```


7. **Wait for API to be ready**
```bash
kubectl wait --for=condition=ready pod -l app=k8s-api --timeout=300s
```

8. **Apply Ingress Configuration for the API**  
Apply the ingress resource to route external traffic to your API.

```bash
kubectl apply -f k8s-api-ingress.yaml
```



9. **Verify Ingress Setup**  
Check the ingress resource and the ingress controller pod statuses.

```bash
kubectl get ingress
kubectl get pods -n ingress-nginx
```

10. **Update Hostname in hosts file**
```bash
kubectl describe ingress k8s-api-ingress
```
Copy IP address from Address field and update in `/etc/hosts` as below

```bash
xx.xx.xx.xx  k8s-api.local
```


11.**Verification of the api service**
Open browser and enter url
```bash
http://k8s-api.local/api/employee
```
Records should be displyed on the browser.


## Notes

- Ensure the YAML files are tailored to your environment, including namespaces, resource names, and image versions.
- After deploying the ingress controller, it may take a few moments before the ingress resource becomes active and accessible.
- You might need to configure DNS or `/etc/hosts` to access the API via the ingress hostname.

## License

This repository is licensed under the MIT License.

---

Feel free to contribute or raise issues if you encounter any problems.
