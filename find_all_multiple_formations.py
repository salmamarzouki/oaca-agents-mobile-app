#!/usr/bin/env python3
import pandas as pd
import os
from collections import defaultdict

def find_all_agents_with_multiple_formations():
    excel_dir = "backend/django_api/media/excel_files"
    naima_file = os.path.join(excel_dir, "liste des agents 2022 naima du 6 décembre 2022 .xlsx")
    
    if not os.path.exists(naima_file):
        print(f"Fichier non trouvé: {naima_file}")
        return
    
    print("=== RECHERCHE DE TOUS LES AGENTS AVEC FORMATIONS MULTIPLES ===")
    
    try:
        excel_file = pd.ExcelFile(naima_file)
        agents_formations = defaultdict(lambda: {'nom': '', 'formations': []})
        
        for sheet_name in excel_file.sheet_names:
            print(f"\n--- ANALYSE FEUILLE: {sheet_name} ---")
            
            # Lire sans en-tête d'abord
            df = pd.read_excel(naima_file, sheet_name=sheet_name, header=None)
            
            # Trouver la ligne d'en-tête
            header_row = None
            for idx in range(len(df)):
                row_values = [str(val) for val in df.iloc[idx] if pd.notna(val)]
                if any('Matricule' in val for val in row_values):
                    header_row = idx
                    break
            
            if header_row is not None:
                data_start = header_row + 1
                agents_in_sheet = 0
                
                for idx in range(data_start, len(df)):
                    row = df.iloc[idx]
                    
                    # Extraire les données par position
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
                        matricule.isdigit()):
                        
                        # Stocker le nom si pas encore défini
                        if not agents_formations[matricule]['nom']:
                            agents_formations[matricule]['nom'] = nom
                        
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
                            agents_in_sheet += 1
                
                print(f"Agents trouvés dans {sheet_name}: {agents_in_sheet}")
        
        # Analyser les résultats
        print(f"\n=== ANALYSE GLOBALE ===")
        total_agents = len(agents_formations)
        agents_multiples = {k: v for k, v in agents_formations.items() if len(v['formations']) > 1}
        agents_simples = {k: v for k, v in agents_formations.items() if len(v['formations']) == 1}
        
        print(f"Total agents uniques: {total_agents}")
        print(f"Agents avec 1 seule formation: {len(agents_simples)}")
        print(f"Agents avec formations multiples: {len(agents_multiples)}")
        
        print(f"\n=== TOP 20 AGENTS AVEC FORMATIONS MULTIPLES ===")
        sorted_multiples = sorted(agents_multiples.items(), key=lambda x: len(x[1]['formations']), reverse=True)
        
        for i, (matricule, data) in enumerate(sorted_multiples[:20]):
            print(f"\n{i+1}. {data['nom']} (Matricule: {matricule})")
            print(f"   Nombre de formations: {len(data['formations'])}")
            for j, formation_info in enumerate(data['formations']):
                print(f"   Formation {j+1}: {formation_info['formation'][:60]}...")
                print(f"   Période {j+1}: {formation_info['periode']}")
                print(f"   Feuille: {formation_info['sheet']}")
        
        # Vérifier quelques agents spécifiques
        print(f"\n=== VÉRIFICATION D'AGENTS SPÉCIFIQUES ===")
        test_agents = ['23083', '99289', '23085', '90049']  # Bani Kamel et autres
        
        for matricule in test_agents:
            if matricule in agents_formations:
                data = agents_formations[matricule]
                print(f"\nAgent {matricule} ({data['nom']}):")
                print(f"  Formations: {len(data['formations'])}")
                for formation_info in data['formations']:
                    print(f"    - {formation_info['formation']} ({formation_info['sheet']})")
            else:
                print(f"\nAgent {matricule}: NON TROUVÉ")
                
    except Exception as e:
        print(f"Erreur: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    find_all_agents_with_multiple_formations()
