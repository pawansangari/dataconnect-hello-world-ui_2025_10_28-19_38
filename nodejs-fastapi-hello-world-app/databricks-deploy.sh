#!/bin/bash
# Databricks App Deployment Script for Dataconnect Node.js FastAPI App

set -e

# Configuration
APP_NAME="dataconnect-nodejs-fastapi-app"
DEPLOY_PATH="/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps"
FULL_DEPLOY_PATH="${DEPLOY_PATH}/${APP_NAME}"

echo "🚀 Deploying Dataconnect Node.js FastAPI App to Databricks"
echo "============================================================"

# Step 1: Build the frontend
echo ""
echo "📦 Step 1: Building frontend..."
npm run build

# Step 2: Verify build completed
if [ ! -d "backend/static" ]; then
    echo "❌ Error: Frontend build failed. backend/static directory not found."
    exit 1
fi
echo "✅ Frontend build complete"

# Step 3: Deploy to Databricks using Databricks CLI
echo ""
echo "📤 Step 2: Deploying to Databricks..."
echo "Target: ${FULL_DEPLOY_PATH}"

# Create the deployment directory if it doesn't exist
databricks workspace mkdirs "${FULL_DEPLOY_PATH}" 2>/dev/null || true

# Copy the entire app to Databricks workspace
databricks workspace export-dir . "${FULL_DEPLOY_PATH}" --overwrite

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Deployment Information:"
echo "   - App Name: ${APP_NAME}"
echo "   - Location: ${FULL_DEPLOY_PATH}"
echo "   - API Documentation: <app-url>/docs"
echo ""
echo "🔧 Next Steps:"
echo "   1. Navigate to Databricks Apps in your workspace"
echo "   2. Create or update your app configuration"
echo "   3. Set the app source to: ${FULL_DEPLOY_PATH}"
echo "   4. Start or restart your app"
echo ""
echo "📚 View API documentation at: <your-app-url>/docs"

