import os
import pandas as pd
from django.core.management.base import BaseCommand
from agents.models import Agent
from datetime import datetime
import re

class Command(BaseCommand):
    help = 'Import agents from Excel files based on screenshot data'

    def add_arguments(self, parser):
        parser.add_argument('--excel-dir', type=str, help='Directory containing Excel files', default='.')

    def handle(self, *args, **options):
        excel_dir = options['excel_dir']
        
        # Supprimer tous les agents existants pour un import propre
        Agent.objects.all().delete()
        self.stdout.write('Tous les agents existants ont été supprimés.')
        
        # Fichiers à traiter - nous allons traiter toutes les feuilles disponibles
        files_to_process = [
            {
                'file': 'Liste des agents aux unités PPA&GAT&PT .xlsx',
                'type': 'ppa_gat_file'
            },
            {
                'file': 'liste des agents 2022 naima du 6 décembre 2022 .xlsx',
                'type': 'naima_file'
            }
        ]
        
        total_imported = 0
        
        for file_info in files_to_process:
            file_path = os.path.join(excel_dir, file_info['file'])
            
            if not os.path.exists(file_path):
                self.stdout.write(
                    self.style.WARNING(f'Fichier non trouvé: {file_path}')
                )
                continue
                
            self.stdout.write(f'Traitement du fichier: {file_info["file"]}')
            
            try:
                # Lire toutes les feuilles du fichier Excel
                excel_file = pd.ExcelFile(file_path)
                self.stdout.write(f'  Feuilles disponibles: {excel_file.sheet_names}')

                # Traiter toutes les feuilles disponibles
                for sheet_name in excel_file.sheet_names:
                    self.stdout.write(f'  Traitement de la feuille: "{sheet_name}"')

                    # Lire la feuille
                    df = pd.read_excel(file_path, sheet_name=sheet_name)

                    # Traiter selon le type de fichier
                    if file_info['type'] == 'naima_file':
                        imported = self._process_naima_file(df, file_info['file'], sheet_name)
                    else:
                        imported = self._process_ppa_gat_file(df, file_info['file'], sheet_name)

                    total_imported += imported
                    self.stdout.write(f'    Importé: {imported} agents')
                        
            except Exception as e:
                self.stdout.write(
                    self.style.ERROR(f'Erreur lors du traitement de {file_info["file"]}: {str(e)}')
                )
        
        self.stdout.write(
            self.style.SUCCESS(f'Import terminé. Total: {total_imported} agents importés.')
        )

    def _parse_date(self, date_str):
        """Parse date from various formats"""
        if pd.isna(date_str) or not date_str:
            return None
            
        date_str = str(date_str).strip()
        
        # Format: 15-mars-68
        if re.match(r'\d{1,2}-\w+-\d{2}', date_str):
            try:
                # Remplacer les mois français
                months = {
                    'janv': 'Jan', 'févr': 'Feb', 'mars': 'Mar', 'avr': 'Apr',
                    'mai': 'May', 'juin': 'Jun', 'juil': 'Jul', 'août': 'Aug',
                    'sept': 'Sep', 'oct': 'Oct', 'nov': 'Nov', 'déc': 'Dec'
                }
                for fr, en in months.items():
                    date_str = date_str.replace(fr, en)
                
                # Parser la date
                parsed_date = datetime.strptime(date_str, '%d-%b-%y')
                # Ajuster l'année (68 = 1968, pas 2068)
                if parsed_date.year > 2024:
                    parsed_date = parsed_date.replace(year=parsed_date.year - 100)
                return parsed_date.date()
            except:
                pass
        
        return None

    def _calculate_age(self, birth_date):
        """Calculate age from birth date"""
        if not birth_date:
            return None
        
        today = datetime.now().date()
        age = today.year - birth_date.year
        if today.month < birth_date.month or (today.month == birth_date.month and today.day < birth_date.day):
            age -= 1
        return age

    def _process_ppa_gat_file(self, df, source_file, sheet_name):
        """Process PPA&GAT&PT file based on debug analysis"""
        imported_count = 0

        # Basé sur l'analyse debug, l'en-tête est à la ligne 2 (index 2)
        # Structure: Col0=vide, Col1=Matricule, Col2=Date naissance, Col3=Age, Col4=Nom, Col5=Affectation

        # Commencer à partir de la ligne 3 (index 3) pour les données
        for index in range(3, len(df)):
            try:
                row = df.iloc[index]

                # Vérifier si la ligne contient des données valides
                matricule = str(row.iloc[1]).strip() if len(row) > 1 and pd.notna(row.iloc[1]) else ''
                if not matricule or matricule == 'nan':
                    continue

                # Vérifier si c'est un matricule valide (numérique)
                try:
                    int(float(matricule))
                except:
                    continue

                # Extraire les données selon la structure détectée
                date_naissance_str = str(row.iloc[2]).strip() if len(row) > 2 and pd.notna(row.iloc[2]) else ''
                age_str = str(row.iloc[3]).strip() if len(row) > 3 and pd.notna(row.iloc[3]) else ''
                nom_prenom = str(row.iloc[4]).strip() if len(row) > 4 and pd.notna(row.iloc[4]) else ''
                affectation = str(row.iloc[5]).strip() if len(row) > 5 and pd.notna(row.iloc[5]) else ''

                # Parser la date de naissance (format datetime)
                date_naissance = None
                if date_naissance_str and date_naissance_str != 'nan':
                    try:
                        if 'T' in date_naissance_str or ' ' in date_naissance_str:
                            # Format datetime complet
                            date_naissance = pd.to_datetime(date_naissance_str).date()
                        else:
                            # Autres formats
                            date_naissance = self._parse_date(date_naissance_str)
                    except:
                        pass

                # Parser l'âge
                age = None
                if age_str and age_str != 'nan':
                    try:
                        age = int(float(age_str))
                    except:
                        pass

                # Si pas d'âge mais date de naissance, calculer l'âge
                if not age and date_naissance:
                    age = self._calculate_age(date_naissance)

                # Séparer nom et prénom
                nom, prenom = '', ''
                if nom_prenom:
                    parts = nom_prenom.split()
                    if len(parts) >= 2:
                        nom = parts[0]
                        prenom = ' '.join(parts[1:])
                    else:
                        nom = nom_prenom

                # Créer ou mettre à jour l'agent
                agent, created = Agent.objects.update_or_create(
                    matricule=matricule,
                    defaults={
                        'nom': nom,
                        'prenom': prenom,
                        'nom_complet': nom_prenom,
                        'date_naissance': date_naissance,
                        'age': age,
                        'affectation': affectation,
                        'source_file': source_file,
                        'sheet_name': sheet_name,
                        'status': 'ok'
                    }
                )

                if created:
                    imported_count += 1
                    self.stdout.write(f'    Créé: {matricule} - {nom_prenom} (âge: {age})')
                else:
                    self.stdout.write(f'    Mis à jour: {matricule} - {nom_prenom} (âge: {age})')

            except Exception as e:
                self.stdout.write(f'    Erreur ligne {index}: {str(e)}')
                continue

        return imported_count

    def _process_naima_file(self, df, source_file, sheet_name):
        """Process Naima file based on debug analysis"""
        imported_count = 0

        # Basé sur l'analyse debug, l'en-tête est à la ligne 2 (index 2)
        # Structure: Col0=vide, Col1=Matricule, Col2=Nom et prénom, Col3=Formation, Col4=Période, Col5=Affectation

        # Commencer à partir de la ligne 3 (index 3) pour les données
        for index in range(3, len(df)):
            try:
                row = df.iloc[index]

                # Vérifier si la ligne contient des données valides
                matricule = str(row.iloc[1]).strip() if len(row) > 1 and pd.notna(row.iloc[1]) else ''
                if not matricule or matricule == 'nan':
                    continue

                # Vérifier si c'est un matricule valide (numérique)
                try:
                    int(float(matricule))
                except:
                    continue

                # Extraire les données selon la structure détectée
                nom_prenom = str(row.iloc[2]).strip() if len(row) > 2 and pd.notna(row.iloc[2]) else ''
                formation = str(row.iloc[3]).strip() if len(row) > 3 and pd.notna(row.iloc[3]) else ''
                periode = str(row.iloc[4]).strip() if len(row) > 4 and pd.notna(row.iloc[4]) else ''
                affectation = str(row.iloc[5]).strip() if len(row) > 5 and pd.notna(row.iloc[5]) else ''

                # Pour le fichier Naima, pas de date de naissance ni d'âge directement
                # On peut essayer d'extraire l'âge de la période si elle contient une date
                date_naissance = None
                age = None

                # Essayer d'extraire une date de la période
                if periode and periode != 'nan':
                    # Chercher des patterns de date dans la période
                    date_matches = re.findall(r'\d{4}', periode)
                    if date_matches:
                        # Prendre la première année trouvée comme référence
                        try:
                            year = int(date_matches[0])
                            if 1950 <= year <= 2024:
                                # Estimer l'âge approximatif
                                age = 2024 - year + 25  # Estimation approximative
                        except:
                            pass

                # Séparer nom et prénom
                nom, prenom = '', ''
                if nom_prenom:
                    parts = nom_prenom.split()
                    if len(parts) >= 2:
                        nom = parts[0]
                        prenom = ' '.join(parts[1:])
                    else:
                        nom = nom_prenom

                # Créer ou mettre à jour l'agent - pour Naima, on enrichit les données existantes
                try:
                    # Essayer de trouver un agent existant
                    agent = Agent.objects.get(matricule=matricule)
                    # Mettre à jour avec les nouvelles informations (formation et période)
                    agent.formation = formation if formation else agent.formation
                    agent.periode = periode if periode else agent.periode
                    # Garder les autres informations existantes
                    agent.save()
                    created = False
                    self.stdout.write(f'    Enrichi: {matricule} - {nom_prenom} (formation: {formation[:30]})')
                except Agent.DoesNotExist:
                    # Créer un nouvel agent
                    agent = Agent.objects.create(
                        matricule=matricule,
                        nom=nom,
                        prenom=prenom,
                        nom_complet=nom_prenom,
                        date_naissance=date_naissance,
                        age=age,
                        affectation=affectation,
                        formation=formation,
                        periode=periode,
                        source_file=source_file,
                        sheet_name=sheet_name,
                        status='ok'
                    )
                    created = True
                    self.stdout.write(f'    Créé: {matricule} - {nom_prenom} (formation: {formation[:30]})')

                if created:
                    imported_count += 1

            except Exception as e:
                self.stdout.write(f'    Erreur ligne {index}: {str(e)}')
                continue

        return imported_count


