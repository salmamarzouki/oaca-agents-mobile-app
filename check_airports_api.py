import requests
import json

try:
    r = requests.get('http://127.0.0.1:8000/mobile-api/agents/by-airports/')
    print('Status:', r.status_code)
    
    if r.status_code == 200:
        data = r.json()
        print('Aéroports dans API:', len(data.get('airports', [])))
        
        for airport in data.get('airports', []):
            print(f'  {airport["code"]}: {len(airport["agents"])} agents')
    else:
        print('Erreur:', r.text)
        
except Exception as e:
    print('Erreur:', e)
