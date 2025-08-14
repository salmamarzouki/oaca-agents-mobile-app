#!/usr/bin/env python3
import os
import django

# Setup Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'agent.settings')
django.setup()

from agents.models import Agent

print('=== DATABASE TEST ===')
print(f'Total agents in database: {Agent.objects.count()}')
print()

# Show first few agents
agents = Agent.objects.all()[:5]
for agent in agents:
    print(f'Matricule: {agent.matricule}')
    print(f'Nom: {agent.nom_complet}')
    formation = agent.formation[:50] if agent.formation else "N/A"
    print(f'Formation: {formation}...')
    print(f'Affectation: {agent.affectation}')
    print(f'Source: {agent.source_file}')
    print('---')

print()
print('=== AFFECTATION BREAKDOWN ===')
from django.db.models import Count
affectations = Agent.objects.values('affectation').annotate(count=Count('affectation')).order_by('affectation')
for item in affectations:
    affectation = item['affectation'] or 'Non affecté'
    count = item['count']
    print(f'{affectation}: {count} agents')

print()
print('=== FICHIERS SOURCE ===')
files = Agent.objects.values('source_file').annotate(count=Count('source_file')).order_by('source_file')
for item in files:
    source_file = item['source_file'] or 'Fichier inconnu'
    count = item['count']
    print(f'{source_file}: {count} agents')
