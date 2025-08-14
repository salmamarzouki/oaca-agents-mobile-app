import pandas as pd
import os
from django.conf import settings
from .models import Agent
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

def load_excel_data():
    """
    Charge les données depuis le fichier aire_de_trafic.xlsx uniquement
    """
    print("🔄 Début du chargement des données Aire de Trafic...")

    # Vider la base de données existante
    Agent.objects.all().delete()
    print("🗑️ Base de données vidée")

    # Chemin vers le dossier Excel
    if hasattr(settings, 'MEDIA_ROOT') and settings.MEDIA_ROOT:
        excel_dir = os.path.join(settings.MEDIA_ROOT, 'excel_files')
    else:
        # Fallback si MEDIA_ROOT n'est pas configuré
        excel_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'media', 'excel_files')

    print(f"📁 Répertoire Excel: {excel_dir}")

    # Charger uniquement le fichier aire_de_trafic.xlsx
    aire_trafic_file = os.path.join(excel_dir, 'aire_de_trafic.xlsx')
    if os.path.exists(aire_trafic_file):
        total_created = load_aire_trafic_file(aire_trafic_file)
    else:
        print(f"❌ Fichier non trouvé: {aire_trafic_file}")
        return 0

    print(f"✅ Chargement terminé: {total_created} agents aire de trafic chargés")

    return total_created

def load_aire_trafic_file(file_path):
    """
    Charge le fichier aire_de_trafic.xlsx avec toutes les données dans un seul fichier
    """
    print(f"📄 Chargement du fichier aire de trafic: {file_path}")

    created_count = 0

    try:
        # Lire le fichier Excel
        df = pd.read_excel(file_path, sheet_name='Aire_Trafic')

        # Nettoyer les noms de colonnes
        df.columns = df.columns.str.strip()
        print(f"📋 Colonnes: {list(df.columns)}")
        print(f"📊 Nombre de lignes: {len(df)}")

        for index, row in df.iterrows():
            try:
                # Extraire les données
                matricule = str(row.get('Matricule', '')).strip()
                if not matricule or matricule == 'nan':
                    continue

                nom = str(row.get('Nom', '')).strip()
                prenom = str(row.get('Prénom', '')).strip()

                # Créer le nom complet
                full_name = f"{prenom} {nom}".strip()

                # Extraire tous les champs
                affectation = str(row.get('Affectation', '')).strip()
                fonction_grade = str(row.get('Fonction/Grade', '')).strip()
                age = safe_int(row.get('Age'))
                date_naissance = safe_date(row.get('Date de naissance'))
                anciennete = safe_int(row.get('Ancienneté'))
                formation = str(row.get('Formation', '')).strip()
                periode = str(row.get('Période', '')).strip()
                status = str(row.get('Status', '')).strip()

                # Créer l'agent avec toutes les données
                agent = Agent.objects.create(
                    matricule=matricule,
                    nom=nom,
                    prenom=prenom,
                    nom_complet=full_name,
                    full_name=full_name,
                    affectation=affectation,
                    fonction_grade=fonction_grade,
                    age=age,
                    date_naissance=date_naissance,
                    anciennete=anciennete,
                    formation=formation,
                    periode=periode,
                    status=status,
                    source_file='aire_de_trafic.xlsx',
                    sheet_name='Aire_Trafic'
                )

                created_count += 1
                if created_count % 10 == 0:
                    print(f"✅ {created_count} agents créés...")

            except Exception as e:
                print(f"❌ Erreur ligne {index}: {e}")
                continue

    except Exception as e:
        print(f"❌ Erreur lors du chargement de {file_path}: {e}")

    print(f"🎉 {created_count} agents aire de trafic créés avec succès")
    return created_count

def load_ppa_gat_data(file_path, agents_data):
    """
    Charge les données du fichier PPA&GAT&PT.xlsx dans le dictionnaire
    """
    print(f"📄 Chargement des données principales de {file_path}")

    try:
        # Lire toutes les feuilles
        excel_file = pd.ExcelFile(file_path)
        sheets = excel_file.sheet_names
        print(f"📋 Feuilles trouvées: {sheets}")

        for sheet_name in sheets:
            print(f"📊 Traitement de la feuille: {sheet_name}")
            df = pd.read_excel(file_path, sheet_name=sheet_name)

            # Nettoyer les noms de colonnes
            df.columns = df.columns.str.strip()
            print(f"📋 Colonnes: {list(df.columns)}")

            for index, row in df.iterrows():
                try:
                    # Extraire les données de base
                    matricule = str(row.get('Matricule', '')).strip()
                    if not matricule or matricule == 'nan':
                        continue

                    nom = str(row.get('Nom', '')).strip()
                    prenom = str(row.get('Prénom', '')).strip()

                    # Créer le nom complet
                    full_name = f"{prenom} {nom}".strip()

                    # Extraire les autres champs
                    affectation = str(row.get('Affectation', '')).strip()
                    fonction_grade = str(row.get('Fonction/Grade', '')).strip()
                    age = safe_int(row.get('Age'))
                    date_naissance = safe_date(row.get('Date de naissance'))
                    anciennete = safe_int(row.get('Ancienneté'))

                    # Stocker dans le dictionnaire (données principales)
                    agents_data[matricule] = {
                        'matricule': matricule,
                        'nom': nom,
                        'prenom': prenom,
                        'nom_complet': full_name,
                        'full_name': full_name,
                        'affectation': affectation,
                        'fonction_grade': fonction_grade,
                        'age': age,
                        'date_naissance': date_naissance,
                        'anciennete': anciennete,
                        'source_file': 'PPA&GAT&PT.xlsx',
                        'sheet_name': sheet_name,
                        # Champs de formation (seront ajoutés par Naima si disponibles)
                        'formation': None,
                        'periode': None,
                        'status': None
                    }

                    print(f"✅ Données principales stockées: {matricule} - {full_name}")

                except Exception as e:
                    print(f"❌ Erreur ligne {index}: {e}")
                    continue

    except Exception as e:
        print(f"❌ Erreur lors du chargement de {file_path}: {e}")

    return agents_data

def load_naima_data(file_path, agents_data):
    """
    Charge les données de formation du fichier naima_2022.xlsx et les fusionne
    """
    print(f"📄 Chargement des données de formation de {file_path}")

    try:
        # Lire toutes les feuilles
        excel_file = pd.ExcelFile(file_path)
        sheets = excel_file.sheet_names
        print(f"📋 Feuilles trouvées: {sheets}")

        for sheet_name in sheets:
            print(f"📊 Traitement de la feuille formation: {sheet_name}")
            df = pd.read_excel(file_path, sheet_name=sheet_name)

            # Nettoyer les noms de colonnes
            df.columns = df.columns.str.strip()
            print(f"📋 Colonnes: {list(df.columns)}")

            for index, row in df.iterrows():
                try:
                    # Extraire les données de formation
                    matricule = str(row.get('Matricule', '')).strip()
                    if not matricule or matricule == 'nan':
                        continue

                    nom_complet = str(row.get('Nom complet', '')).strip()
                    formation = str(row.get('Formation', '')).strip()
                    periode = str(row.get('Période', '')).strip()
                    status = str(row.get('Status', '')).strip()

                    # Si l'agent existe déjà (du fichier PPA&GAT&PT), fusionner les données
                    if matricule in agents_data:
                        # Ajouter les données de formation aux données existantes
                        agents_data[matricule]['formation'] = formation
                        agents_data[matricule]['periode'] = periode
                        agents_data[matricule]['status'] = status
                        print(f"🔗 Données de formation fusionnées pour: {matricule} - {agents_data[matricule]['full_name']}")
                    else:
                        # Agent uniquement dans Naima (pas dans PPA&GAT&PT)
                        # Essayer de séparer nom et prénom
                        nom_parts = nom_complet.split(' ')
                        if len(nom_parts) >= 2:
                            prenom = nom_parts[0]
                            nom = ' '.join(nom_parts[1:])
                        else:
                            prenom = ''
                            nom = nom_complet

                        # Créer une nouvelle entrée
                        agents_data[matricule] = {
                            'matricule': matricule,
                            'nom': nom,
                            'prenom': prenom,
                            'nom_complet': nom_complet,
                            'full_name': nom_complet,
                            'affectation': '',
                            'fonction_grade': '',
                            'age': None,
                            'date_naissance': None,
                            'anciennete': None,
                            'source_file': 'naima_2022.xlsx',
                            'sheet_name': sheet_name,
                            'formation': formation,
                            'periode': periode,
                            'status': status
                        }
                        print(f"✅ Nouvel agent formation créé: {matricule} - {nom_complet}")

                except Exception as e:
                    print(f"❌ Erreur ligne {index}: {e}")
                    continue

    except Exception as e:
        print(f"❌ Erreur lors du chargement de {file_path}: {e}")

    return agents_data

def create_agents_from_data(agents_data):
    """
    Crée les agents dans la base de données à partir des données fusionnées
    """
    print(f"👥 Création de {len(agents_data)} agents avec données fusionnées...")

    created_count = 0

    for matricule, data in agents_data.items():
        try:
            # Créer l'agent avec toutes les données (principales + formation)
            agent = Agent.objects.create(
                matricule=data['matricule'],
                nom=data['nom'],
                prenom=data['prenom'],
                nom_complet=data['nom_complet'],
                full_name=data['full_name'],
                affectation=data['affectation'],
                fonction_grade=data['fonction_grade'],
                age=data['age'],
                date_naissance=data['date_naissance'],
                anciennete=data['anciennete'],
                formation=data['formation'],
                periode=data['periode'],
                status=data['status'],
                source_file=data['source_file'],
                sheet_name=data['sheet_name']
            )

            # Afficher les informations de l'agent créé
            info_parts = [f"{data['full_name']}"]
            if data['age']:
                info_parts.append(f"âge: {data['age']}")
            if data['formation']:
                info_parts.append(f"formation: {data['formation'][:30]}...")

            print(f"✅ Agent complet créé: {matricule} - {' | '.join(info_parts)}")
            created_count += 1

        except Exception as e:
            print(f"❌ Erreur création agent {matricule}: {e}")
            continue

    print(f"🎉 {created_count} agents créés avec données complètes (principales + formation)")
    return created_count

def safe_int(value):
    """Convertit une valeur en entier de manière sécurisée"""
    try:
        if pd.isna(value) or value == '' or str(value).strip() == '':
            return None
        return int(float(value))
    except:
        return None

def safe_date(value):
    """Convertit une valeur en date de manière sécurisée"""
    try:
        if pd.isna(value) or value == '':
            return None
        if isinstance(value, datetime):
            return value.date()
        # Essayer de parser différents formats de date
        date_str = str(value).strip()
        for fmt in ['%d/%m/%Y', '%Y-%m-%d', '%d-%m-%Y']:
            try:
                return datetime.strptime(date_str, fmt).date()
            except:
                continue
        return None
    except:
        return None
