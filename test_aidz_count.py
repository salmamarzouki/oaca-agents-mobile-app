#!/usr/bin/env python3
import requests
import json

try:
    # Tester l'API pour AIDZ
    response = requests.get('http://127.0.0.1:8000/mobile-api/agents/by-airports/')
    
    if response.status_code == 200:
        data = response.json()

        # Chercher AIDZ dans les données
        aidz_agents = []
        for airport in data.get('airports', []):
            if airport.get('code') == 'AIDZ':
                aidz_agents = airport.get('agents', [])
                break

        print(f"API retourne {len(aidz_agents)} agents pour AIDZ:")

        for i, agent in enumerate(aidz_agents, 1):
            nom = agent.get('nom', '')
            prenom = agent.get('prenom', '')
            print(f"{i:2d}. {nom} {prenom}")
    else:
        print(f"Erreur API: {response.status_code}")
        print(response.text)

except Exception as e:
    print(f"Erreur de connexion: {e}")
