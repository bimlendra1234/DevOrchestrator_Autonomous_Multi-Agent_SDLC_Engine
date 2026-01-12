"""
Vercel serverless entry point for FastAPI app
"""
import sys
import os
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

# Initialize before importing app
os.environ.setdefault("LANGCHAIN_VERBOSE", "false")
os.environ.setdefault("LANGCHAIN_DEBUG", "false")

try:
    from app import app
except Exception as e:
    print(f"Error importing app: {e}")
    import traceback
    traceback.print_exc()
    raise

# Export the app for Vercel
__all__ = ['app']


# Export the app for Vercel
__all__ = ['app']
