#!/usr/bin/env python3
import pandas as pd
import os

def analyze_formations_in_excel():
    excel_dir = "backend/django_api/media/excel_files"
    
    # Analyser le fichier Naima (formations)
    naima_file = os.path.join(excel_dir, "liste des agents 2022 naima du 6 décembre 2022 .xlsx")
    
    if os.path.exists(naima_file):
        print("=== ANALYSE DU FICHIER NAIMA (FORMATIONS) ===")
        
        try:
            excel_file = pd.ExcelFile(naima_file)
            print(f"Feuilles: {excel_file.sheet_names}")
            
            agents_formations = {}
            
            for sheet_name in excel_file.sheet_names:
                print(f"\n--- FEUILLE: {sheet_name} ---")
                df = pd.read_excel(naima_file, sheet_name=sheet_name)

                print(f"Colonnes: {list(df.columns)}")
                print(f"Nombre de lignes: {len(df)}")

                # Afficher quelques lignes pour comprendre la structure
                print("\nPremières lignes:")
                print(df.head(5).to_string())

                # Trouver la ligne d'en-tête (qui contient 'Matricule')
                header_row = None
                for idx, row in df.iterrows():
                    if any('Matricule' in str(cell) for cell in row.values if pd.notna(cell)):
                        header_row = idx
                        print(f"\nLigne d'en-tête trouvée à l'index: {header_row}")
                        break

                if header_row is not None:
                    # Relire avec la bonne ligne d'en-tête
                    df = pd.read_excel(naima_file, sheet_name=sheet_name, header=header_row)
                    print(f"Nouvelles colonnes: {list(df.columns)}")

                    # Nettoyer les noms de colonnes
                    df.columns = df.columns.str.strip()

                    # Chercher les agents avec formations
                    for idx, row in df.iterrows():
                        # Essayer différents noms de colonnes possibles
                        matricule_cols = ['Matricule', 'matricule', 'MATRICULE']
                        nom_cols = ['Nom et prénom', 'Nom et Prénom', 'nom et prénom', 'Nom', 'nom']
                        formation_cols = ['Formation', 'formation', 'FORMATION']
                        periode_cols = ['Période', 'periode', 'PERIODE', 'Periode']

                        matricule = None
                        for col in matricule_cols:
                            if col in df.columns:
                                matricule = str(row.get(col, '')).strip()
                                break

                        nom_complet = None
                        for col in nom_cols:
                            if col in df.columns:
                                nom_complet = str(row.get(col, '')).strip()
                                break

                        formation = None
                        for col in formation_cols:
                            if col in df.columns:
                                formation = str(row.get(col, '')).strip()
                                break

                        periode = None
                        for col in periode_cols:
                            if col in df.columns:
                                periode = str(row.get(col, '')).strip()
                                break

                        if matricule and matricule != 'nan' and matricule != '' and matricule != 'Matricule':
                            if formation and formation != 'nan' and formation != '' and formation != 'Formation':
                                if matricule not in agents_formations:
                                    agents_formations[matricule] = {
                                        'nom': nom_complet or 'Nom inconnu',
                                        'formations': []
                                    }

                                agents_formations[matricule]['formations'].append({
                                    'formation': formation,
                                    'periode': periode or 'Période non spécifiée',
                                    'sheet': sheet_name
                                })

                                print(f"Agent trouvé: {matricule} - {nom_complet} - {formation}")
            
            print(f"\n=== RÉSULTATS ===")
            print(f"Total agents avec formations: {len(agents_formations)}")
            
            # Compter les agents avec formations multiples
            agents_multiples = {k: v for k, v in agents_formations.items() if len(v['formations']) > 1}
            print(f"Agents avec formations multiples: {len(agents_multiples)}")
            
            print(f"\n=== EXEMPLES D'AGENTS AVEC FORMATIONS MULTIPLES ===")
            for i, (matricule, data) in enumerate(list(agents_multiples.items())[:10]):
                print(f"\n{i+1}. {data['nom']} (Matricule: {matricule})")
                print(f"   Nombre de formations: {len(data['formations'])}")
                for j, formation_info in enumerate(data['formations']):
                    print(f"   Formation {j+1}: {formation_info['formation']}")
                    print(f"   Période {j+1}: {formation_info['periode']}")
                    print(f"   Feuille: {formation_info['sheet']}")
                    
        except Exception as e:
            print(f"Erreur: {e}")
    else:
        print(f"Fichier non trouvé: {naima_file}")

if __name__ == "__main__":
    analyze_formations_in_excel()
