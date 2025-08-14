#!/usr/bin/env python3
import requests
import json

base_url = 'http://127.0.0.1:8000'

print('=== TESTING MOBILE API ENDPOINTS ===')
print()

# Test 1: Get all agents
try:
    response = requests.get(f'{base_url}/mobile-api/agents/')
    print('1. ALL AGENTS:')
    print(f'   Status: {response.status_code}')
    if response.status_code == 200:
        data = response.json()
        print(f'   Response type: {type(data)}')
        print(f'   Response keys: {list(data.keys()) if isinstance(data, dict) else "Not a dict"}')

        if isinstance(data, dict) and 'agents' in data:
            agents = data['agents']
            print(f'   Total agents returned: {len(agents)}')
            print(f'   Count in response: {data.get("count", "N/A")}')
            if agents:
                print('   Sample agent:')
                agent = agents[0]
                print(f'   - Matricule: {agent.get("matricule")}')
                print(f'   - Nom: {agent.get("nom_complet")}')
                formation = agent.get('formation', 'N/A')
                if formation and len(formation) > 50:
                    formation = formation[:50] + '...'
                print(f'   - Formation: {formation}')
                print(f'   - Affectation: {agent.get("affectation")}')
        elif isinstance(data, list):
            print(f'   Total agents returned: {len(data)}')
            if data:
                print('   Sample agent:')
                agent = data[0]
                print(f'   - Matricule: {agent.get("matricule")}')
                print(f'   - Nom: {agent.get("nom_complet")}')
        else:
            print(f'   Unexpected format: {str(data)[:200]}...')
    else:
        print(f'   Error: {response.text[:100]}...')
except Exception as e:
    print(f'   Connection error: {e}')

print()

# Test 2: Get agents stats
try:
    response = requests.get(f'{base_url}/mobile-api/agents/stats/')
    print('2. AGENTS STATS:')
    print(f'   Status: {response.status_code}')
    if response.status_code == 200:
        data = response.json()
        print(f'   Stats: {json.dumps(data, indent=4, ensure_ascii=False)}')
    else:
        print(f'   Error: {response.text[:100]}...')
except Exception as e:
    print(f'   Connection error: {e}')

print()

# Test 3: Get agents by sheets
try:
    response = requests.get(f'{base_url}/mobile-api/agents/by-sheets/')
    print('3. AGENTS BY SHEETS:')
    print(f'   Status: {response.status_code}')
    if response.status_code == 200:
        data = response.json()
        for sheet, agents in data.items():
            print(f'   {sheet}: {len(agents)} agents')
    else:
        print(f'   Error: {response.text[:100]}...')
except Exception as e:
    print(f'   Connection error: {e}')

print()

# Test 4: Get agents by airports
try:
    response = requests.get(f'{base_url}/mobile-api/agents/by-airports/')
    print('4. AGENTS BY AIRPORTS:')
    print(f'   Status: {response.status_code}')
    if response.status_code == 200:
        data = response.json()
        for airport, agents in data.items():
            print(f'   {airport}: {len(agents)} agents')
    else:
        print(f'   Error: {response.text[:100]}...')
except Exception as e:
    print(f'   Connection error: {e}')
