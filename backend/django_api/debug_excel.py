import pandas as pd
import os

def debug_excel_files():
    """Debug Excel files to understand their structure"""
    
    files = [
        'Liste des agents aux unités PPA&GAT&PT .xlsx',
        'liste des agents 2022 naima du 6 décembre 2022 .xlsx'
    ]
    
    for file_name in files:
        file_path = os.path.join('..', '..', file_name)
        if not os.path.exists(file_path):
            print(f"Fichier non trouvé: {file_path}")
            continue
            
        print(f"\n{'='*60}")
        print(f"FICHIER: {file_name}")
        print(f"{'='*60}")
        
        try:
            excel_file = pd.ExcelFile(file_path)
            print(f"Feuilles disponibles: {excel_file.sheet_names}")
            
            for sheet_name in excel_file.sheet_names:
                print(f"\n--- FEUILLE: {sheet_name} ---")
                
                # Lire sans en-tête pour voir la structure brute
                df = pd.read_excel(file_path, sheet_name=sheet_name, header=None)
                print(f"Dimensions: {df.shape}")
                
                # Afficher les 10 premières lignes
                print("Premières lignes:")
                for i in range(min(10, len(df))):
                    row_data = []
                    for j in range(min(6, len(df.columns))):  # Limiter à 6 colonnes
                        cell_value = df.iloc[i, j]
                        if pd.notna(cell_value):
                            row_data.append(str(cell_value)[:30])  # Limiter à 30 caractères
                        else:
                            row_data.append("NaN")
                    print(f"  Ligne {i}: {row_data}")
                
                # Chercher les lignes contenant "Matricule"
                print("\nLignes contenant 'Matricule':")
                for i, row in df.iterrows():
                    for j, cell in enumerate(row):
                        if pd.notna(cell) and 'Matricule' in str(cell):
                            print(f"  Ligne {i}, Colonne {j}: {cell}")
                            # Afficher cette ligne complète
                            row_data = [str(df.iloc[i, k])[:20] if pd.notna(df.iloc[i, k]) else "NaN" 
                                       for k in range(min(6, len(df.columns)))]
                            print(f"    Ligne complète: {row_data}")
                            break
                
        except Exception as e:
            print(f"Erreur lors de la lecture de {file_name}: {str(e)}")

if __name__ == "__main__":
    debug_excel_files()
