#!/usr/bin/env python3
import pandas as pd
import os

def analyze_excel_file(file_path, file_name):
    print(f"\n{'='*60}")
    print(f"ANALYSE DU FICHIER: {file_name}")
    print(f"{'='*60}")
    
    try:
        # Lire toutes les feuilles
        excel_file = pd.ExcelFile(file_path)
        print(f"📋 Feuilles disponibles: {excel_file.sheet_names}")
        
        for sheet_name in excel_file.sheet_names:
            print(f"\n📊 FEUILLE: {sheet_name}")
            print("-" * 40)
            
            # Lire la feuille
            df = pd.read_excel(file_path, sheet_name=sheet_name)
            print(f"Dimensions: {df.shape[0]} lignes x {df.shape[1]} colonnes")
            print(f"Colonnes: {list(df.columns)}")
            
            # Chercher les colonnes liées aux formations
            formation_columns = [col for col in df.columns if 'formation' in str(col).lower()]
            if formation_columns:
                print(f"🎓 Colonnes de formation trouvées: {formation_columns}")
                
                # Analyser les formations
                for col in formation_columns:
                    print(f"\n   Colonne '{col}':")
                    non_null_values = df[col].dropna()
                    if len(non_null_values) > 0:
                        print(f"   - Valeurs non nulles: {len(non_null_values)}")
                        print(f"   - Exemples de valeurs:")
                        for i, value in enumerate(non_null_values.head(5)):
                            print(f"     {i+1}. {value}")
                            # Vérifier si contient des séparateurs
                            if '|' in str(value):
                                formations = str(value).split('|')
                                print(f"        → {len(formations)} formations séparées par '|':")
                                for j, formation in enumerate(formations):
                                    print(f"          {j+1}. {formation.strip()}")
            
            # Chercher les colonnes liées aux périodes
            periode_columns = [col for col in df.columns if 'periode' in str(col).lower() or 'date' in str(col).lower()]
            if periode_columns:
                print(f"📅 Colonnes de période/date trouvées: {periode_columns}")
            
            # Chercher l'agent Bani Kamel spécifiquement
            if 'nom' in df.columns or 'Nom' in df.columns:
                nom_col = 'nom' if 'nom' in df.columns else 'Nom'
                bani_rows = df[df[nom_col].str.contains('Bani', na=False, case=False)]
                if len(bani_rows) > 0:
                    print(f"\n🔍 AGENT BANI TROUVÉ dans cette feuille:")
                    for idx, row in bani_rows.iterrows():
                        print(f"   Ligne {idx}:")
                        for col in df.columns:
                            if pd.notna(row[col]) and str(row[col]).strip():
                                print(f"     {col}: {row[col]}")
            
            print("\n" + "-" * 40)
            
    except Exception as e:
        print(f"❌ Erreur lors de la lecture de {file_name}: {e}")

def main():
    excel_dir = "backend/django_api/media/excel_files"
    
    # Fichiers à analyser
    files_to_analyze = [
        "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        "Liste des agents aux unités PPA&GAT&PT .xlsx",
        "naima_2022.xlsx"
    ]
    
    for file_name in files_to_analyze:
        file_path = os.path.join(excel_dir, file_name)
        if os.path.exists(file_path):
            analyze_excel_file(file_path, file_name)
        else:
            print(f"❌ Fichier non trouvé: {file_path}")

if __name__ == "__main__":
    main()
