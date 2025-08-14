#!/usr/bin/env python3
import pandas as pd

# Lire le fichier Excel AIDZ
try:
    df = pd.read_excel('Liste des agents aux unités PPA&GAT&PT .xlsx', sheet_name='AIDZ')
    print(f"Nombre total de lignes dans la feuille AIDZ: {len(df)}")
    print("\nTous les agents dans le fichier Excel:")
    
    for i, row in df.iterrows():
        nom = str(row.get('nom', '')).strip() if pd.notna(row.get('nom')) else ''
        prenom = str(row.get('prenom', '')).strip() if pd.notna(row.get('prenom')) else ''
        if nom or prenom:  # Afficher seulement les lignes avec nom ou prénom
            print(f"{i+1:2d}. {nom} {prenom}")
    
    print(f"\nNombre d'agents avec nom/prénom: {len([i for i, row in df.iterrows() if (pd.notna(row.get('nom')) and str(row.get('nom')).strip()) or (pd.notna(row.get('prenom')) and str(row.get('prenom')).strip())])}")
    
except Exception as e:
    print(f"Erreur: {e}")
