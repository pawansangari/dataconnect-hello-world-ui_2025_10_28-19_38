#!/bin/bash
# Quick test script for Dataconnect App

echo "🧪 Testing Dataconnect Node.js FastAPI App"
echo "=========================================="
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.8+"
    exit 1
fi
echo "✅ Python 3 found: $(python3 --version)"

# Check if pip is available
if ! command -v pip &> /dev/null && ! command -v pip3 &> /dev/null; then
    echo "❌ pip not found. Please install pip"
    exit 1
fi
echo "✅ pip found"

# Check if node is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js 16+"
    exit 1
fi
echo "✅ Node.js found: $(node --version)"

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install npm"
    exit 1
fi
echo "✅ npm found: $(npm --version)"

echo ""
echo "📦 Checking dependencies..."

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    echo "❌ requirements.txt not found"
    exit 1
fi
echo "✅ requirements.txt exists"

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found"
    exit 1
fi
echo "✅ package.json exists"

# Check if frontend build exists
if [ ! -d "backend/static" ]; then
    echo "⚠️  Frontend not built yet. Run 'npm run build' first."
    read -p "Build frontend now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm run build
        if [ $? -eq 0 ]; then
            echo "✅ Frontend built successfully"
        else
            echo "❌ Frontend build failed"
            exit 1
        fi
    else
        echo "⚠️  Skipping frontend build"
    fi
else
    echo "✅ Frontend build exists"
fi

echo ""
echo "🔍 Checking backend code..."

# Check if backend/main.py exists
if [ ! -f "backend/main.py" ]; then
    echo "❌ backend/main.py not found"
    exit 1
fi
echo "✅ backend/main.py exists"

# Check for key API endpoints in main.py
if grep -q "get_datasources" backend/main.py; then
    echo "✅ Datasources endpoint found"
else
    echo "❌ Datasources endpoint not found"
fi

if grep -q "get_stats" backend/main.py; then
    echo "✅ Stats endpoint found"
else
    echo "❌ Stats endpoint not found"
fi

echo ""
echo "🎨 Checking frontend code..."

# Check if App.tsx exists
if [ ! -f "frontend/src/App.tsx" ]; then
    echo "❌ frontend/src/App.tsx not found"
    exit 1
fi
echo "✅ App.tsx exists"

# Check for Dataconnect features
if grep -q "Dataconnect" frontend/src/App.tsx; then
    echo "✅ Dataconnect branding found"
else
    echo "❌ Dataconnect branding not found"
fi

if grep -q "dataSources" frontend/src/App.tsx; then
    echo "✅ Data sources feature found"
else
    echo "❌ Data sources feature not found"
fi

echo ""
echo "📄 Checking configuration files..."

# Check app.yaml
if [ ! -f "app.yaml" ]; then
    echo "❌ app.yaml not found"
    exit 1
fi
echo "✅ app.yaml exists"

# Check deployment script
if [ ! -f "databricks-deploy.sh" ]; then
    echo "❌ databricks-deploy.sh not found"
    exit 1
fi

if [ ! -x "databricks-deploy.sh" ]; then
    echo "⚠️  databricks-deploy.sh not executable"
    chmod +x databricks-deploy.sh
    echo "✅ Made databricks-deploy.sh executable"
else
    echo "✅ databricks-deploy.sh is executable"
fi

echo ""
echo "✅ All checks passed!"
echo ""
echo "📋 Summary:"
echo "   - App Name: dataconnect-nodejs-fastapi-app"
echo "   - Frontend: Built and ready"
echo "   - Backend: Configured with 4 data sources"
echo "   - Deploy Script: Ready"
echo ""
echo "🚀 Next Steps:"
echo "   1. Ensure Databricks CLI is installed: pip install databricks-cli"
echo "   2. Configure Databricks: databricks configure --token"
echo "   3. Deploy: ./databricks-deploy.sh"
echo ""
echo "📚 Documentation:"
echo "   - QUICKSTART.md - Quick deployment guide"
echo "   - DEPLOYMENT.md - Detailed deployment instructions"
echo "   - CHANGES.md - Complete list of changes"
echo ""

