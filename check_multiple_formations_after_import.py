#!/usr/bin/env python3
import requests
import json

try:
    # Récupérer les données de l'API
    response = requests.get('http://127.0.0.1:8000/mobile-api/agents/')
    data = response.json()
    
    # Chercher les agents avec formations multiples
    agents_with_multiple = []
    for agent in data['agents']:
        formation = agent.get('formation', '')
        if formation and '|' in str(formation):
            agents_with_multiple.append(agent)
    
    print(f"=== AGENTS AVEC FORMATIONS MULTIPLES ===")
    print(f"Total trouvé: {len(agents_with_multiple)}")
    
    if len(agents_with_multiple) == 0:
        print("\n❌ AUCUN AGENT AVEC FORMATIONS MULTIPLES TROUVÉ")
        print("\nLe problème est que les agents n'apparaissent que dans une seule feuille Excel.")
        print("Pour avoir des formations multiples, un agent doit apparaître dans plusieurs feuilles avec des formations différentes.")
        
        # Vérifier Bani Kamel spécifiquement
        print(f"\n=== VÉRIFICATION BANI KAMEL ===")
        for agent in data['agents']:
            if agent.get('matricule') == '23083' or 'Bani' in str(agent.get('nom', '')):
                print(f"Nom: {agent.get('nom')} {agent.get('prenom')}")
                print(f"Matricule: {agent.get('matricule')}")
                print(f"Formation: '{agent.get('formation')}'")
                print(f"Période: '{agent.get('periode')}'")
                print(f"Contient '|': {'|' in str(agent.get('formation', ''))}")
                break
        
        # Montrer quelques exemples d'agents
        print(f"\n=== EXEMPLES D'AGENTS (premiers 10) ===")
        for i, agent in enumerate(data['agents'][:10]):
            formation = agent.get('formation', 'N/A')
            print(f"{i+1}. {agent.get('nom')} {agent.get('prenom')} - Formation: {formation[:50]}...")
    
    else:
        print(f"\n=== LISTE DES AGENTS AVEC FORMATIONS MULTIPLES ===")
        for i, agent in enumerate(agents_with_multiple):
            print(f"\n{i+1}. {agent.get('nom')} {agent.get('prenom')} (Matricule: {agent.get('matricule')})")
            formations = str(agent.get('formation')).split('|')
            print(f"   Nombre de formations: {len(formations)}")
            for j, formation in enumerate(formations):
                print(f"   Formation {j+1}: {formation.strip()}")
            print(f"   Période: {agent.get('periode')}")
    
except Exception as e:
    print(f"Erreur: {e}")
    import traceback
    traceback.print_exc()
