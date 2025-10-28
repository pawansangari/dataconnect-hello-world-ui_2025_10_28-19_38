# 🔧 Deployment Fix - Stuck at Step 2

## Problem
Deployment was stuck at "Step 2: Deploying to Databricks" because the Databricks CLI needs authentication credentials.

## ✅ Solution - Quick Fix

### Option 1: Use the New All-in-One Script (Easiest)

```bash
cd "/Users/pawanpreet.sangari/Downloads/hello-world-ui_2025_10_28-19_38 2/hello-world-ui_2025_10_28-19_38/nodejs-fastapi-hello-world-app"
./setup-and-deploy.sh
```

This script will:
- Check if Databricks CLI is installed
- Test authentication (and prompt you to configure if needed)
- Build the frontend
- Deploy to Databricks

### Option 2: Configure Authentication Manually

**Step 1: Configure Databricks CLI**
```bash
databricks configure --token
```

When prompted:
- **Databricks Host**: Enter your workspace URL
  - Example: `https://your-workspace.databricks.com`
  - Or: `https://dbc-a1234567-89ab.cloud.databricks.com`
  
- **Token**: Enter your personal access token
  - Generate in Databricks: User Settings > Developer > Access Tokens > Generate New Token

**Step 2: Test Authentication**
```bash
databricks workspace list /Workspace/Users/pawanpreet.sangari@databricks.com/
```

If this works, you'll see a list of files. If not, re-check your credentials.

**Step 3: Deploy**
```bash
./databricks-deploy.sh
```

## What Changed

I've updated the deployment to fix the issue:

1. **Updated `databricks-deploy.sh`**
   - Now checks authentication before deploying
   - Uses correct commands for newer CLI version (v0.262.0)
   - Provides clear error messages
   - Better error handling

2. **Created `setup-and-deploy.sh`**
   - All-in-one script that handles everything
   - Interactive authentication setup
   - Automatic dependency installation

3. **Created `SETUP_AUTH.md`**
   - Complete authentication guide
   - Step-by-step token generation
   - Troubleshooting tips

## Generate a Personal Access Token

If you don't have a token yet:

1. **Open Databricks Workspace** in your browser
2. Click **User Icon** (top right) → **User Settings**
3. Go to **Developer** tab → **Access Tokens**
4. Click **Generate New Token**
5. Give it a name: `CLI Access`
6. Click **Generate**
7. **Copy the token** (you can't see it again!)
8. Use it when running `databricks configure --token`

## Quick Test

After configuration, test everything works:

```bash
# Test 1: Check CLI version
databricks --version
# Should show: Databricks CLI v0.262.0

# Test 2: Test authentication
databricks workspace list /Workspace/Users/pawanpreet.sangari@databricks.com/
# Should list files in your workspace

# Test 3: Deploy
./databricks-deploy.sh
# Should complete successfully
```

## Common Errors & Fixes

### Error: "cannot configure default credentials"
**Fix**: Run `databricks configure --token`

### Error: "401 Unauthorized"
**Fix**: Token is invalid or expired - generate a new token

### Error: "permission denied"
**Fix**: Check you have access to create files in the deployment path

### Stuck again at Step 2?
**Fix**: 
```bash
# Check if authentication is actually working
databricks workspace list /Workspace/Users/

# If that fails, reconfigure
databricks configure --token

# Try deployment again
./databricks-deploy.sh
```

## Files Updated

- ✅ `databricks-deploy.sh` - Fixed and improved
- ✨ `setup-and-deploy.sh` - New all-in-one script
- ✨ `SETUP_AUTH.md` - Complete auth guide
- ✨ `DEPLOYMENT_FIX.md` - This file

## Next Steps

1. **Configure authentication** (if not done):
   ```bash
   databricks configure --token
   ```

2. **Run deployment**:
   ```bash
   ./setup-and-deploy.sh
   ```
   Or:
   ```bash
   ./databricks-deploy.sh
   ```

3. **Create app in Databricks UI**:
   - Go to Apps section
   - Create new app
   - Source: `/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/dataconnect-nodejs-fastapi-app`
   - Start app

## Need More Help?

See these files:
- `SETUP_AUTH.md` - Authentication setup guide
- `DEPLOYMENT.md` - Full deployment documentation
- `QUICKSTART.md` - Quick start guide

---

**TL;DR**: Run `databricks configure --token`, enter your workspace URL and token, then run `./databricks-deploy.sh` again.

