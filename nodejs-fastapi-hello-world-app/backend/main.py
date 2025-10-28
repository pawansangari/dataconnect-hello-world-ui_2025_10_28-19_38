import os
import logging
from fastapi import FastAPI, HTTPException, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from typing import List, Dict, Any
from datetime import datetime
import random

# --- Logging Setup ---
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)

app = FastAPI(title="Dataconnect Node.js FastAPI App")

# --- Mock Data Sources ---
DATA_SOURCES = [
    {
        "id": "db1",
        "name": "Customer Database",
        "type": "PostgreSQL",
        "status": "connected",
        "last_sync": "2025-10-28T10:30:00Z",
        "records": 15420
    },
    {
        "id": "db2",
        "name": "Sales Analytics",
        "type": "Databricks SQL",
        "status": "connected",
        "last_sync": "2025-10-28T11:15:00Z",
        "records": 89234
    },
    {
        "id": "db3",
        "name": "Product Inventory",
        "type": "MongoDB",
        "status": "connected",
        "last_sync": "2025-10-28T09:45:00Z",
        "records": 3421
    },
    {
        "id": "db4",
        "name": "User Events Stream",
        "type": "Kafka",
        "status": "connected",
        "last_sync": "2025-10-28T11:20:00Z",
        "records": 456789
    }
]

# --- API Routes ---
@app.get("/api/hello")
async def hello():
    logger.info("Accessed /api/hello")
    return {"message": "Welcome to Dataconnect App!"}

@app.get("/api/health")
async def health_check():
    logger.info("Health check at /api/health")
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

@app.get("/api/datasources")
async def get_datasources():
    """Get all connected data sources"""
    logger.info("Data sources requested at /api/datasources")
    return {"datasources": DATA_SOURCES}

@app.get("/api/datasources/{datasource_id}")
async def get_datasource_details(datasource_id: str):
    """Get details for a specific data source"""
    logger.info(f"Data source details requested for: {datasource_id}")
    datasource = next((ds for ds in DATA_SOURCES if ds["id"] == datasource_id), None)
    if not datasource:
        raise HTTPException(status_code=404, detail="Data source not found")
    return datasource

@app.get("/api/datasources/{datasource_id}/data")
async def get_datasource_data(datasource_id: str):
    """Get sample data from a data source"""
    logger.info(f"Data requested from datasource: {datasource_id}")
    datasource = next((ds for ds in DATA_SOURCES if ds["id"] == datasource_id), None)
    if not datasource:
        raise HTTPException(status_code=404, detail="Data source not found")
    
    # Generate sample time-series data
    data_points = []
    for i in range(30):
        data_points.append({
            "x": i,
            "y": random.randint(10, 100) + (i * 5)
        })
    
    return {
        "datasource": datasource["name"],
        "data": data_points,
        "title": f"Data from {datasource['name']}",
        "x_title": "Time Period",
        "y_title": "Value"
    }

@app.get("/api/stats")
async def get_stats():
    """Get overall statistics"""
    logger.info("Stats requested at /api/stats")
    total_records = sum(ds["records"] for ds in DATA_SOURCES)
    connected_sources = len([ds for ds in DATA_SOURCES if ds["status"] == "connected"])
    
    return {
        "total_sources": len(DATA_SOURCES),
        "connected_sources": connected_sources,
        "total_records": total_records,
        "last_updated": datetime.now().isoformat()
    }

# --- Static Files Setup ---
static_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "static")
os.makedirs(static_dir, exist_ok=True)

app.mount("/", StaticFiles(directory=static_dir, html=True), name="static")

# --- Catch-all for React Routes ---
@app.get("/{full_path:path}")
async def serve_react(full_path: str):
    index_html = os.path.join(static_dir, "index.html")
    if os.path.exists(index_html):
        logger.info(f"Serving React frontend for path: /{full_path}")
        return FileResponse(index_html)
    logger.error("Frontend not built. index.html missing.")
    raise HTTPException(
        status_code=404,
        detail="Frontend not built. Please run 'npm run build' first."
    )