# Quick Start - Deploy Dataconnect App to Databricks

## 🚀 Ready to Deploy!

Your Dataconnect Node.js FastAPI App is built and ready for deployment to Databricks Apps.

## Prerequisites Checklist

- [x] ✅ Frontend built successfully (in `backend/static/`)
- [x] ✅ All dependencies configured
- [x] ✅ Deployment script ready (`databricks-deploy.sh`)
- [ ] ⚠️  Databricks CLI installed and configured

## Step 1: Install Databricks CLI (if not already installed)

```bash
pip install databricks-cli
```

## Step 2: Configure Databricks CLI

```bash
databricks configure --token
```

When prompted, enter:
- **Databricks Host**: Your workspace URL (e.g., `https://your-workspace.databricks.com`)
- **Token**: Your personal access token

## Step 3: Deploy to Databricks

### Option A: Automated Deployment (Recommended)

```bash
cd "/Users/pawanpreet.sangari/Downloads/hello-world-ui_2025_10_28-19_38 2/hello-world-ui_2025_10_28-19_38/nodejs-fastapi-hello-world-app"
./databricks-deploy.sh
```

### Option B: Manual Deployment

```bash
# Navigate to the app directory
cd "/Users/pawanpreet.sangari/Downloads/hello-world-ui_2025_10_28-19_38 2/hello-world-ui_2025_10_28-19_38/nodejs-fastapi-hello-world-app"

# Create the directory in Databricks workspace
databricks workspace mkdirs /Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app

# Upload the app
databricks workspace export-dir . /Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app --overwrite
```

## Step 4: Create/Update App in Databricks

1. **Open Databricks Workspace**
   - Navigate to your Databricks workspace in a web browser

2. **Go to Apps Section**
   - Click on "Apps" in the left sidebar
   - Or navigate to: `/apps`

3. **Create New App** (or update existing)
   - Click "Create App" button
   - Or select existing "dataconnect-nodejs-fastapi-app" to update

4. **Configure App**
   - **Name**: `dataconnect-nodejs-fastapi-app`
   - **Source Path**: `/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app`
   - **Compute**: Select appropriate cluster size (recommended: Small or Medium)

5. **Start the App**
   - Click "Start" or "Restart" button
   - Wait for app to initialize (usually 1-2 minutes)

## Step 5: Access Your App

Once the app is running, you'll receive a URL like:
```
https://your-workspace.databricks.com/apps/your-app-id
```

### Test the Following:

1. **Homepage**: Should display the Dataconnect dashboard
2. **Statistics Cards**: Shows total sources (4), connected sources (4), total records
3. **Data Source Cards**: Click any card to visualize its data
4. **API Documentation**: Visit `<app-url>/docs` for interactive API docs

## API Endpoints Reference

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/hello` | GET | Welcome message |
| `/api/health` | GET | Health check with timestamp |
| `/api/datasources` | GET | List all data sources |
| `/api/datasources/{id}` | GET | Get specific data source details |
| `/api/datasources/{id}/data` | GET | Get sample data from source |
| `/api/stats` | GET | Overall statistics |
| `/docs` | GET | Interactive API documentation |

## Data Sources Included

The app comes with 4 mock data sources:

1. **Customer Database** (PostgreSQL) - 15,420 records
2. **Sales Analytics** (Databricks SQL) - 89,234 records
3. **Product Inventory** (MongoDB) - 3,421 records
4. **User Events Stream** (Kafka) - 456,789 records

## Troubleshooting

### "databricks: command not found"
```bash
pip install databricks-cli
databricks configure --token
```

### "Permission denied" on deployment script
```bash
chmod +x databricks-deploy.sh
```

### Frontend not loading
```bash
# Rebuild the frontend
npm run build

# Verify static files exist
ls -la backend/static/
```

### App fails to start
- Check Databricks Apps logs for errors
- Verify `requirements.txt` dependencies
- Ensure Python 3.8+ is available
- Check compute resource availability

## File Locations

```
Workspace Path:
/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app

Local Path:
/Users/pawanpreet.sangari/Downloads/hello-world-ui_2025_10_28-19_38 2/hello-world-ui_2025_10_28-19_38/nodejs-fastapi-hello-world-app
```

## What's Changed from Hello World?

✨ **New Features:**
- Multi-source data connectivity dashboard
- Interactive data visualization
- Statistics overview
- 4 mock data sources with status indicators
- Modern glassmorphism UI design
- Enhanced API with 6 endpoints
- Click-to-explore data sources

📝 **Updated Files:**
- `backend/main.py` - Enhanced with data source APIs
- `frontend/src/App.tsx` - Complete UI overhaul
- `frontend/src/App.css` - Modern styling
- `package.json` - Renamed to dataconnect-nodejs-fastapi-app
- `README` - Updated documentation

🆕 **New Files:**
- `databricks-deploy.sh` - Automated deployment
- `DEPLOYMENT.md` - Comprehensive deployment guide
- `CHANGES.md` - Detailed change log
- `QUICKSTART.md` - This file

## Next Steps After Deployment

1. **Customize Data Sources**: Replace mock data with real connections
2. **Add Authentication**: Implement user authentication
3. **Monitor Performance**: Set up logging and monitoring
4. **Scale Resources**: Adjust compute based on usage
5. **Add Features**: Extend with additional data sources and visualizations

## Support & Documentation

- **Full Deployment Guide**: See `DEPLOYMENT.md`
- **Complete Changes**: See `CHANGES.md`
- **API Documentation**: Visit `<app-url>/docs` after deployment
- **Main README**: See `README` file

---

## 📋 Deployment Commands Summary

```bash
# Quick deployment (all in one)
cd "/Users/pawanpreet.sangari/Downloads/hello-world-ui_2025_10_28-19_38 2/hello-world-ui_2025_10_28-19_38/nodejs-fastapi-hello-world-app"
./databricks-deploy.sh
```

**That's it! Your Dataconnect app should now be running on Databricks Apps! 🎉**

