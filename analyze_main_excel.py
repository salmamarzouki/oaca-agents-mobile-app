#!/usr/bin/env python3
import pandas as pd
import os
from collections import defaultdict

def analyze_main_excel():
    excel_dir = "backend/django_api/media/excel_files"
    main_file = os.path.join(excel_dir, "Liste des agents aux unités PPA&GAT&PT .xlsx")
    
    if not os.path.exists(main_file):
        print(f"Fichier non trouvé: {main_file}")
        return
    
    print("=== ANALYSE DU FICHIER PRINCIPAL ===")
    print(f"Fichier: {main_file}")
    
    try:
        excel_file = pd.ExcelFile(main_file)
        print(f"Feuilles: {excel_file.sheet_names}")
        
        agents_formations = defaultdict(lambda: {'nom': '', 'formations': []})
        
        for sheet_name in excel_file.sheet_names:
            print(f"\n--- FEUILLE: {sheet_name} ---")
            
            # Lire la feuille
            df = pd.read_excel(main_file, sheet_name=sheet_name)
            print(f"Dimensions: {df.shape}")
            print(f"Colonnes: {list(df.columns)}")
            
            # Afficher quelques lignes
            print("\nPremières lignes:")
            print(df.head(3).to_string())
            
            # Chercher les colonnes de formation
            formation_cols = [col for col in df.columns if 'formation' in str(col).lower()]
            if formation_cols:
                print(f"\nColonnes de formation: {formation_cols}")
                
                # Analyser les formations
                for col in formation_cols:
                    non_null_values = df[col].dropna()
                    if len(non_null_values) > 0:
                        print(f"\nColonne '{col}' - {len(non_null_values)} valeurs:")
                        for i, value in enumerate(non_null_values.head(10)):
                            print(f"  {i+1}. {value}")
                            if '|' in str(value):
                                formations = str(value).split('|')
                                print(f"      → {len(formations)} formations séparées:")
                                for j, formation in enumerate(formations):
                                    print(f"        {j+1}. {formation.strip()}")
            
            # Chercher Bani Kamel spécifiquement
            for col in df.columns:
                if df[col].dtype == 'object':  # Colonnes texte
                    bani_rows = df[df[col].astype(str).str.contains('Bani', na=False, case=False)]
                    if len(bani_rows) > 0:
                        print(f"\n🔍 BANI TROUVÉ dans colonne '{col}':")
                        for idx, row in bani_rows.iterrows():
                            print(f"   Ligne {idx}:")
                            for c in df.columns:
                                if pd.notna(row[c]) and str(row[c]).strip():
                                    print(f"     {c}: {row[c]}")
                        break
            
            print("\n" + "="*50)
            
    except Exception as e:
        print(f"Erreur: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    analyze_main_excel()
