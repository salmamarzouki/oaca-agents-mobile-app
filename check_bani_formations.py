#!/usr/bin/env python3
"""
Script pour analyser toutes les formations de Bani Kamel dans les fichiers Excel
"""

import pandas as pd
import os

def check_bani_formations():
    """Chercher toutes les formations de Bani Kamel dans les fichiers Excel"""
    
    files_to_check = [
        "Liste des agents aux unités PPA&GAT&PT .xlsx",
        "liste des agents 2022 naima du 6 décembre 2022 .xlsx"
    ]
    
    print("🔍 Recherche des formations de Bani Kamel (matricule 23083)...")
    print("=" * 60)
    
    all_formations = []
    
    for file_name in files_to_check:
        if not os.path.exists(file_name):
            print(f"❌ Fichier non trouvé: {file_name}")
            continue
            
        print(f"\n📄 Analyse du fichier: {file_name}")
        print("-" * 40)
        
        try:
            # Lire toutes les feuilles
            excel_file = pd.ExcelFile(file_name)
            print(f"📋 Feuilles: {excel_file.sheet_names}")
            
            for sheet_name in excel_file.sheet_names:
                print(f"\n📊 Feuille: {sheet_name}")
                df = pd.read_excel(file_name, sheet_name=sheet_name, header=None)
                
                # Chercher Bani Kamel ou matricule 23083
                found_rows = []
                
                for idx, row in df.iterrows():
                    row_str = ' '.join([str(cell) for cell in row if pd.notna(cell)])
                    
                    if '23083' in row_str or 'Bani Kamel' in row_str or 'Kamel Bani' in row_str:
                        found_rows.append((idx, row))
                
                if found_rows:
                    print(f"✅ Trouvé {len(found_rows)} ligne(s) pour Bani Kamel:")
                    for idx, row in found_rows:
                        print(f"  Ligne {idx + 1}: {[str(cell) for cell in row if pd.notna(cell)]}")
                        
                        # Extraire les informations
                        row_data = [str(cell) for cell in row if pd.notna(cell)]
                        formation_info = {
                            'file': file_name,
                            'sheet': sheet_name,
                            'line': idx + 1,
                            'data': row_data
                        }
                        all_formations.append(formation_info)
                else:
                    print("❌ Aucune ligne trouvée pour Bani Kamel")
                    
        except Exception as e:
            print(f"❌ Erreur lors de l'analyse de {file_name}: {e}")
    
    print("\n" + "=" * 60)
    print("📋 RÉSUMÉ DES FORMATIONS TROUVÉES:")
    print("=" * 60)
    
    if all_formations:
        for i, formation in enumerate(all_formations, 1):
            print(f"\n{i}. Fichier: {formation['file']}")
            print(f"   Feuille: {formation['sheet']}")
            print(f"   Ligne: {formation['line']}")
            print(f"   Données: {formation['data']}")
    else:
        print("❌ Aucune formation trouvée pour Bani Kamel")
    
    return all_formations

if __name__ == "__main__":
    formations = check_bani_formations()
