#!/bin/bash
# Complete Setup and Deployment Script

echo "🔧 Dataconnect App - Complete Setup and Deployment"
echo "===================================================="
echo ""

# Check Databricks CLI
if ! command -v databricks &> /dev/null; then
    echo "📦 Installing Databricks CLI..."
    pip install databricks-cli
    echo "✅ Databricks CLI installed"
else
    echo "✅ Databricks CLI already installed: $(databricks --version)"
fi

echo ""
echo "🔐 Checking Databricks authentication..."

# Test if already authenticated
if databricks workspace list /Workspace/Users/pawanpreet.sangari@databricks.com/ &> /dev/null; then
    echo "✅ Already authenticated!"
else
    echo "⚠️  Authentication not configured"
    echo ""
    echo "Please configure Databricks authentication:"
    echo ""
    read -p "Do you want to configure now? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Running: databricks configure --token"
        echo ""
        echo "You will need:"
        echo "  1. Your Databricks workspace URL (e.g., https://your-workspace.databricks.com)"
        echo "  2. A personal access token (generate in Databricks Settings > Developer)"
        echo ""
        databricks configure --token
        
        # Test authentication after configuration
        echo ""
        echo "Testing authentication..."
        if databricks workspace list /Workspace/Users/pawanpreet.sangari@databricks.com/ &> /dev/null; then
            echo "✅ Authentication successful!"
        else
            echo "❌ Authentication failed. Please check your credentials and try again."
            exit 1
        fi
    else
        echo ""
        echo "Please configure authentication manually:"
        echo "  databricks configure --token"
        echo ""
        echo "Then run this script again, or run: ./databricks-deploy.sh"
        exit 0
    fi
fi

echo ""
echo "📦 Checking Node.js dependencies..."
if [ ! -d "node_modules" ]; then
    echo "Installing Node.js dependencies..."
    npm install
else
    echo "✅ Node.js dependencies already installed"
fi

echo ""
echo "🏗️  Building frontend..."
npm run build

if [ ! -d "backend/static" ]; then
    echo "❌ Frontend build failed"
    exit 1
fi
echo "✅ Frontend built successfully"

echo ""
echo "🚀 Deploying to Databricks..."
echo ""

# Call the deployment script
./databricks-deploy.sh

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Setup and deployment completed successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. Go to your Databricks workspace"
    echo "  2. Navigate to Apps section"
    echo "  3. Create/update your app pointing to:"
    echo "     /Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app"
    echo "  4. Start your app"
    echo ""
else
    echo ""
    echo "❌ Deployment failed. Check the errors above."
    echo ""
    echo "For help, see SETUP_AUTH.md"
fi

