#!/usr/bin/env python3
"""
Script pour vérifier les données de l'application mobile
"""

def count_agents_in_flutter_code():
    """Compter les agents dans le code Flutter"""
    
    # Lire le fichier api_service.dart
    with open('agents_mobile_app/lib/services/api_service.dart', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Compter les occurrences de "Agent(id:"
    agent_count = content.count('Agent(id:')
    
    print(f"📱 VÉRIFICATION APPLICATION MOBILE")
    print(f"=" * 50)
    print(f"Nombre d'agents dans api_service.dart: {agent_count}")
    
    # Extraire les affectations uniques
    import re
    affectations = re.findall(r'affectation: "([^"]+)"', content)
    unique_affectations = sorted(set(affectations))
    
    print(f"Nombre d'aéroports uniques: {len(unique_affectations)}")
    print(f"Aéroports: {', '.join(unique_affectations)}")
    
    # Compter par aéroport
    print(f"\n📊 RÉPARTITION PAR AÉROPORT:")
    print(f"-" * 30)
    for airport in unique_affectations:
        count = affectations.count(airport)
        print(f"{airport}: {count} agents")
    
    print(f"\n✅ TOTAL: {agent_count} agents dans {len(unique_affectations)} aéroports")
    
    return agent_count, unique_affectations

def verify_airport_names():
    """Vérifier les noms d'aéroports"""
    
    with open('agents_mobile_app/lib/services/api_service.dart', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extraire les noms d'aéroports
    import re
    airport_names_match = re.search(r'getAirportNames\(\) \{[^}]+\}', content, re.DOTALL)
    
    if airport_names_match:
        airport_names_section = airport_names_match.group(0)
        print(f"\n🏢 NOMS D'AÉROPORTS CONFIGURÉS:")
        print(f"-" * 40)
        
        # Extraire les paires code -> nom
        pairs = re.findall(r"'([^']+)':\s*'([^']+)'", airport_names_section)
        for code, name in pairs:
            print(f"{code}: {name}")
    
    return pairs if airport_names_match else []

if __name__ == "__main__":
    try:
        agent_count, airports = count_agents_in_flutter_code()
        airport_names = verify_airport_names()
        
        print(f"\n🎯 RÉSUMÉ:")
        print(f"=" * 30)
        print(f"✅ {agent_count} agents (objectif: 97)")
        print(f"✅ {len(airports)} aéroports")
        print(f"✅ {len(airport_names)} noms d'aéroports configurés")
        
        if agent_count == 97:
            print(f"🎉 PARFAIT! Le nombre d'agents est correct!")
        else:
            print(f"⚠️  ATTENTION! Nombre d'agents incorrect (attendu: 97, trouvé: {agent_count})")
            
    except Exception as e:
        print(f"❌ Erreur: {e}")
