#!/usr/bin/env python3
import requests
import json

try:
    # Récupérer les données de l'API
    response = requests.get('http://127.0.0.1:8000/mobile-api/agents/')
    data = response.json()
    
    # Chercher Bani Kamel
    for agent in data['agents']:
        if agent.get('matricule') == '23083' or 'Bani' in str(agent.get('nom', '')):
            print("=== AGENT BANI KAMEL DEPUIS L'API ===")
            print(f"Nom: {agent.get('nom')} {agent.get('prenom')}")
            print(f"Matricule: {agent.get('matricule')}")
            print(f"Formation (brute): '{agent.get('formation')}'")
            print(f"Type formation: {type(agent.get('formation'))}")
            print(f"Longueur formation: {len(str(agent.get('formation')))}")
            print(f"Contient '|': {'|' in str(agent.get('formation'))}")
            
            # Test du parsing
            formation_text = str(agent.get('formation'))
            if '|' in formation_text:
                formations = formation_text.split('|')
                print(f"\n=== PARSING RÉUSSI ===")
                print(f"Nombre de formations: {len(formations)}")
                for i, formation in enumerate(formations):
                    print(f"Formation {i+1}: '{formation.strip()}'")
            else:
                print(f"\n=== PAS DE SÉPARATEUR | ===")
                print(f"Formation unique: '{formation_text}'")
            
            print(f"\n=== DONNÉES COMPLÈTES ===")
            for key, value in agent.items():
                if value:
                    print(f"{key}: {value}")
            break
    else:
        print("Agent Bani Kamel non trouvé dans l'API")
        
except Exception as e:
    print(f"Erreur: {e}")
