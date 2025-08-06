# Local Development with ConfigMaps/Secrets Pattern

This guide explains how to run your application locally while using the same configuration pattern as Kubernetes (ConfigMaps/Secrets).

## 🔒 Security Note

**No passwords are stored in configuration files** - this is intentional for security. You must provide passwords through environment variables or other secure methods.

## Why Use This Approach?

1. **Consistency**: Same configuration pattern across local development and Kubernetes
2. **Security**: No passwords in configuration files or version control
3. **Environment Variables**: Easy to switch between different database instances
4. **Team Development**: Each developer can have their own database settings

## Methods for Local Development

### Method 1: PowerShell Environment Variables (Recommended)

1. **Run the setup script** (will prompt for password):
   ```powershell
   .\setup-local-env.ps1
   ```

2. **Run your application**:
   ```powershell
   dotnet run
   ```

3. **For Visual Studio**: Update the password in `Properties/launchSettings.json` first, then debug normally.

### Method 2: Manual Environment Variables

```powershell
$env:DB_HOST = "localhost"
$env:DB_PORT = "5432" 
$env:DB_NAME = "k8s_assignment"
$env:DB_USER = "postgres"
$env:DB_PASSWORD = "your_local_password"
dotnet run
```

### Method 2: Using .env File (with dotenv package)

1. **Install the dotenv package**:
   ```powershell
   dotnet add package DotNetEnv
   ```

2. **Copy the example file**:
   ```powershell
   copy .env.example .env
   ```

3. **Edit `.env`** with your local settings:
   ```
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=k8s_assignment_local
   DB_USER=myuser
   DB_PASSWORD=mypassword
   ```

4. **Update Program.cs** to load .env file:
   ```csharp
   DotNetEnv.Env.Load(); // Add this at the top of Program.cs
   ```

### Method 3: Visual Studio Launch Settings

Create or update `Properties/launchSettings.json`:

```json
{
  "profiles": {
    "k8s-assignment": {
      "commandName": "Project",
      "dotnetRunMessages": true,
      "launchBrowser": true,
      "launchUrl": "swagger",
      "applicationUrl": "https://localhost:7000;http://localhost:5000",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development",
        "DB_HOST": "localhost",
        "DB_PORT": "5432",
        "DB_NAME": "k8s_assignment",
        "DB_USER": "postgres",
        "DB_PASSWORD": "yourpassword"
      }
    }
  }
}
```

### Method 4: User Secrets (Most Secure for Local Development)

1. **Initialize user secrets**:
   ```powershell
   dotnet user-secrets init
   ```

2. **Set database configuration**:
   ```powershell
   dotnet user-secrets set "DB_HOST" "localhost"
   dotnet user-secrets set "DB_PORT" "5432"
   dotnet user-secrets set "DB_NAME" "k8s_assignment"
   dotnet user-secrets set "DB_USER" "postgres"
   dotnet user-secrets set "DB_PASSWORD" "yourpassword"
   ```

3. **The connection string in appsettings.json will automatically use these values.**

## Configuration Hierarchy

The configuration system will use values in this order (highest priority first):

1. **Environment Variables** (set by PowerShell script or system)
2. **User Secrets** (if configured)
3. **appsettings.Development.json**
4. **appsettings.json** (fallback defaults)

## Local Database Setup Options

### Option 1: Docker PostgreSQL
```powershell
# Run PostgreSQL in Docker
docker run --name postgres-local -e POSTGRES_DB=k8s_assignment -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=yourpassword -p 5432:5432 -d postgres:16

# Connect with default settings
.\setup-local-env.ps1
dotnet run
```

### Option 2: Local PostgreSQL Installation
1. Install PostgreSQL locally
2. Create database: `k8s_assignment`
3. Update environment variables if needed
4. Run the application

### Option 3: Different Database for Each Developer
```powershell
# Developer 1
$env:DB_NAME = "k8s_assignment_dev1"
$env:DB_PASSWORD = "dev1_password"

# Developer 2  
$env:DB_NAME = "k8s_assignment_dev2"
$env:DB_PASSWORD = "dev2_password"
```

## Testing Configuration

### Verify Environment Variables
```powershell
# Check current environment variables
Get-ChildItem Env: | Where-Object {$_.Name -like "DB_*"}
```

### Test Connection String
```powershell
# Run application and check logs for connection string
dotnet run --verbosity normal
```

## Switching Between Environments

### Local Development
```powershell
.\setup-local-env.ps1
dotnet run
```

### Test Against Kubernetes Database
```powershell
# Port forward to K8s database
kubectl port-forward svc/k8s-db 5432:5432

# Update environment to connect to K8s database
$env:DB_HOST = "localhost"  # Through port-forward
$env:DB_PASSWORD = "yourpassword"  # K8s password
dotnet run
```

## Troubleshooting

### Connection String Not Updated
- Check if environment variables are set: `echo $env:DB_HOST`
- Restart your IDE/terminal after setting environment variables
- Verify the syntax in appsettings.json: `${VARIABLE:defaultValue}`

### Environment Variables Not Available in IDE
- Restart Visual Studio/VS Code after running setup script
- Check launch settings in Visual Studio
- Use User Secrets for IDE-specific configuration

### Different Developers, Different Settings
- Each developer should have their own `.env` file (not committed to git)
- Use User Secrets for personal configuration
- Document the required environment variables in this README

## Best Practices

1. **Never commit passwords** to version control
2. **Use .env.example** as a template for required variables
3. **Add .env to .gitignore**
4. **Use User Secrets** for sensitive local development data
5. **Keep the same variable names** as Kubernetes ConfigMaps/Secrets
6. **Document required environment variables** for new team members
