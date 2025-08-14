#!/usr/bin/env python3
"""
Script de test pour vérifier que les formations sont correctement importées
Usage: python test_formations.py
"""

import os
import sys
import django

# Configuration Django
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_api.settings')
django.setup()

from agents.models import Agent

def test_formations():
    """Test que les formations sont correctement importées"""
    print("🔍 Test des formations importées...")
    print("=" * 50)
    
    # Compter les agents avec formations
    agents_with_formation = Agent.objects.exclude(formation__isnull=True).exclude(formation__exact='')
    total_agents = Agent.objects.count()
    
    print(f"📊 Statistiques:")
    print(f"   Total agents: {total_agents}")
    print(f"   Agents avec formation: {agents_with_formation.count()}")
    print(f"   Pourcentage: {(agents_with_formation.count() / total_agents * 100):.1f}%")
    print()
    
    # Tester des agents spécifiques
    test_cases = [
        ('23086', 'Moncef Chaibi'),
        ('10021', 'Bounagra Raouf'),
        ('23083', 'Bani Kamel'),
        ('12012', 'Mondher Guizeni'),
    ]
    
    print("🧪 Test d'agents spécifiques:")
    print("-" * 50)
    
    for matricule, nom_attendu in test_cases:
        try:
            agent = Agent.objects.get(matricule=matricule)
            formation = agent.formation or "Aucune"
            periode = agent.periode or "Non spécifiée"
            
            print(f"✅ {matricule} - {agent.nom_complet}")
            print(f"   Formation: {formation}")
            if agent.periode:
                print(f"   Période: {periode}")
            print()
            
        except Agent.DoesNotExist:
            print(f"❌ {matricule} - Agent non trouvé")
            print()
    
    # Lister les types de formations
    print("📋 Types de formations trouvées:")
    print("-" * 50)
    
    formations_uniques = set()
    for agent in agents_with_formation:
        if agent.formation:
            # Séparer les formations multiples
            formations = agent.formation.split(' | ')
            for formation in formations:
                formations_uniques.add(formation.strip())
    
    for i, formation in enumerate(sorted(formations_uniques), 1):
        print(f"   {i:2d}. {formation}")
    
    print()
    print(f"📈 Total types de formations: {len(formations_uniques)}")
    
    # Vérifications spécifiques
    print("\n🔍 Vérifications spécifiques:")
    print("-" * 50)
    
    # Vérifier les formations SPPA
    sppa_count = Agent.objects.filter(formation__icontains='SPPA').count()
    print(f"   Formations SPPA: {sppa_count} agents")
    
    # Vérifier les formations contrôleurs
    controleur_count = Agent.objects.filter(formation__icontains='contrôleur').count()
    print(f"   Formations contrôleurs: {controleur_count} agents")
    
    # Vérifier les formations aérodrome
    aerodrome_count = Agent.objects.filter(formation__icontains='Aérodrome').count()
    print(f"   Formations aérodrome: {aerodrome_count} agents")
    
    print("\n✅ Test terminé avec succès!")

if __name__ == "__main__":
    test_formations()
