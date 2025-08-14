import requests
import json

try:
    # Récupérer les données des agents
    response = requests.get('http://127.0.0.1:8000/mobile-api/agents/')
    data = response.json()
    
    agents = data['agents']
    
    # Chercher l'agent Bani Kamel
    bani_kamel = None
    for agent in agents:
        if agent.get('matricule') == '23083' or 'Bani' in str(agent.get('nom', '')):
            bani_kamel = agent
            break
    
    if bani_kamel:
        print("=== AGENT BANI KAMEL ===")
        print(f"Nom: {bani_kamel.get('nom')} {bani_kamel.get('prenom')}")
        print(f"Matricule: {bani_kamel.get('matricule')}")
        print(f"Formation brute: '{bani_kamel.get('formation')}'")
        print(f"Période: '{bani_kamel.get('periode')}'")
        print(f"Affectation: {bani_kamel.get('affectation')}")
        
        # Analyser les formations
        formation_text = str(bani_kamel.get('formation', ''))
        if '|' in formation_text:
            formations = formation_text.split('|')
            print(f"\n=== FORMATIONS SÉPARÉES ({len(formations)}) ===")
            for i, formation in enumerate(formations):
                print(f"Formation {i+1}: '{formation.strip()}'")
        else:
            print(f"\nPas de séparateur '|' trouvé dans: '{formation_text}'")
        
        print(f"\n=== DONNÉES COMPLÈTES ===")
        for key, value in bani_kamel.items():
            if value:
                print(f"{key}: {value}")
    else:
        print("Agent Bani Kamel non trouvé")
        print("\nAgents avec 'Bani' dans le nom:")
        for agent in agents:
            if 'Bani' in str(agent.get('nom', '')):
                print(f"- {agent.get('nom')} {agent.get('prenom')} (Matricule: {agent.get('matricule')})")
    
except Exception as e:
    print(f"Erreur: {e}")
