# 🛠️ DevOrchestrator

**DevOrchestrator** is an autonomous, multi-agent software development engine powered by **LangGraph** and **Groq LPU**. 

Unlike standard coding assistants that autocomplete snippets, DevOrchestrator functions as a **full-cycle software engineering team**. It accepts a high-level natural language prompt and autonomously orchestrates a pipeline of specialized agents (Planner, Architect, Coder) to plan, structure, and implement a complete, executable codebase.

---

## 🧠 System Architecture

DevOrchestrator is built on a **Stateful Graph Architecture**. It utilizes a shared state machine to pass context between agents, ensuring that architectural decisions made in the planning phase are strictly adhered to during implementation.

### 1. The Agent Workflow
The system uses a cyclical graph (`StateGraph`) with three specialized nodes:

* **Node A: The Planner (Product Manager)**
    * **Input:** Raw user prompt (e.g., "Build a Snake game in Python").
    * **Logic:** Analyzes requirements and generates a high-level **Plan**.
    * **Output:** A structured `Plan` object containing the project name, tech stack, and a list of required files with their purposes.

* **Node B: The Architect (Tech Lead)**
    * **Input:** The `Plan` object from Node A.
    * **Logic:** Decomposes the file list into granular **Implementation Tasks**. It determines dependencies (e.g., "utils.py must be written before main.py").
    * **Output:** A `TaskPlan` containing an ordered list of `ImplementationSteps`, ensuring strictly typed context for the coder.

* **Node C: The Coder (Software Engineer)**
    * **Input:** The `TaskPlan` and the current `CoderState`.
    * **Logic:** A recursive ReAct agent that loops through the task list. For each step, it:
        1.  Reads existing file context (if any).
        2.  Writes the necessary code to the file system.
        3.  Updates the `current_step_idx` in the state.
    * **Tools:** Direct file system access (`write_file`, `read_file`, `list_files`).

### 2. State Management & Schema Validation
Reliability is enforced via **Pydantic** models. Agents do not communicate via unstructured text; they communicate via strictly validated schemas:
* `Plan`: Enforces that every project has a defined tech stack and file list.
* `TaskPlan`: Ensures every coding step has a target file and explicit instructions.
* `CoderState`: Tracks the progress of the loop to prevent infinite recursion or skipped steps.

<div style="text-align: center;">
    <img src="resources/DevOrchestrator_diagram.png" alt="DevOrchestrator Architecture Diagram" width="90%"/>
</div>

---

## 🛠️ Tech Stack

* **Orchestration:** [LangGraph](https://github.com/langchain-ai/langgraph) (Cyclical State-Machine)
* **LLM Inference:** [Groq](https://groq.com/) (LPU Inference Engine for low-latency chain execution)
* **Validation:** [Pydantic](https://docs.pydantic.dev/) (Strict Output Parsing)
* **Environment:** Python 3.11+, UV (Package Management)

---

## 🚀 Getting Started

### Prerequisites
1.  **Install `uv`**: A fast Python package installer and resolver.
    [Installation Instructions](https://docs.astral.sh/uv/getting-started/installation/)
2.  **Groq API Key**: Required for high-speed inference.
    [Get API Key](https://console.groq.com/keys)

### Installation

1.  **Clone and Setup Environment**
    ```bash
    git clone [https://github.com/yourusername/DevOrchestrator.git](https://github.com/yourusername/DevOrchestrator.git)
    cd DevOrchestrator
    
    # Create virtual environment
    uv venv
    source .venv/bin/activate  # On Windows: .venv\Scripts\activate
    ```

2.  **Install Dependencies**
    ```bash
    uv pip install -r pyproject.toml
    ```

3.  **Configure Environment**
    Create a `.env` file in the root directory:
    ```ini
    GROQ_API_KEY=your_groq_api_key_here
    LANGCHAIN_TRACING_V2=true # Optional: For LangSmith debugging
    LANGCHAIN_API_KEY=your_langchain_key # Optional
    ```

### Usage

Run the main orchestration script:
```bash
python main.py

When prompted, enter your request. The system will initialize the graph and begin the **Planner -> Architect -> Coder** cycle.

**Artifact Output:**
All generated code is written to the `generated_project/` directory in your root folder.

---

## 🧪 Example Prompts

DevOrchestrator excels at creating multi-file projects. Try these:

* **Web App:** "Create a modern To-Do list application using HTML, CSS, and vanilla JavaScript with local storage persistence."
* **Backend API:** "Build a REST API using FastAPI for a book management system. Include a SQLite database connection and a Pydantic model for Books."
* **Data Tool:** "Write a Python script that reads a CSV file, calculates the mean and median of a 'price' column, and saves a summary report."

---

## 🛡️ Safety & Limitations

* **File System Access:** The Coder agent has write access to the `generated_project` directory. It is sandboxed to this directory to prevent accidental overwrites of system files.
* **Recursion Limit:** To prevent infinite loops during complex debugging, the graph has a default recursion limit (set to 100 steps).

---

## 🚀 Deploy to Vercel (Recommended)

Deploy your DevOrchestrator to Vercel and get a live URL in minutes!

### 🟢 Quick Deploy via Dashboard

1. **Push code to GitHub** (if not already)
   ```bash
   git add .
   git commit -m "Ready for Vercel"
   git push origin main
   ```

2. **Go to Vercel**
   - Visit: [vercel.com](https://vercel.com)
   - Sign up with GitHub (free)

3. **Import Project**
   - Click "Add New..." → "Project"
   - Select your DevOrchestrator repository
   - Click "Import"

4. **Add Environment Variable**
   - Go to "Environment Variables"
   - Add: `GROQ_API_KEY` = `your_groq_api_key_here`
   - Click "Deploy"

5. **Done!** Your app is live at: `https://your-app.vercel.app`

### 🖥️ Deploy via CLI

```bash
# Install Vercel CLI (if needed)
npm install -g vercel

# Or use the deployment script
./deploy-vercel.sh
```

📖 **Complete Guide**: See [VERCEL_DEPLOY.md](./VERCEL_DEPLOY.md) for detailed instructions, troubleshooting, and tips.

### Other Deployment Options:
- **Railway** - Easy, free tier
- **Fly.io** - Docker-native
- **Render** - Simple PaaS
- See [OTHER_DEPLOYMENT_OPTIONS.md](./OTHER_DEPLOYMENT_OPTIONS.md) for all options

### Web Interface

The project includes a FastAPI web server with a modern frontend:

```bash
# Start the web server
python app.py

# Visit http://localhost:8000
```

### Docker Deployment

```bash
# Build image
docker build -t dev-orchestrator .

# Run container
docker run -p 8000:8000 -e GROQ_API_KEY=your_key dev-orchestrator
```

### Detailed Deployment Guides

- 📖 **Quick Start**: [DEPLOY_QUICKSTART.md](./DEPLOY_QUICKSTART.md)
- 🎯 **For Recruiters**: [RECRUITER_DEPLOYMENT_GUIDE.md](./RECRUITER_DEPLOYMENT_GUIDE.md)
- 📚 **Complete Guide**: [DEPLOYMENT.md](./DEPLOYMENT.md)

---

## 📚 Additional Resources

- 🎯 **Portfolio Showcase**: [PORTFOLIO_SHOWCASE.md](./PORTFOLIO_SHOWCASE.md) - How to present this project to recruiters
- 📋 **Recruiter Checklist**: [RECRUITER_CHECKLIST.md](./RECRUITER_CHECKLIST.md) - Pre-interview checklist
- 🚀 **Quick Start**: [QUICKSTART.md](./QUICKSTART.md) - Get started in 5 minutes

---

Copyright © 2025 DevOrchestrator. All rights reserved.