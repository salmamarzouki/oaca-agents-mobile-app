#!/usr/bin/env python3
"""
Script pour tester les formations multiples en ajoutant des formations à un agent
"""

import os
import sys
import django

# Configuration Django
sys.path.append('backend/django_api')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_api.settings')
django.setup()

from agents.models import Agent

def test_multiple_formations():
    """Ajouter des formations multiples à un agent pour tester l'affichage"""
    
    print("🧪 Test des formations multiples")
    print("=" * 50)
    
    # Chercher Bani Kamel
    try:
        agent = Agent.objects.get(matricule='23083')
        print(f"✅ Agent trouvé: {agent.nom_complet}")
        print(f"Formation actuelle: {agent.formation}")
        
        # Ajouter une formation supplémentaire
        nouvelle_formation = "Formation de contrôleurs aire de trafic"
        
        if agent.formation and nouvelle_formation not in agent.formation:
            agent.formation = f"{agent.formation} | {nouvelle_formation}"
            agent.save()
            print(f"✅ Formation ajoutée: {nouvelle_formation}")
            print(f"Formations complètes: {agent.formation}")
        else:
            print("❌ Formation déjà présente ou agent sans formation")
            
    except Agent.DoesNotExist:
        print("❌ Agent Bani Kamel (23083) non trouvé")
        return
    
    # Tester avec un autre agent
    try:
        # Chercher un agent avec formation SPPA
        agents_sppa = Agent.objects.filter(formation__icontains='SPPA')[:1]
        if agents_sppa:
            agent = agents_sppa[0]
            print(f"\n✅ Agent SPPA trouvé: {agent.nom_complet} ({agent.matricule})")
            print(f"Formation actuelle: {agent.formation}")
            
            # Ajouter une formation supplémentaire
            nouvelle_formation = "Formation Sécurité Aéroportuaire"
            
            if nouvelle_formation not in agent.formation:
                agent.formation = f"{agent.formation} | {nouvelle_formation}"
                agent.save()
                print(f"✅ Formation ajoutée: {nouvelle_formation}")
                print(f"Formations complètes: {agent.formation}")
            else:
                print("❌ Formation déjà présente")
        else:
            print("❌ Aucun agent avec formation SPPA trouvé")
            
    except Exception as e:
        print(f"❌ Erreur: {e}")
    
    print("\n" + "=" * 50)
    print("🎯 Test terminé ! Vérifiez l'affichage dans l'application mobile.")

if __name__ == "__main__":
    test_multiple_formations()
