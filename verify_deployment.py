#!/usr/bin/env python3
"""
Verify deployment package completeness.
Run this to ensure all files are in place for recruitment showcase.
"""

import os
from pathlib import Path
from typing import List, Tuple

class DeploymentChecker:
    """Check if DevOrchestrator deployment package is complete"""
    
    def __init__(self, root_path: str = "."):
        self.root = Path(root_path)
        self.checks: List[Tuple[str, bool]] = []
    
    def check_file_exists(self, file_path: str, description: str) -> bool:
        """Check if a file exists"""
        full_path = self.root / file_path
        exists = full_path.exists()
        self.checks.append((f"✓ {description}" if exists else f"✗ {description}", exists))
        return exists
    
    def check_directory_exists(self, dir_path: str, description: str) -> bool:
        """Check if a directory exists"""
        full_path = self.root / dir_path
        exists = full_path.is_dir()
        self.checks.append((f"✓ {description}" if exists else f"✗ {description}", exists))
        return exists
    
    def run_checks(self):
        """Run all deployment checks"""
        print("\n" + "="*60)
        print("DevOrchestrator Deployment Package Verification")
        print("="*60 + "\n")
        
        # Application files
        print("📦 Application Files:")
        self.check_file_exists("app.py", "FastAPI application")
        self.check_file_exists("main.py", "CLI entry point")
        self.check_file_exists("config.py", "Configuration module")
        
        # Configuration
        print("\n⚙️ Configuration Files:")
        self.check_file_exists("Dockerfile", "Docker configuration")
        self.check_file_exists("docker-compose.yml", "Docker Compose setup")
        self.check_file_exists("nginx.conf", "Nginx reverse proxy config")
        self.check_file_exists(".env.example", "Environment template")
        self.check_file_exists("requirements.txt", "Python dependencies")
        
        # Documentation
        print("\n📚 Documentation:")
        self.check_file_exists("README.md", "Project README")
        self.check_file_exists("DETAILED_README.md", "Detailed README")
        self.check_file_exists("DEPLOYMENT.md", "Deployment guide")
        self.check_file_exists("QUICKSTART.md", "Quick start guide")
        self.check_file_exists("PORTFOLIO_SHOWCASE.md", "Portfolio presentation guide")
        
        # Frontend
        print("\n🎨 Frontend Files:")
        self.check_file_exists("frontend/index.html", "Main HTML page")
        self.check_file_exists("frontend/static/styles.css", "CSS styles")
        self.check_file_exists("frontend/static/script.js", "JavaScript logic")
        
        # Agent system
        print("\n🤖 Agent System:")
        self.check_directory_exists("agent", "Agent module")
        self.check_file_exists("agent/__init__.py", "Agent package init")
        self.check_file_exists("agent/graph.py", "LangGraph orchestration")
        self.check_file_exists("agent/states.py", "Pydantic state models")
        self.check_file_exists("agent/prompts.py", "LLM prompts")
        self.check_file_exists("agent/tools.py", "File system tools")
        
        # CI/CD
        print("\n🔄 CI/CD Pipeline:")
        self.check_file_exists(".github/workflows/ci-cd.yml", "GitHub Actions workflow")
        self.check_file_exists("deploy.sh", "Deployment script")
        
        # Print summary
        print("\n" + "="*60)
        completed = sum(1 for _, passed in self.checks if passed)
        total = len(self.checks)
        
        for check_name, passed in self.checks:
            print(check_name)
        
        print("\n" + "="*60)
        print(f"Completion: {completed}/{total} ({100*completed//total}%)")
        print("="*60 + "\n")
        
        if completed == total:
            print("✅ All deployment files present! You're ready to showcase.")
            print("\n🚀 Next steps:")
            print("1. Review PORTFOLIO_SHOWCASE.md for interview talking points")
            print("2. Deploy to AWS/GCP: ./deploy.sh aws  or  ./deploy.sh gcp")
            print("3. Share the live URL with recruiters")
            print("4. Follow QUICKSTART.md for local testing")
        else:
            print("⚠️  Some files are missing. Please create them before deployment.")
        
        return completed == total

def main():
    """Run deployment checks"""
    checker = DeploymentChecker()
    success = checker.run_checks()
    exit(0 if success else 1)

if __name__ == "__main__":
    main()
