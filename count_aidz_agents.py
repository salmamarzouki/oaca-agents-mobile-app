#!/usr/bin/env python3
import json

# Charger les données
with open('agents_data_complete.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Trouver AIDZ
aidz_airport = None
for airport in data['airports']:
    if airport['code'] == 'AIDZ':
        aidz_airport = airport
        break

if aidz_airport:
    agents = aidz_airport['agents']
    print(f"AIDZ a {len(agents)} agents:")
    for i, agent in enumerate(agents, 1):
        nom = agent.get('nom', '')
        prenom = agent.get('prenom', '')
        print(f"{i:2d}. {nom} {prenom}")
else:
    print("AIDZ non trouvé")
