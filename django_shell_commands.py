from agents.models import Agent

# Bani Kamel - 3 formations
agent = Agent.objects.get(matricule='23083')
agent.formation = "Formation d'Ornithologie et Herpéthologie dans le milieu Aéroportuaire | Formation de contrôleurs aire de trafic | Formation SPPA (Système de Prévention du Péril Animalier)"
agent.periode = "Du 21 au 25/12/2020 | Du 03 au 12/12/2012 | Du 13 au 17/11/2017"
agent.save()
print(f"✅ {agent.nom} {agent.prenom} - 3 formations")

# Hzami Abderrahmen - 3 formations
agent = Agent.objects.get(matricule='99289')
agent.formation = "formation SPPA | Formation des contrôleurs aire de trafic | Formation de conducteur des PTS"
agent.periode = "Du 13 au 17/11/2017 | Du 03 au 12/12/2012 | Du 01/05 au 30/05/2012"
agent.save()
print(f"✅ {agent.nom} {agent.prenom} - 3 formations")

# Zrida Hassen - 2 formations
agent = Agent.objects.get(matricule='23085')
agent.formation = "formation SPPA | Formation d'Ornithologie et Herpéthologie dans le milieu Aéroportuaire"
agent.periode = "Du 13 au 17/11/2017 | Du 21 au 25/12/2020"
agent.save()
print(f"✅ {agent.nom} {agent.prenom} - 2 formations")

# Saada Adel - 3 formations
agent = Agent.objects.get(matricule='90049')
agent.formation = "Formation de conducteur des PTS | Cours de sensibilisation à la sûreté de l'Aviation Civile | Formation (Aérodrome ,Sûreté, urgences, Télécommunication ,SGS, AIS)"
agent.periode = "2014-07-16 | 2013-09-12 | Du 02 au 13/03/2020"
agent.save()
print(f"✅ {agent.nom} {agent.prenom} - 3 formations")

# Karmous Sawssen - 3 formations
agent = Agent.objects.get(matricule='12343')
agent.formation = "Formation (Aérodrome ,Sûreté, urgences, Télécommunication ,SGS, AIS) | Formation de conducteur des PTS | Stage de formation de conduite PT à l'AIDZ"
agent.periode = "Du 02 au 13/03/2020 | Du 01/05 au 30/05/2012 | Du 01/06 au 31/07/2014"
agent.save()
print(f"✅ {agent.nom} {agent.prenom} - 3 formations")

# Vérification
agents_with_multiple = Agent.objects.filter(formation__contains='|')
print(f"\n=== RÉSUMÉ ===")
print(f"Agents avec formations multiples: {agents_with_multiple.count()}")
for agent in agents_with_multiple:
    formations = agent.formation.split('|')
    print(f"- {agent.nom} {agent.prenom} ({agent.matricule}): {len(formations)} formations")
