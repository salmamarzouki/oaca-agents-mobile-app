#!/usr/bin/env python3
"""
Simple script to test the Django API endpoints
"""
import requests
import json

BASE_URL = 'http://localhost:8000'

def test_endpoints():
    """Test all API endpoints"""
    
    print("Testing Django API Endpoints...")
    print("=" * 50)
    
    # Test 1: Get all agents
    print("\n1. Testing GET /mobile-api/agents/")
    try:
        response = requests.get(f'{BASE_URL}/mobile-api/agents/')
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"Total agents: {data.get('count', 0)}")
        else:
            print(f"Error: {response.text}")
    except Exception as e:
        print(f"Connection error: {e}")
    
    # Test 2: Get PPA&GAT&PT agents
    print("\n2. Testing GET /mobile-api/agents/ppa-gat-pt/")
    try:
        response = requests.get(f'{BASE_URL}/mobile-api/agents/ppa-gat-pt/')
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"PPA&GAT&PT agents: {data.get('count', 0)}")
    except Exception as e:
        print(f"Connection error: {e}")
    
    # Test 3: Get Naima agents
    print("\n3. Testing GET /mobile-api/agents/naima/")
    try:
        response = requests.get(f'{BASE_URL}/mobile-api/agents/naima/')
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"Naima agents: {data.get('count', 0)}")
    except Exception as e:
        print(f"Connection error: {e}")
    
    # Test 4: Get agents by function
    print("\n4. Testing GET /mobile-api/agents/by-fonction/")
    try:
        response = requests.get(f'{BASE_URL}/mobile-api/agents/by-fonction/')
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"Functions available: {len(data.get('functions', {}))}")
    except Exception as e:
        print(f"Connection error: {e}")
    
    # Test 5: Get agents by sheets
    print("\n5. Testing GET /mobile-api/agents/by-sheets/")
    try:
        response = requests.get(f'{BASE_URL}/mobile-api/agents/by-sheets/')
        print(f"Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"Files available: {len(data.get('files', {}))}")
    except Exception as e:
        print(f"Connection error: {e}")
    
    # Test 6: Create agent (POST)
    print("\n6. Testing POST /mobile-api/agents/create/")
    test_agent = {
        'matricule': 'TEST001',
        'nom': 'Test',
        'prenom': 'Agent',
        'affectation': 'Test Unit',
        'formation': 'Test Formation'
    }
    try:
        response = requests.post(
            f'{BASE_URL}/mobile-api/agents/create/',
            headers={'Content-Type': 'application/json'},
            data=json.dumps(test_agent)
        )
        print(f"Status: {response.status_code}")
        if response.status_code == 201:
            data = response.json()
            print(f"Created agent: {data.get('agent', {}).get('full_name', 'Unknown')}")
            return data.get('agent', {}).get('id')
        else:
            print(f"Error: {response.text}")
    except Exception as e:
        print(f"Connection error: {e}")
    
    return None

if __name__ == '__main__':
    test_endpoints()
