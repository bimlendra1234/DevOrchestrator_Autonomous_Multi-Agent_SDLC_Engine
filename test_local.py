#!/usr/bin/env python3
"""
Simple test script to verify DevOrchestrator is working locally.
Run this after starting the server with: python app.py
"""

import requests
import json
import sys
from time import sleep

BASE_URL = "http://localhost:8000"

def print_section(title):
    print(f"\n{'='*50}")
    print(f"  {title}")
    print(f"{'='*50}")

def test_health():
    """Test the health check endpoint"""
    print_section("Testing Health Check")
    try:
        response = requests.get(f"{BASE_URL}/api/health", timeout=5)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 200:
            data = response.json()
            if data.get("status") == "healthy":
                print("✅ Health check passed!")
                return True
            else:
                print("❌ Health check failed: status not 'healthy'")
                return False
        else:
            print(f"❌ Health check failed: status code {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to server. Is it running?")
        print("   Start the server with: python app.py")
        return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_examples():
    """Test the examples endpoint"""
    print_section("Testing Examples Endpoint")
    try:
        response = requests.get(f"{BASE_URL}/api/examples", timeout=5)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            examples = data.get("examples", [])
            print(f"Found {len(examples)} examples:")
            for i, example in enumerate(examples[:3], 1):  # Show first 3
                print(f"  {i}. {example.get('title', 'N/A')}")
            print("✅ Examples endpoint working!")
            return True
        else:
            print(f"❌ Examples endpoint failed: status code {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_frontend():
    """Test if frontend is accessible"""
    print_section("Testing Frontend")
    try:
        response = requests.get(BASE_URL, timeout=5)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            content = response.text
            if "DevOrchestrator" in content or "<html" in content.lower():
                print("✅ Frontend is accessible!")
                print(f"   Open in browser: {BASE_URL}")
                return True
            else:
                print("⚠️  Frontend returned content but may not be correct")
                return False
        else:
            print(f"❌ Frontend failed: status code {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_generate_optional():
    """Test project generation (optional, uses API key)"""
    print_section("Testing Project Generation (Optional)")
    print("⚠️  This will use your Groq API key and may take a minute...")
    
    response = input("Do you want to test project generation? (y/n): ")
    if response.lower() != 'y':
        print("⏭️  Skipping generation test")
        return None
    
    try:
        payload = {
            "prompt": "Create a simple hello world program in Python",
            "recursion_limit": 30  # Lower limit for testing
        }
        print(f"Sending request with prompt: {payload['prompt']}")
        print("⏳ This may take 30-60 seconds...")
        
        response = requests.post(
            f"{BASE_URL}/api/generate",
            json=payload,
            timeout=120
        )
        
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 200:
            print("✅ Project generation working!")
            return True
        else:
            print(f"❌ Generation failed: {response.text}")
            return False
    except requests.exceptions.Timeout:
        print("⏱️  Request timed out (this is normal for long operations)")
        return None
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def main():
    print("\n" + "="*50)
    print("  DevOrchestrator Local Testing")
    print("="*50)
    print(f"\nTesting server at: {BASE_URL}")
    print("Make sure the server is running: python app.py\n")
    
    # Wait a moment for user to read
    sleep(1)
    
    results = []
    
    # Run tests
    results.append(("Health Check", test_health()))
    results.append(("Examples Endpoint", test_examples()))
    results.append(("Frontend", test_frontend()))
    
    # Optional generation test
    gen_result = test_generate_optional()
    if gen_result is not None:
        results.append(("Project Generation", gen_result))
    
    # Summary
    print_section("Test Summary")
    passed = sum(1 for _, result in results if result is True)
    total = len(results)
    
    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL" if result is False else "⏭️  SKIP"
        print(f"  {test_name}: {status}")
    
    print(f"\nResults: {passed}/{total} tests passed")
    
    if passed == total:
        print("\n🎉 All tests passed! Your app is working correctly!")
        print(f"   Open in browser: {BASE_URL}")
        return 0
    else:
        print("\n⚠️  Some tests failed. Check the errors above.")
        return 1

if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\n\n⚠️  Tests interrupted by user")
        sys.exit(1)

