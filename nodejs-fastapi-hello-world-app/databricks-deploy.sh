#!/bin/bash
# Databricks App Deployment Script for Dataconnect Node.js FastAPI App

set -e

# Configuration
APP_NAME="dataconnect-nodejs-fastapi-app"
DEPLOY_PATH="/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps"
FULL_DEPLOY_PATH="${DEPLOY_PATH}/${APP_NAME}"

echo "🚀 Deploying Dataconnect Node.js FastAPI App to Databricks"
echo "============================================================"

# Check if Databricks CLI is installed
if ! command -v databricks &> /dev/null; then
    echo "❌ Error: Databricks CLI is not installed."
    echo "   Install it with: pip install databricks-cli"
    exit 1
fi

echo "✅ Databricks CLI found: $(databricks --version)"

# Test authentication
echo ""
echo "🔐 Testing Databricks authentication..."
if ! databricks workspace list /Workspace/Users/pawanpreet.sangari@databricks.com/ &> /dev/null; then
    echo "❌ Error: Databricks authentication not configured."
    echo ""
    echo "Please configure authentication using one of these methods:"
    echo ""
    echo "Option 1: Using Databricks profile (recommended)"
    echo "  databricks configure --token"
    echo "  Then enter your workspace URL and personal access token"
    echo ""
    echo "Option 2: Using environment variables"
    echo "  export DATABRICKS_HOST='https://your-workspace.databricks.com'"
    echo "  export DATABRICKS_TOKEN='your-personal-access-token'"
    echo ""
    echo "Option 3: Using configuration file"
    echo "  Create ~/.databrickscfg with:"
    echo "  [DEFAULT]"
    echo "  host = https://your-workspace.databricks.com"
    echo "  token = your-personal-access-token"
    echo ""
    echo "For more info: https://docs.databricks.com/en/dev-tools/auth.html"
    exit 1
fi

echo "✅ Authentication successful"

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
echo "Creating workspace directory..."
databricks workspace mkdirs "${FULL_DEPLOY_PATH}" 2>/dev/null || true

# Upload the app to Databricks workspace
# Note: Using import-dir for the new CLI (not export-dir)
echo "Uploading files to Databricks workspace..."
databricks workspace import-dir . "${FULL_DEPLOY_PATH}" --overwrite

if [ $? -eq 0 ]; then
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
else
    echo ""
    echo "❌ Deployment failed. Please check the error messages above."
    echo ""
    echo "Common issues:"
    echo "  - Authentication expired: Run 'databricks configure --token' again"
    echo "  - Permission denied: Check your workspace access permissions"
    echo "  - Path doesn't exist: Verify the deployment path is correct"
    exit 1
fi
