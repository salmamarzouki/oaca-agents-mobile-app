import os
import pandas as pd
from django.core.management.base import BaseCommand
from django.conf import settings
from agents.models import Agent


class Command(BaseCommand):
    help = '''Import agents from Excel files

    This command imports agent data from two main Excel files:
    1. "Liste des agents aux unités PPA&GAT&PT .xlsx" - Contains basic agent info (matricule, name, age, affectation)
    2. "liste des agents 2022 naima du 6 décembre 2022 .xlsx" - Contains formation data (SPPA, etc.)

    The command automatically merges data from both files, updating existing agents with formation information.
    Supports multiple formations per agent, separated by " | ".

    Usage: python manage.py import_agents [--excel-dir path/to/excel/files]
    '''

    def add_arguments(self, parser):
        parser.add_argument(
            '--excel-dir',
            type=str,
            help='Directory containing Excel files',
            default='..'
        )

    def handle(self, *args, **options):
        excel_dir = options['excel_dir']
        
        # Excel files to process
        excel_files = [
            'Liste des agents aux unités PPA&GAT&PT .xlsx',
            'liste des agents 2022 naima du 6 décembre 2022 .xlsx'
        ]
        
        total_imported = 0
        
        for excel_file in excel_files:
            file_path = os.path.join(excel_dir, excel_file)
            if not os.path.exists(file_path):
                self.stdout.write(
                    self.style.WARNING(f'File not found: {file_path}')
                )
                continue
                
            self.stdout.write(f'Processing {excel_file}...')
            imported_count = self.import_from_excel(file_path, excel_file)
            total_imported += imported_count
            
        self.stdout.write(
            self.style.SUCCESS(f'Successfully imported {total_imported} agents')
        )

    def import_from_excel(self, file_path, source_file):
        """Import agents from a single Excel file with multiple sheets"""
        try:
            # Read all sheets from Excel file
            excel_file = pd.ExcelFile(file_path)
            total_imported = 0

            self.stdout.write(f'Found sheets: {excel_file.sheet_names}')

            for sheet_name in excel_file.sheet_names:
                self.stdout.write(f'Processing sheet: {sheet_name}')
                df = pd.read_excel(file_path, sheet_name=sheet_name, header=None)

                # Process based on file type
                if 'PPA&GAT&PT' in source_file:
                    imported_count = self.process_ppa_gat_pt_sheet(df, source_file, sheet_name)
                elif '2022 naima' in source_file:
                    imported_count = self.process_naima_sheet(df, source_file, sheet_name)
                else:
                    imported_count = 0

                total_imported += imported_count
                self.stdout.write(f'  Imported {imported_count} agents from sheet {sheet_name}')

            return total_imported

        except Exception as e:
            self.stdout.write(
                self.style.ERROR(f'Error processing {source_file}: {str(e)}')
            )
            return 0

    def process_ppa_gat_pt_sheet(self, df, source_file, sheet_name):
        """Process a single sheet from PPA&GAT&PT Excel file"""
        imported_count = 0

        # Find the header row (contains 'Matricule')
        header_row = None
        for idx, row in df.iterrows():
            if any('Matricule' in str(cell) for cell in row if pd.notna(cell)):
                header_row = idx
                break

        if header_row is None:
            self.stdout.write(self.style.WARNING(f'Could not find header row in sheet {sheet_name}'))
            return 0

        # Structure: [N/A, Matricule, Date de naissance, Age en 2024, Nom et prénom, Affectation]
            
        # Process data rows
        for idx in range(header_row + 1, len(df)):
            row = df.iloc[idx]

            # Skip empty rows
            if pd.isna(row[1]) or row[1] == '':
                continue

            try:
                # Extraire les données selon la structure: [N/A, Matricule, Date naissance, Age, Nom et prénom, Affectation]
                matricule = str(int(row[1])) if pd.notna(row[1]) else None
                date_naissance = pd.to_datetime(row[2]).date() if pd.notna(row[2]) else None
                age = int(row[3]) if pd.notna(row[3]) and str(row[3]).isdigit() else None
                nom_complet = str(row[4]).strip() if pd.notna(row[4]) else None
                affectation = str(row[5]).strip() if pd.notna(row[5]) and str(row[5]) != 'N/A' else None

                if matricule and nom_complet:
                    # Split name if possible
                    nom_parts = nom_complet.split()
                    if len(nom_parts) >= 2:
                        nom = nom_parts[-1]  # Last part is usually surname
                        prenom = ' '.join(nom_parts[:-1])  # Rest is first name
                    else:
                        nom = nom_complet
                        prenom = None

                    agent, created = Agent.objects.get_or_create(
                        matricule=matricule,
                        defaults={
                            'nom': nom,
                            'prenom': prenom,
                            'nom_complet': nom_complet,
                            'date_naissance': date_naissance,
                            'age': age,
                            'affectation': affectation,
                            'source_file': source_file,
                            'sheet_name': sheet_name,
                        }
                    )
                    
                    if created:
                        imported_count += 1
                        self.stdout.write(f'  Imported: {matricule} - {nom_complet}')
                    else:
                        self.stdout.write(f'  Already exists: {matricule}')
                        
            except Exception as e:
                self.stdout.write(
                    self.style.WARNING(f'Error processing row {idx}: {str(e)}')
                )
                continue
                
        return imported_count

    def process_naima_sheet(self, df, source_file, sheet_name):
        """Process a single sheet from Naima 2022 Excel file"""
        imported_count = 0
        
        # Find the header row (contains 'Matricule')
        header_row = None
        for idx, row in df.iterrows():
            if any('Matricule' in str(cell) for cell in row if pd.notna(cell)):
                header_row = idx
                break

        if header_row is None:
            self.stdout.write(self.style.WARNING(f'Could not find header row in sheet {sheet_name}'))
            return 0

        # Structure peut varier selon la feuille:
        # Feuilles PPA/Passerelle: [N/A, Matricule, Nom et prénom, Formation, Période, Affectation, Status]
        # Feuille GAT: [N/A, Matricule, Nom et prénom, Formation, Période, Affectation]

        # Process data rows
        current_agent = None

        for idx in range(header_row + 1, len(df)):
            row = df.iloc[idx]

            try:
                # Extraire les données selon la structure Naima 2022
                # Gestion robuste des différents types de données (int, float, string)
                matricule = None
                if pd.notna(row[1]) and str(row[1]).strip() != '':
                    try:
                        matricule = str(int(float(row[1])))  # Gère les float comme 23086.0
                    except (ValueError, TypeError):
                        matricule = str(row[1]).strip()

                nom_complet = str(row[2]).strip() if pd.notna(row[2]) and str(row[2]).strip() != '' else None
                formation = str(row[3]).strip() if pd.notna(row[3]) and str(row[3]).strip() != '' and str(row[3]).strip() != 'N/A' else None
                periode = str(row[4]).strip() if pd.notna(row[4]) and str(row[4]).strip() != '' and str(row[4]).strip() != 'N/A' else None
                affectation = str(row[5]).strip() if pd.notna(row[5]) and str(row[5]) != 'N/A' else None
                # Status peut ne pas exister dans toutes les feuilles (comme GAT)
                status = str(row[6]).strip() if len(row) > 6 and pd.notna(row[6]) and str(row[6]) != 'N/A' else None

                # Si on a un matricule, c'est un nouvel agent
                if matricule and nom_complet:
                    current_agent = matricule
                    # Split name if possible
                    nom_parts = nom_complet.split()
                    if len(nom_parts) >= 2:
                        nom = nom_parts[-1]  # Last part is usually surname
                        prenom = ' '.join(nom_parts[:-1])  # Rest is first name
                    else:
                        nom = nom_complet
                        prenom = None

                    agent, created = Agent.objects.get_or_create(
                        matricule=matricule,
                        defaults={
                            'nom': nom,
                            'prenom': prenom,
                            'nom_complet': nom_complet,
                            'formation': formation,
                            'periode': periode,
                            'affectation': affectation,
                            'status': status,
                            'source_file': source_file,
                            'sheet_name': sheet_name,
                        }
                    )

                    if created:
                        imported_count += 1
                        self.stdout.write(f'  Imported: {matricule} - {nom_complet}')
                    else:
                        # Mettre à jour les informations de formation si elles n'existent pas
                        updated = False
                        if formation and not agent.formation:
                            agent.formation = formation
                            updated = True
                        if periode and not agent.periode:
                            agent.periode = periode
                            updated = True
                        if status and not agent.status:
                            agent.status = status
                            updated = True
                        if updated:
                            agent.save()
                            self.stdout.write(f'  Updated with formation: {matricule} - {formation}')
                        else:
                            self.stdout.write(f'  Already exists: {matricule}')

                # Si pas de matricule mais qu'on a une formation, c'est une formation supplémentaire pour l'agent courant
                elif not matricule and formation and current_agent:
                    try:
                        agent = Agent.objects.get(matricule=current_agent)
                        matricule = current_agent  # Pour la logique suivante
                        created = False

                        # Update existing record with additional info
                        updated = False

                        # Gérer les formations multiples
                        if formation and formation != 'N/A':
                            if agent.formation and agent.formation != 'N/A':
                                # Concaténer les formations si différentes
                                if formation not in agent.formation:
                                    agent.formation = f"{agent.formation} | {formation}"
                                    updated = True
                                    self.stdout.write(f'  Formation ajoutée: {matricule} - {formation}')
                            else:
                                agent.formation = formation
                                updated = True
                                self.stdout.write(f'  Formation mise à jour: {matricule} - {formation}')

                        # Gérer les périodes multiples
                        if periode and periode != 'N/A':
                            if agent.periode and agent.periode != 'N/A':
                                # Concaténer les périodes si différentes
                                if periode not in agent.periode:
                                    agent.periode = f"{agent.periode} | {periode}"
                                    updated = True
                                    self.stdout.write(f'  Période ajoutée: {matricule} - {periode}')
                            else:
                                agent.periode = periode
                                updated = True
                                self.stdout.write(f'  Période mise à jour: {matricule} - {periode}')

                        # Autres champs
                        if status and not agent.status:
                            agent.status = status
                            updated = True

                        if updated:
                            agent.save()
                            self.stdout.write(f'  Updated: {matricule} - {nom_complet}')
                        else:
                            self.stdout.write(f'  No changes: {matricule} - {nom_complet}')

                    except Agent.DoesNotExist:
                        continue

                # Si ni matricule ni formation, ignorer cette ligne
                else:
                    continue

            except Exception as e:
                self.stdout.write(
                    self.style.WARNING(f'Error processing row {idx} in sheet {sheet_name}: {str(e)}')
                )
                # Afficher la ligne problématique pour debug
                try:
                    self.stdout.write(f'  Row data: {row.tolist()[:7]}')  # Limiter à 7 colonnes pour éviter trop d'output
                except:
                    self.stdout.write(f'  Could not display row data')
                continue
                
        return imported_count

