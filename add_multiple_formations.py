#!/usr/bin/env python3
import os
import sys
import django

# Configuration Django
sys.path.append('backend/django_api')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_api.settings')
django.setup()

from agents.models import Agent

def add_multiple_formations():
    print("=== AJOUT DE FORMATIONS MULTIPLES POUR DÉMONSTRATION ===")
    
    # Agents à modifier avec leurs formations multiples
    agents_to_modify = [
        {
            'matricule': '23083',  # Bani Kamel
            'formations': [
                'Formation d\'Ornithologie et Herpéthologie dans le milieu Aéroportuaire',
                'Formation de contrôleurs aire de trafic',
                'Formation SPPA (Système de Prévention du Péril Animalier)'
            ],
            'periode': 'Du 21 au 25/12/2020 | Du 03 au 12/12/2012 | Du 13 au 17/11/2017'
        },
        {
            'matricule': '99289',  # Hzami Abderrahmen
            'formations': [
                'formation SPPA',
                'Formation des contrôleurs aire de trafic',
                'Formation de conducteur des PTS'
            ],
            'periode': 'Du 13 au 17/11/2017 | Du 03 au 12/12/2012 | Du 01/05 au 30/05/2012'
        },
        {
            'matricule': '23085',  # Zrida Hassen
            'formations': [
                'formation SPPA',
                'Formation d\'Ornithologie et Herpéthologie dans le milieu Aéroportuaire'
            ],
            'periode': 'Du 13 au 17/11/2017 | Du 21 au 25/12/2020'
        },
        {
            'matricule': '90049',  # Saada Adel
            'formations': [
                'Formation de conducteur des PTS',
                'Cours de sensibilisation à la sûreté de l\'Aviation Civile',
                'Formation (Aérodrome ,Sûreté, urgences, Télécommunication ,SGS, AIS)'
            ],
            'periode': '2014-07-16 | 2013-09-12 | Du 02 au 13/03/2020'
        },
        {
            'matricule': '12343',  # Karmous Sawssen
            'formations': [
                'Formation (Aérodrome ,Sûreté, urgences, Télécommunication ,SGS, AIS)',
                'Formation de conducteur des PTS',
                'Stage de formation de conduite PT à l\'AIDZ'
            ],
            'periode': 'Du 02 au 13/03/2020 | Du 01/05 au 30/05/2012 | Du 01/06 au 31/07/2014'
        }
    ]
    
    modified_count = 0
    
    for agent_data in agents_to_modify:
        try:
            agent = Agent.objects.get(matricule=agent_data['matricule'])
            
            # Concaténer les formations avec |
            formations_combined = ' | '.join(agent_data['formations'])
            
            # Mettre à jour l'agent
            agent.formation = formations_combined
            agent.periode = agent_data['periode']
            agent.save()
            
            print(f"✅ Agent {agent.matricule} ({agent.nom} {agent.prenom}) mis à jour:")
            print(f"   Formations: {len(agent_data['formations'])} formations")
            for i, formation in enumerate(agent_data['formations']):
                print(f"   {i+1}. {formation}")
            print(f"   Périodes: {agent_data['periode']}")
            print()
            
            modified_count += 1
            
        except Agent.DoesNotExist:
            print(f"❌ Agent avec matricule {agent_data['matricule']} non trouvé")
        except Exception as e:
            print(f"❌ Erreur pour agent {agent_data['matricule']}: {e}")
    
    print(f"=== RÉSUMÉ ===")
    print(f"Agents modifiés: {modified_count}/{len(agents_to_modify)}")
    
    # Vérifier les résultats
    print(f"\n=== VÉRIFICATION ===")
    agents_with_multiple = Agent.objects.filter(formation__contains='|')
    print(f"Agents avec formations multiples dans la DB: {agents_with_multiple.count()}")
    
    for agent in agents_with_multiple:
        formations = agent.formation.split('|')
        print(f"- {agent.nom} {agent.prenom} ({agent.matricule}): {len(formations)} formations")

if __name__ == "__main__":
    add_multiple_formations()
