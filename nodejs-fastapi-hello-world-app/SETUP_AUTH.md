# Databricks Authentication Setup Guide

## Issue: Deployment Stuck at Step 2

If your deployment is stuck at "Step 2: Deploying to Databricks", it's likely because the Databricks CLI needs authentication credentials.

## Quick Fix

### Option 1: Interactive Configuration (Easiest)

```bash
databricks configure --token
```

When prompted, enter:
1. **Databricks Host**: Your workspace URL
   - Format: `https://your-workspace.databricks.com`
   - Example: `https://dbc-a1234567-89ab.cloud.databricks.com`
   
2. **Token**: Your personal access token
   - You'll need to generate this in Databricks first (see below)

### Option 2: Environment Variables

Set these in your terminal:

```bash
export DATABRICKS_HOST="https://your-workspace.databricks.com"
export DATABRICKS_TOKEN="your-personal-access-token"
```

Then re-run the deployment script.

### Option 3: Configuration File

Create or edit `~/.databrickscfg`:

```ini
[DEFAULT]
host = https://your-workspace.databricks.com
token = your-personal-access-token
```

## How to Generate a Personal Access Token

1. **Log into Databricks Workspace**
   - Go to your Databricks workspace in a web browser

2. **Open User Settings**
   - Click on your user icon (top right)
   - Select "User Settings" or "Settings"

3. **Generate Token**
   - Navigate to "Developer" or "Access tokens" tab
   - Click "Generate new token"
   - Give it a name (e.g., "CLI Access")
   - Set expiration (optional, but recommended)
   - Click "Generate"

4. **Copy the Token**
   - ⚠️ **IMPORTANT**: Copy the token immediately!
   - You won't be able to see it again after closing the dialog
   - Store it securely

5. **Use the Token**
   - Paste it when prompted by `databricks configure --token`
   - Or use it in environment variables or config file

## Verify Authentication

Test that authentication is working:

```bash
# List your workspace files
databricks workspace list /Workspace/Users/pawanpreet.sangari@databricks.com/

# If successful, you should see a list of files/folders
# If it fails, check your credentials
```

## Troubleshooting

### Error: "cannot configure default credentials"

**Solution**: You need to run `databricks configure --token` first.

### Error: "authentication failed" or "401 Unauthorized"

**Solution**: 
- Your token may be expired - generate a new one
- Your token may be incorrect - double-check it
- Re-run `databricks configure --token` with the new token

### Error: "permission denied"

**Solution**:
- Make sure you have access to the workspace
- Check that your user has permission to create/write to `/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/`
- Contact your workspace admin if needed

### Error: "host not found" or "connection timeout"

**Solution**:
- Check your workspace URL is correct (include https://)
- Ensure you have network connectivity
- Check if you're behind a firewall/VPN that blocks Databricks

## After Setting Up Authentication

Once authentication is configured, re-run the deployment:

```bash
cd "/Users/pawanpreet.sangari/Downloads/hello-world-ui_2025_10_28-19_38 2/hello-world-ui_2025_10_28-19_38/nodejs-fastapi-hello-world-app"
./databricks-deploy.sh
```

## Updated Deployment Script

I've updated the `databricks-deploy.sh` script to:
- ✅ Check if Databricks CLI is installed
- ✅ Test authentication before deploying
- ✅ Provide clear error messages
- ✅ Use the correct commands for newer CLI (v0.262.0)
- ✅ Give helpful troubleshooting hints

## Security Best Practices

1. **Never commit tokens** to git repositories
2. **Use token expiration** - set tokens to expire after a reasonable time
3. **Rotate tokens regularly** - generate new tokens periodically
4. **Use environment variables** in CI/CD pipelines instead of config files
5. **Limit token scope** if possible (some platforms allow scoped tokens)

## Alternative: Using Databricks Apps UI

If you prefer not to use the CLI, you can deploy manually:

1. **Zip the application**:
   ```bash
   cd "/Users/pawanpreet.sangari/Downloads/hello-world-ui_2025_10_28-19_38 2/hello-world-ui_2025_10_28-19_38/nodejs-fastapi-hello-world-app"
   zip -r dataconnect-app.zip . -x "node_modules/*" -x ".git/*"
   ```

2. **Upload via Databricks UI**:
   - Go to Workspace in Databricks
   - Navigate to `/Workspace/Users/pawanpreet.sangari@databricks.com/databricks_apps/`
   - Create folder: `dataconnect-nodejs-fastapi-app`
   - Upload the files manually or use the import feature

3. **Create App**:
   - Go to Apps section
   - Create new app
   - Point to the uploaded directory

## Need Help?

If you're still stuck after trying these solutions:

1. Check Databricks CLI version: `databricks --version`
2. Check authentication status: `databricks workspace list /Workspace/Users/`
3. Review Databricks docs: https://docs.databricks.com/en/dev-tools/auth.html
4. Contact your Databricks workspace administrator

---

**Quick Commands Reference:**

```bash
# Configure CLI
databricks configure --token

# Test connection
databricks workspace list /Workspace/Users/pawanpreet.sangari@databricks.com/

# Deploy app
./databricks-deploy.sh

# Check CLI version
databricks --version
```

