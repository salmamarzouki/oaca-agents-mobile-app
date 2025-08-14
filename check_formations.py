import requests
import json

try:
    # Récupérer les données des agents
    response = requests.get('http://127.0.0.1:8000/mobile-api/agents/')
    data = response.json()
    
    agents = data['agents']
    print(f"Total agents: {len(agents)}")
    
    # Chercher les agents avec formations multiples
    agents_with_multiple_formations = []
    agents_with_formation = []
    
    for agent in agents:
        formation = agent.get('formation')
        if formation and str(formation).strip() and str(formation) != 'N/A':
            agents_with_formation.append(agent)
            if '|' in str(formation):
                agents_with_multiple_formations.append(agent)
    
    print(f"Agents avec formation: {len(agents_with_formation)}")
    print(f"Agents avec formations multiples: {len(agents_with_multiple_formations)}")
    
    print("\n=== Exemples d'agents avec formations multiples ===")
    for i, agent in enumerate(agents_with_multiple_formations[:5]):
        print(f"{i+1}. {agent['nom']} {agent['prenom']} (Matricule: {agent['matricule']})")
        formations = str(agent['formation']).split('|')
        for j, formation in enumerate(formations):
            print(f"   Formation {j+1}: {formation.strip()}")
        print()
    
    print("\n=== Exemples d'agents avec une seule formation ===")
    single_formation_agents = [a for a in agents_with_formation if '|' not in str(a['formation'])]
    for i, agent in enumerate(single_formation_agents[:5]):
        print(f"{i+1}. {agent['nom']} {agent['prenom']}: {agent['formation']}")
    
except Exception as e:
    print(f"Erreur: {e}")
