# ✅ Import Error Fixed!

The error `ModuleNotFoundError: No module named 'langchain.globals'` has been fixed.

## What Was Changed

In `agent/graph.py`, I replaced:
```python
from langchain.globals import set_verbose, set_debug
set_debug(True)
set_verbose(True)
```

With:
```python
import os
os.environ.setdefault("LANGCHAIN_VERBOSE", "true")
os.environ.setdefault("LANGCHAIN_DEBUG", "true")
```

This uses environment variables instead, which is more compatible across LangChain versions.

---

## 🚀 Now Try Running Again

Make sure your virtual environment is activated and dependencies are installed:

```bash
# Activate virtual environment
source venv/bin/activate

# Make sure dependencies are installed
pip install -r requirements.txt

# Run the app
python app.py
```

---

## ✅ The Fix

The import error is now fixed. The app should start successfully!

If you see any other errors, let me know.

