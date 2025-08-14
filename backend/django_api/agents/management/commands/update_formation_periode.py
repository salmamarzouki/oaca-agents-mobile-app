import os
import pandas as pd
from django.core.management.base import BaseCommand
from agents.models import Agent


class Command(BaseCommand):
    help = 'Met à jour les champs formation et période des agents existants depuis les fichiers Excel'

    def add_arguments(self, parser):
        parser.add_argument(
            '--excel-dir',
            type=str,
            default='.',
            help='Directory containing Excel files'
        )

    def handle(self, *args, **options):
        excel_dir = options['excel_dir']
        
        # Fichier Naima 2022 qui contient les données de formation
        naima_file = 'liste des agents 2022 naima du 6 décembre 2022 .xlsx'
        file_path = os.path.join(excel_dir, naima_file)
        
        if not os.path.exists(file_path):
            self.stdout.write(
                self.style.ERROR(f'Fichier non trouvé: {file_path}')
            )
            return
            
        self.stdout.write(f'Mise à jour des formations depuis {naima_file}...')
        updated_count = self.update_formation_from_naima(file_path)
        
        self.stdout.write(
            self.style.SUCCESS(f'Mis à jour {updated_count} agents avec les données de formation')
        )

    def update_formation_from_naima(self, file_path):
        """Met à jour les formations depuis le fichier Naima 2022"""
        updated_count = 0
        
        try:
            # Lire toutes les feuilles du fichier Excel
            excel_file = pd.ExcelFile(file_path)
            self.stdout.write(f'Feuilles trouvées: {excel_file.sheet_names}')

            for sheet_name in excel_file.sheet_names:
                self.stdout.write(f'Traitement de la feuille: {sheet_name}')
                df = pd.read_excel(file_path, sheet_name=sheet_name, header=None)

                # Trouver la ligne d'en-tête (contient 'Matricule')
                header_row = None
                for idx, row in df.iterrows():
                    if any('Matricule' in str(cell) for cell in row if pd.notna(cell)):
                        header_row = idx
                        break
                        
                if header_row is None:
                    self.stdout.write(self.style.WARNING(f'En-tête non trouvé dans {sheet_name}'))
                    continue

                # Structure: [N/A, Matricule, Nom et prénom, Formation, Période, Affectation, Status]
                # Traiter les lignes de données
                for idx in range(header_row + 1, len(df)):
                    row = df.iloc[idx]

                    # Ignorer les lignes vides
                    if pd.isna(row[1]) or row[1] == '':
                        continue

                    try:
                        # Extraire les données
                        matricule = str(int(row[1])) if pd.notna(row[1]) else None
                        nom_complet = str(row[2]).strip() if pd.notna(row[2]) else None
                        formation = str(row[3]).strip() if pd.notna(row[3]) and str(row[3]) != 'nan' else None
                        periode = str(row[4]).strip() if pd.notna(row[4]) and str(row[4]) != 'nan' else None

                        if matricule:
                            # Chercher l'agent existant
                            try:
                                agent = Agent.objects.get(matricule=matricule)
                                
                                # Mettre à jour les champs formation et période
                                updated = False
                                if formation and formation != 'N/A':
                                    agent.formation = formation
                                    updated = True
                                    
                                if periode and periode != 'N/A':
                                    agent.periode = periode
                                    updated = True
                                
                                if updated:
                                    agent.save()
                                    updated_count += 1
                                    self.stdout.write(f'  Mis à jour: {matricule} - Formation: {formation}, Période: {periode}')
                                    
                            except Agent.DoesNotExist:
                                self.stdout.write(f'  Agent non trouvé: {matricule}')
                                continue
                                
                    except Exception as e:
                        self.stdout.write(
                            self.style.WARNING(f'Erreur ligne {idx}: {str(e)}')
                        )
                        continue
                        
        except Exception as e:
            self.stdout.write(
                self.style.ERROR(f'Erreur lors du traitement de {file_path}: {str(e)}')
            )
            return 0
            
        return updated_count
