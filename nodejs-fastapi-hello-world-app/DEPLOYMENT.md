# Deployment Guide for Dataconnect Node.js FastAPI App

This guide explains how to deploy the Dataconnect Node.js FastAPI App to Databricks Apps.

## Prerequisites

1. **Databricks CLI** installed and configured
   ```bash
   pip install databricks-cli
   databricks configure --token
   ```

2. **Node.js** (v16 or higher) and **npm** installed
   ```bash
   node --version
   npm --version
   ```

3. **Python** (3.8 or higher) and **pip** installed
   ```bash
   python --version
   pip --version
   ```

## Deployment Steps

### Option 1: Using the Deployment Script (Recommended)

1. **Make the deployment script executable:**
   ```bash
   chmod +x databricks-deploy.sh
   ```

2. **Run the deployment script:**
   ```bash
   ./databricks-deploy.sh
   ```

   This script will:
   - Build the React frontend
   - Package the application
   - Deploy to Databricks workspace at:
     `/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app`

### Option 2: Manual Deployment

1. **Install dependencies:**
   ```bash
   # Install Node.js dependencies
   npm install
   
   # Install Python dependencies
   pip install -r requirements.txt
   ```

2. **Build the frontend:**
   ```bash
   npm run build
   ```

3. **Deploy to Databricks workspace:**
   ```bash
   # Create the deployment directory
   databricks workspace mkdirs /Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app
   
   # Upload the app files
   databricks workspace export-dir . /Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app --overwrite
   ```

4. **Create or update Databricks App:**
   - Go to Databricks workspace
   - Navigate to **Apps** section
   - Click **Create App** or select existing app
   - Set the source path to:
     `/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app`
   - Configure compute resources as needed
   - Start the app

## Application Configuration

### App.yaml
The `app.yaml` file is already configured with:
```yaml
command: ["uvicorn", "backend.main:app"]
```

This tells Databricks Apps to start the FastAPI backend, which automatically:
- Serves the React frontend from `/backend/static/`
- Exposes API endpoints at `/api/*`
- Provides API documentation at `/docs`

### Environment Variables
The app automatically uses:
- `DATABRICKS_APP_PORT` - Set by Databricks Apps (default: 8080)

## Deployment Location

**Workspace Path:**
```
/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app
```

## Verifying Deployment

1. **Check App Status:**
   - Navigate to Apps in Databricks workspace
   - Verify the app is running

2. **Access the Application:**
   - Open the app URL provided by Databricks Apps
   - You should see the Dataconnect dashboard

3. **Test API Endpoints:**
   - Visit `<app-url>/docs` for interactive API documentation
   - Test endpoints:
     - `/api/hello` - Welcome message
     - `/api/datasources` - List data sources
     - `/api/stats` - Overall statistics

## Troubleshooting

### Frontend Not Loading
- Ensure `npm run build` completed successfully
- Verify `backend/static/` directory exists and contains built files
- Check app logs for errors

### API Endpoints Not Working
- Verify Python dependencies are installed
- Check `requirements.txt` is included in deployment
- Review backend logs in Databricks Apps console

### Build Failures
```bash
# Clean and rebuild
rm -rf backend/static node_modules
npm install
npm run build
```

### Permission Issues
- Ensure you have write access to the deployment path
- Verify Databricks CLI is configured correctly:
  ```bash
  databricks workspace ls /Workspace/Users/pawanpreet.sangari@databricks.com/
  ```

## Updating the App

To update an existing deployment:

1. **Make your changes** to the code
2. **Rebuild the frontend:**
   ```bash
   npm run build
   ```
3. **Redeploy:**
   ```bash
   ./databricks-deploy.sh
   ```
4. **Restart the app** in Databricks Apps console

## App Features

Once deployed, your app will provide:

- **Dashboard** with statistics on connected data sources
- **Data Source Cards** showing connection status and record counts
- **Interactive Charts** for data visualization
- **RESTful API** with OpenAPI documentation
- **Mock Data Sources:**
  - Customer Database (PostgreSQL)
  - Sales Analytics (Databricks SQL)
  - Product Inventory (MongoDB)
  - User Events Stream (Kafka)

## Support

For issues or questions:
1. Check Databricks Apps logs
2. Review API documentation at `/docs`
3. Verify all dependencies are installed
4. Ensure deployment path permissions are correct

## Next Steps

After successful deployment:
1. Customize data sources to connect to real databases
2. Add authentication if needed
3. Configure compute resources based on usage
4. Set up monitoring and alerts
5. Add more data visualization features

