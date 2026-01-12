"""
FastAPI server for DevOrchestrator with WebSocket support for real-time updates.
Provides REST API and Web UI for the multi-agent SDLC engine.
"""

import json
import logging
from contextlib import asynccontextmanager
from pathlib import Path
from typing import Optional

from fastapi import FastAPI, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
import asyncio

from agent.graph import agent

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Request/Response Models
class ProjectRequest(BaseModel):
    """Request model for project generation"""
    prompt: str
    recursion_limit: int = 100

class ProjectResponse(BaseModel):
    """Response model for project generation"""
    status: str
    project_name: Optional[str] = None
    files_generated: int = 0
    message: str

class HealthResponse(BaseModel):
    """Health check response"""
    status: str
    version: str = "1.0.0"

# Create FastAPI app
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Startup and shutdown events"""
    logger.info("Starting DevOrchestrator API Server")
    yield
    logger.info("Shutting down DevOrchestrator API Server")

app = FastAPI(
    title="DevOrchestrator API",
    description="Multi-agent autonomous SDLC engine",
    version="1.0.0",
    lifespan=lifespan
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Static files
frontend_path = Path(__file__).parent / "frontend"
if frontend_path.exists():
    app.mount("/static", StaticFiles(directory=str(frontend_path / "static")), name="static")

# ==================== Routes ====================

@app.get("/", response_class=HTMLResponse)
async def serve_frontend():
    """Serve the main frontend"""
    frontend_file = frontend_path / "index.html"
    if frontend_file.exists():
        return frontend_file.read_text()
    return "<h1>Welcome to DevOrchestrator API</h1>"

@app.get("/api/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    return HealthResponse(status="healthy")

@app.post("/api/generate", response_model=ProjectResponse)
async def generate_project(request: ProjectRequest):
    """
    Generate a new project based on the user prompt.
    
    Args:
        request: Project generation request with prompt and recursion limit
        
    Returns:
        ProjectResponse with generation status and details
    """
    try:
        logger.info(f"Received project generation request: {request.prompt}")
        
        # Invoke the agent with the user prompt
        result = agent.invoke(
            {"user_prompt": request.prompt},
            {"recursion_limit": request.recursion_limit}
        )
        
        logger.info("Project generation completed successfully")
        
        return ProjectResponse(
            status="success",
            message="Project generated successfully",
            files_generated=0  # You can count generated files here
        )
        
    except Exception as e:
        logger.error(f"Error generating project: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Error generating project: {str(e)}"
        )

@app.websocket("/ws/generate")
async def websocket_generate(websocket: WebSocket):
    """
    WebSocket endpoint for real-time project generation updates.
    Streams generation progress to the client.
    """
    await websocket.accept()
    try:
        while True:
            # Receive project prompt from client
            data = await websocket.receive_text()
            request_data = json.loads(data)
            prompt = request_data.get("prompt", "")
            recursion_limit = request_data.get("recursion_limit", 100)
            
            logger.info(f"WebSocket project generation: {prompt}")
            
            try:
                # Send progress update
                await websocket.send_json({
                    "type": "progress",
                    "message": "Starting project generation...",
                    "step": "initialization"
                })
                
                # Invoke the agent
                result = agent.invoke(
                    {"user_prompt": prompt},
                    {"recursion_limit": recursion_limit}
                )
                
                # Send completion message
                await websocket.send_json({
                    "type": "complete",
                    "status": "success",
                    "message": "Project generated successfully"
                })
                
            except Exception as e:
                await websocket.send_json({
                    "type": "error",
                    "message": f"Error: {str(e)}"
                })
                
    except WebSocketDisconnect:
        logger.info("WebSocket client disconnected")
    except Exception as e:
        logger.error(f"WebSocket error: {str(e)}", exc_info=True)

@app.get("/api/examples")
async def get_examples():
    """Get example prompts for the generator"""
    return {
        "examples": [
            {
                "title": "Todo Application",
                "description": "A simple task management application",
                "prompt": "Create a web-based todo application with add, edit, and delete functionality"
            },
            {
                "title": "Calculator",
                "description": "Basic calculator with arithmetic operations",
                "prompt": "Build a calculator app that can perform addition, subtraction, multiplication, and division"
            },
            {
                "title": "Weather App",
                "description": "Fetch and display weather information",
                "prompt": "Create a weather application that fetches current weather data and displays temperature, humidity, and forecast"
            },
            {
                "title": "Snake Game",
                "description": "Classic snake game",
                "prompt": "Implement a Snake game where the player controls a snake to eat food and avoid collisions"
            }
        ]
    }

@app.get("/api/generated-files")
async def get_generated_files():
    """Get list of files in the generated_project directory"""
    import os
    from pathlib import Path
    
    generated_dir = Path(__file__).parent / "generated_project"
    
    if not generated_dir.exists():
        return {
            "status": "no_files",
            "message": "No projects generated yet",
            "files": []
        }
    
    files = []
    try:
        for file_path in sorted(generated_dir.rglob("*")):
            if file_path.is_file():
                rel_path = file_path.relative_to(generated_dir)
                files.append({
                    "name": file_path.name,
                    "path": str(rel_path),
                    "size": file_path.stat().st_size
                })
    except Exception as e:
        logger.error(f"Error listing files: {e}")
    
    return {
        "status": "success",
        "files": files,
        "count": len(files)
    }

@app.get("/api/file-content/{file_path:path}")
async def get_file_content(file_path: str):
    """Get content of a specific file from generated_project"""
    from pathlib import Path
    
    generated_dir = Path(__file__).parent / "generated_project"
    full_path = (generated_dir / file_path).resolve()
    
    # Security check: ensure the file is within generated_project
    try:
        full_path.relative_to(generated_dir.resolve())
    except ValueError:
        raise HTTPException(status_code=403, detail="Access denied")
    
    if not full_path.exists():
        raise HTTPException(status_code=404, detail="File not found")
    
    if not full_path.is_file():
        raise HTTPException(status_code=400, detail="Path is not a file")
    
    try:
        with open(full_path, 'r', encoding='utf-8') as f:
            content = f.read()
        return {
            "status": "success",
            "name": full_path.name,
            "path": str(full_path.relative_to(generated_dir)),
            "content": content,
            "size": len(content),
            "lines": len(content.split('\n'))
        }
    except UnicodeDecodeError:
        return {
            "status": "error",
            "message": "File is binary or not readable as text"
        }
    except Exception as e:
        logger.error(f"Error reading file: {e}")
        raise HTTPException(status_code=500, detail=f"Error reading file: {str(e)}")

@app.get("/api/file-tree")
async def get_file_tree():
    """Get file tree structure of generated_project"""
    from pathlib import Path
    
    generated_dir = Path(__file__).parent / "generated_project"
    
    if not generated_dir.exists():
        return {"status": "no_files", "tree": {}}
    
    def build_tree(path):
        """Recursively build tree structure"""
        tree = {}
        try:
            for item in sorted(path.iterdir()):
                if item.name.startswith('.'):
                    continue
                if item.is_dir():
                    tree[item.name] = build_tree(item)
                else:
                    tree[item.name] = {"type": "file", "size": item.stat().st_size}
        except Exception as e:
            logger.error(f"Error building tree: {e}")
        return tree
    
    return {
        "status": "success",
        "tree": build_tree(generated_dir)
    }

# ==================== Error Handlers ====================

@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    """Custom HTTP exception handler"""
    logger.error(f"HTTP Exception: {exc.detail}")
    return {
        "status": "error",
        "message": exc.detail,
        "status_code": exc.status_code
    }

if __name__ == "__main__":
    import uvicorn
    import os
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(
        "app:app",  # Use import string for better compatibility
        host="0.0.0.0",
        port=port,
        log_level="info",
        reload=False  # Disable reload for background processes
    )
