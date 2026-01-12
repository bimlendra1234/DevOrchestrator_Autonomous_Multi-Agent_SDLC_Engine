"""
Vercel serverless entry point for FastAPI app
"""
import sys
from pathlib import Path

# Add parent directory to path so we can import app
sys.path.insert(0, str(Path(__file__).parent.parent))

from app import app

# Export the app for Vercel
__all__ = ['app']
