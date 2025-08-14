# Import Agents - Configuration et Utilisation

## 📋 Description
Ce script d'importation permet de charger les données des agents depuis les fichiers Excel dans la base de données Django.

## 🔧 Améliorations apportées (Janvier 2025)

### ✅ Corrections majeures :
1. **Gestion robuste des formations SPPA** : Le script lit maintenant correctement les formations depuis le fichier Naima
2. **Correspondance entre fichiers** : Les agents du fichier PPA&GAT&PT sont automatiquement mis à jour avec leurs formations du fichier Naima
3. **Gestion des types de données** : Support amélioré pour les matricules en format float (ex: 23086.0 → "23086")
4. **Formations multiples** : Support des formations séparées par " | "
5. **Gestion d'erreurs améliorée** : Messages d'erreur plus détaillés avec affichage des données problématiques

### 📁 Fichiers supportés :
1. **"Liste des agents aux unités PPA&GAT&PT .xlsx"**
   - Contient : Matricule, Nom, Prénom, Date naissance, Age, Affectation
   - Feuilles : GAT, Passerelle, PPA

2. **"liste des agents 2022 naima du 6 décembre 2022 .xlsx"**
   - Contient : Matricule, Nom, Formation, Période, Affectation, Status
   - Feuilles : PPA, Passerelle, GAT
   - **Formations SPPA et autres** : Correctement importées

## 🚀 Utilisation

### Commande de base :
```bash
python manage.py import_agents
```

### Avec répertoire personnalisé :
```bash
python manage.py import_agents --excel-dir /path/to/excel/files
```

### Depuis le répertoire backend/django_api :
```bash
python manage.py import_agents --excel-dir ../..
```

## 📊 Résultats attendus

### Formations importées :
- ✅ formation SPPA
- ✅ Formation des contrôleurs aire de trafic (DEA)
- ✅ Formation (Aérodrome, Sûreté, urgences, Télécommunication, SGS, AIS)
- ✅ Formation Ingénierie Aéroportuaire
- ✅ Stage de formation de conduite PT à l'AIDZ
- ✅ Et toutes les autres formations du fichier Naima

### Exemple de résultat :
```
Agent: Moncef Chaibi (23086)
Formation: "formation SPPA | Formation Ingénierie Aéroportuaire(Conception des aires avions)"
Période: "Du 13 au 17/11/2017 | Du 20/02 au 03/03/2017"
```

## 🔍 Vérification

### Vérifier les formations importées :
```python
python manage.py shell

from agents.models import Agent
agents_with_formation = Agent.objects.exclude(formation__isnull=True).exclude(formation__exact='')
print(f"Agents avec formation: {agents_with_formation.count()}")

# Vérifier un agent spécifique
agent = Agent.objects.get(matricule='23086')
print(f"Formation: {agent.formation}")
print(f"Période: {agent.periode}")
```

## ⚠️ Notes importantes

1. **Ordre d'importation** : Le script traite d'abord le fichier PPA&GAT&PT, puis le fichier Naima pour ajouter les formations
2. **Mise à jour automatique** : Les agents existants sont automatiquement mis à jour avec les nouvelles formations
3. **Gestion des doublons** : Les formations identiques ne sont pas dupliquées
4. **Robustesse** : Le script continue même en cas d'erreur sur une ligne spécifique

## 🐛 Dépannage

### Si les formations ne s'affichent pas :
1. Vérifier que les fichiers Excel sont dans le bon répertoire
2. Relancer l'importation : `python manage.py import_agents --excel-dir ../..`
3. Vérifier les logs pour les erreurs
4. Redémarrer l'application Flutter : `R` dans le terminal Flutter

### Logs typiques de succès :
```
Updated with formation: 23086 - formation SPPA
Formation ajoutée: 23086 - Formation Ingénierie Aéroportuaire
Successfully imported X agents
```

## 📱 Impact sur l'application mobile

Après l'importation, l'application mobile affichera :
- ✅ Chip "Formation" pour tous les agents ayant des formations
- ✅ Affichage compact des formations longues (avec troncature)
- ✅ Formations multiples séparées par des barres verticales

---
**Dernière mise à jour** : Janvier 2025
**Status** : ✅ Fonctionnel et testé
