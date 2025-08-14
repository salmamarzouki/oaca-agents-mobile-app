#!/usr/bin/env python3
import pandas as pd
import os

def read_naima_formations():
    excel_dir = "backend/django_api/media/excel_files"
    naima_file = os.path.join(excel_dir, "liste des agents 2022 naima du 6 décembre 2022 .xlsx")
    
    if not os.path.exists(naima_file):
        print(f"Fichier non trouvé: {naima_file}")
        return
    
    print("=== LECTURE BRUTE DU FICHIER NAIMA ===")
    
    try:
        excel_file = pd.ExcelFile(naima_file)
        agents_formations = {}
        
        for sheet_name in excel_file.sheet_names:
            print(f"\n--- FEUILLE: {sheet_name} ---")
            
            # Lire sans en-tête d'abord
            df = pd.read_excel(naima_file, sheet_name=sheet_name, header=None)
            
            print(f"Dimensions: {df.shape}")
            print("Premières lignes brutes:")
            for i in range(min(6, len(df))):
                print(f"Ligne {i}: {list(df.iloc[i])}")
            
            # Trouver la ligne d'en-tête
            header_row = None
            for idx in range(len(df)):
                row_values = [str(val) for val in df.iloc[idx] if pd.notna(val)]
                if any('Matricule' in val for val in row_values):
                    header_row = idx
                    print(f"En-tête trouvé ligne {idx}: {row_values}")
                    break
            
            if header_row is not None:
                # Lire les données à partir de la ligne suivante
                data_start = header_row + 1
                
                for idx in range(data_start, len(df)):
                    row = df.iloc[idx]
                    
                    # Extraire les données par position (basé sur ce qu'on voit)
                    if sheet_name == "PPA":
                        # Colonnes: Num, Matricule, Nom et prénom, Formation, Période, Affectation, Status
                        matricule = str(row.iloc[1]) if len(row) > 1 and pd.notna(row.iloc[1]) else ""
                        nom = str(row.iloc[2]) if len(row) > 2 and pd.notna(row.iloc[2]) else ""
                        formation = str(row.iloc[3]) if len(row) > 3 and pd.notna(row.iloc[3]) else ""
                        periode = str(row.iloc[4]) if len(row) > 4 and pd.notna(row.iloc[4]) else ""
                    
                    elif sheet_name == "Passerelle":
                        # Colonnes similaires mais positions peuvent différer
                        matricule = str(row.iloc[1]) if len(row) > 1 and pd.notna(row.iloc[1]) else ""
                        nom = str(row.iloc[2]) if len(row) > 2 and pd.notna(row.iloc[2]) else ""
                        formation = str(row.iloc[3]) if len(row) > 3 and pd.notna(row.iloc[3]) else ""
                        periode = str(row.iloc[4]) if len(row) > 4 and pd.notna(row.iloc[4]) else ""
                    
                    elif sheet_name == "GAT":
                        matricule = str(row.iloc[1]) if len(row) > 1 and pd.notna(row.iloc[1]) else ""
                        nom = str(row.iloc[2]) if len(row) > 2 and pd.notna(row.iloc[2]) else ""
                        formation = str(row.iloc[3]) if len(row) > 3 and pd.notna(row.iloc[3]) else ""
                        periode = str(row.iloc[4]) if len(row) > 4 and pd.notna(row.iloc[4]) else ""
                    
                    # Nettoyer et valider
                    matricule = matricule.strip()
                    nom = nom.strip()
                    formation = formation.strip()
                    periode = periode.strip()
                    
                    if (matricule and matricule != 'nan' and matricule != '' and 
                        formation and formation != 'nan' and formation != '' and
                        matricule.isdigit()):  # Vérifier que c'est un vrai matricule
                        
                        if matricule not in agents_formations:
                            agents_formations[matricule] = {
                                'nom': nom,
                                'formations': []
                            }
                        
                        # Vérifier si cette formation existe déjà
                        formation_exists = False
                        for existing_formation in agents_formations[matricule]['formations']:
                            if existing_formation['formation'] == formation:
                                formation_exists = True
                                break

                        if not formation_exists:
                            agents_formations[matricule]['formations'].append({
                                'formation': formation,
                                'periode': periode,
                                'sheet': sheet_name
                            })
                            print(f"✓ Agent: {matricule} - {nom} - {formation[:50]}...")
                        else:
                            print(f"⚠ Formation déjà existante pour {matricule}: {formation[:30]}...")
        
        print(f"\n=== RÉSULTATS FINAUX ===")
        print(f"Total agents avec formations: {len(agents_formations)}")
        
        # Agents avec formations multiples
        agents_multiples = {k: v for k, v in agents_formations.items() if len(v['formations']) > 1}
        print(f"Agents avec formations multiples: {len(agents_multiples)}")
        
        print(f"\n=== TOP 10 AGENTS AVEC FORMATIONS MULTIPLES ===")
        for i, (matricule, data) in enumerate(list(agents_multiples.items())[:10]):
            print(f"\n{i+1}. {data['nom']} (Matricule: {matricule})")
            print(f"   Nombre de formations: {len(data['formations'])}")
            for j, formation_info in enumerate(data['formations']):
                print(f"   Formation {j+1}: {formation_info['formation']}")
                print(f"   Période {j+1}: {formation_info['periode']}")
                print(f"   Feuille: {formation_info['sheet']}")
        
        # Vérifier si Bani Kamel est dans les données
        print(f"\n=== RECHERCHE BANI KAMEL ===")
        for matricule, data in agents_formations.items():
            if 'Bani' in data['nom'] or 'bani' in data['nom'].lower():
                print(f"Trouvé: {data['nom']} (Matricule: {matricule})")
                for formation_info in data['formations']:
                    print(f"  - {formation_info['formation']} ({formation_info['periode']})")
                    
    except Exception as e:
        print(f"Erreur: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    read_naima_formations()
