#!/usr/bin/env python3
import pandas as pd

# Voir toutes les feuilles du fichier Excel
try:
    excel_file = pd.ExcelFile('liste des agents 2022 naima du 6 décembre 2022 .xlsx')
    print("Feuilles disponibles dans le fichier Excel:")
    for sheet in excel_file.sheet_names:
        print(f"- {sheet}")
    
    # Chercher une feuille qui pourrait contenir AIDZ
    for sheet in excel_file.sheet_names:
        if 'AIDZ' in sheet.upper() or 'DJERBA' in sheet.upper():
            print(f"\nFeuille trouvée pour AIDZ: {sheet}")
            df = pd.read_excel('liste des agents 2022 naima du 6 décembre 2022 .xlsx', sheet_name=sheet)
            print(f"Nombre de lignes: {len(df)}")
            print("Colonnes:", list(df.columns))
            
            # Compter les agents
            agents_count = 0
            print("\nAgents trouvés:")
            for i, row in df.iterrows():
                nom = str(row.get('nom', '')).strip() if pd.notna(row.get('nom')) else ''
                prenom = str(row.get('prenom', '')).strip() if pd.notna(row.get('prenom')) else ''
                if nom or prenom:
                    agents_count += 1
                    print(f"{agents_count:2d}. {nom} {prenom}")
            
            print(f"\nTotal agents avec nom/prénom: {agents_count}")
            break
    
except Exception as e:
    print(f"Erreur: {e}")
