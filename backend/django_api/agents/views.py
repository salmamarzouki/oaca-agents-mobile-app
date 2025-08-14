from rest_framework import viewsets, filters, status
from rest_framework.decorators import action, api_view
from rest_framework.response import Response
from django.db.models import Q, Count
from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import render
import json
from .models import Agent
from .serializers import AgentSerializer, AgentListSerializer


class AgentViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Agent model providing full CRUD functionality
    """
    queryset = Agent.objects.all()
    serializer_class = AgentSerializer

    def create(self, request, *args, **kwargs):
        """Create a new agent"""
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            # Set default values
            if not serializer.validated_data.get('source_file'):
                serializer.validated_data['source_file'] = 'Manuel - Application Mobile'
            if not serializer.validated_data.get('sheet_name'):
                serializer.validated_data['sheet_name'] = 'Manuel'

            agent = serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def update(self, request, *args, **kwargs):
        """Update an existing agent"""
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        if serializer.is_valid():
            agent = serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, *args, **kwargs):
        """Delete an agent"""
        instance = self.get_object()
        agent_data = {
            'id': instance.id,
            'matricule': instance.matricule,
            'full_name': instance.get_full_name()
        }
        instance.delete()
        return Response({
            'message': 'Agent supprimé avec succès',
            'deleted_agent': agent_data
        }, status=status.HTTP_200_OK)

    # Class-level attributes for filtering and ordering
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['matricule', 'nom', 'prenom', 'nom_complet']
    ordering_fields = ['matricule', 'nom', 'created_at']
    ordering = ['matricule']

    def get_serializer_class(self):
        """
        Return appropriate serializer based on action
        """
        if self.action == 'list':
            return AgentListSerializer
        return AgentSerializer

    @action(detail=False, methods=['get'])
    def search(self, request):
        """
        Custom search endpoint
        """
        query = request.query_params.get('q', '')
        if query:
            agents = self.queryset.filter(
                Q(matricule__icontains=query) |
                Q(nom__icontains=query) |
                Q(prenom__icontains=query) |
                Q(nom_complet__icontains=query) |
                Q(affectation__icontains=query)
            )
        else:
            agents = self.queryset.all()

        page = self.paginate_queryset(agents)
        if page is not None:
            serializer = AgentListSerializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = AgentListSerializer(agents, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def stats(self, request):
        """
        Get statistics about agents
        """
        total_agents = self.queryset.count()
        by_affectation = {}
        by_source = {}

        for agent in self.queryset.all():
            # Count by affectation
            affectation = agent.affectation or 'Non spécifié'
            by_affectation[affectation] = by_affectation.get(affectation, 0) + 1

            # Count by source file
            source = agent.source_file
            by_source[source] = by_source.get(source, 0) + 1

        return Response({
            'total_agents': total_agents,
            'by_affectation': by_affectation,
            'by_source_file': by_source
        })


@api_view(['GET'])
def agents_list_simple(request):
    """Simple function-based view to list agents"""
    agents = Agent.objects.all()[:20]  # Limit to first 20
    data = []
    for agent in agents:
        data.append({
            'id': agent.id,
            'matricule': agent.matricule,
            'full_name': agent.get_full_name(),
            'affectation': agent.affectation,
            'status': agent.status,
            'source_file': agent.source_file
        })
    return Response(data)


def agents_list_json(request):
    """Simple JSON view to list all agents"""
    agents = Agent.objects.all().order_by('matricule')
    data = []
    for agent in agents:
        data.append({
            'id': agent.id,
            'matricule': agent.matricule,
            'nom': agent.nom,
            'prenom': agent.prenom,
            'nom_complet': agent.nom_complet,
            'full_name': agent.get_full_name(),
            'date_naissance': agent.date_naissance.isoformat() if agent.date_naissance else None,
            'age': agent.age,
            'formation': agent.formation,
            'periode': agent.periode,
            'affectation': agent.affectation,
            'status': agent.status,
            'source_file': agent.source_file,
            'sheet_name': agent.sheet_name,
            'created_at': agent.created_at.isoformat(),
            'updated_at': agent.updated_at.isoformat()
        })
    return JsonResponse({'agents': data, 'count': len(data)})


def agents_ppa_gat_pt_json(request):
    """JSON view for agents from PPA&GAT&PT file"""
    agents = Agent.objects.filter(source_file__contains='PPA&GAT&PT').order_by('matricule')
    data = []
    for agent in agents:
        data.append({
            'id': agent.id,
            'matricule': agent.matricule,
            'nom': agent.nom,
            'prenom': agent.prenom,
            'nom_complet': agent.nom_complet,
            'full_name': agent.get_full_name(),
            'date_naissance': agent.date_naissance.isoformat() if agent.date_naissance else None,
            'age': agent.age,
            'affectation': agent.affectation,
            'source_file': agent.source_file,
            'sheet_name': agent.sheet_name,
            'created_at': agent.created_at.isoformat(),
            'updated_at': agent.updated_at.isoformat()
        })
    return JsonResponse({
        'agents': data,
        'count': len(data),
        'file_type': 'PPA&GAT&PT',
        'attributes': ['matricule', 'nom', 'prenom', 'nom_complet', 'date_naissance', 'age', 'affectation']
    })


def agents_naima_json(request):
    """JSON view for agents from Naima 2022 file"""
    agents = Agent.objects.filter(source_file__contains='naima').order_by('matricule')
    data = []
    for agent in agents:
        data.append({
            'id': agent.id,
            'matricule': agent.matricule,
            'nom': agent.nom,
            'prenom': agent.prenom,
            'nom_complet': agent.nom_complet,
            'full_name': agent.get_full_name(),
            'formation': agent.formation,
            'periode': agent.periode,
            'affectation': agent.affectation,
            'status': agent.status,
            'source_file': agent.source_file,
            'sheet_name': agent.sheet_name,
            'created_at': agent.created_at.isoformat(),
            'updated_at': agent.updated_at.isoformat()
        })
    return JsonResponse({
        'agents': data,
        'count': len(data),
        'file_type': 'Naima 2022',
        'attributes': ['matricule', 'nom', 'prenom', 'nom_complet', 'formation', 'periode', 'affectation', 'status']
    })


def agents_by_fonction_json(request):
    """JSON view for agents classified by function/grade"""
    agents = Agent.objects.all().order_by('matricule')

    # Group agents by function
    functions_data = {}

    for agent in agents:
        fonction = agent.get_fonction_grade()
        if fonction not in functions_data:
            functions_data[fonction] = []

        agent_data = {
            'id': agent.id,
            'matricule': agent.matricule,
            'nom': agent.nom,
            'prenom': agent.prenom,
            'nom_complet': agent.nom_complet,
            'full_name': agent.get_full_name(),
            'date_naissance': agent.date_naissance.isoformat() if agent.date_naissance else None,
            'age': agent.age,
            'anciennete': agent.get_anciennete_years(),
            'formation': agent.formation,
            'periode': agent.periode,
            'affectation': agent.affectation,
            'status': agent.status,
            'fonction_grade': fonction,
            'source_file': agent.source_file,
            'sheet_name': agent.sheet_name,
            'created_at': agent.created_at.isoformat(),
            'updated_at': agent.updated_at.isoformat()
        }
        functions_data[fonction].append(agent_data)

    # Calculate statistics
    total_agents = agents.count()
    functions_stats = {}
    for fonction, agents_list in functions_data.items():
        functions_stats[fonction] = len(agents_list)

    return JsonResponse({
        'functions': functions_data,
        'statistics': functions_stats,
        'total_agents': total_agents,
        'available_functions': list(functions_data.keys())
    })


def agents_by_sheets_json(request):
    """JSON view for agents organized by file and sheet"""
    agents = Agent.objects.all().order_by('source_file', 'sheet_name', 'matricule')

    # Group by file and sheet
    files_data = {}

    # First, create PPA&GAT&PT file structure
    ppa_gat_pt_agents = agents.filter(source_file__contains='PPA&GAT&PT')
    if ppa_gat_pt_agents.exists():
        files_data['PPA_GAT_PT'] = {
            'file_name': 'Liste des agents aux unités PPA&GAT&PT',
            'sheets': {},
            'total_agents': 0
        }

        for agent in ppa_gat_pt_agents:
            sheet_name = (agent.sheet_name or 'Unknown').strip()
            if sheet_name not in files_data['PPA_GAT_PT']['sheets']:
                files_data['PPA_GAT_PT']['sheets'][sheet_name] = []

            agent_data = {
                'id': agent.id,
                'matricule': agent.matricule,
                'nom': agent.nom,
                'prenom': agent.prenom,
                'nom_complet': agent.nom_complet,
                'full_name': agent.get_full_name(),
                'date_naissance': agent.date_naissance.isoformat() if agent.date_naissance else None,
                'age': agent.age,
                'anciennete': agent.get_anciennete_years(),
                'formation': agent.formation,
                'periode': agent.periode,
                'affectation': agent.affectation,
                'status': agent.status,
                'fonction_grade': agent.get_fonction_grade(),
                'source_file': agent.source_file,
                'sheet_name': agent.sheet_name,
                'created_at': agent.created_at.isoformat(),
                'updated_at': agent.updated_at.isoformat()
            }

            files_data['PPA_GAT_PT']['sheets'][sheet_name].append(agent_data)
            files_data['PPA_GAT_PT']['total_agents'] += 1

    # Second, create Naima 2022 file structure with ALL agents that have formation data
    # We need to manually create the structure since we know the expected data
    agents_with_formation = agents.filter(formation__isnull=False).exclude(formation='')

    # Create Naima 2022 structure with all 3 sheets
    files_data['NAIMA_2022'] = {
        'file_name': 'Liste des agents 2022 Naima',
        'sheets': {
            'PPA': [],
            'Passerelle': [],
            'GAT': []
        },
        'total_agents': 0
    }

    # Add agents with formation to their respective sheets
    for agent in agents_with_formation:
        sheet_name = (agent.sheet_name or 'GAT').strip()  # Default to GAT if no sheet, and strip spaces
        if sheet_name not in files_data['NAIMA_2022']['sheets']:
            files_data['NAIMA_2022']['sheets'][sheet_name] = []

        agent_data = {
            'id': agent.id,
            'matricule': agent.matricule,
            'nom': agent.nom,
            'prenom': agent.prenom,
            'nom_complet': agent.nom_complet,
            'full_name': agent.get_full_name(),
            'date_naissance': agent.date_naissance.isoformat() if agent.date_naissance else None,
            'age': agent.age,
            'anciennete': agent.get_anciennete_years(),
            'formation': agent.formation,
            'periode': agent.periode,
            'affectation': agent.affectation,
            'status': agent.status,
            'fonction_grade': agent.get_fonction_grade(),
            'source_file': agent.source_file,
            'sheet_name': agent.sheet_name,
            'created_at': agent.created_at.isoformat(),
            'updated_at': agent.updated_at.isoformat()
        }

        files_data['NAIMA_2022']['sheets'][sheet_name].append(agent_data)
        files_data['NAIMA_2022']['total_agents'] += 1

    # Remove empty sheets
    files_data['NAIMA_2022']['sheets'] = {
        k: v for k, v in files_data['NAIMA_2022']['sheets'].items() if v
    }

    return JsonResponse({
        'files': files_data,
        'total_agents': Agent.objects.count()
    })


def agents_by_airports_json(request):
    """JSON view for agents organized by airports"""
    # Exclure les aéroports de test
    agents = Agent.objects.exclude(affectation__isnull=True).exclude(affectation='').exclude(affectation__icontains='test').order_by('affectation', 'matricule')

    # Group agents by airport
    airports_data = {}

    for agent in agents:
        airport_code = agent.affectation

        if airport_code not in airports_data:
            airports_data[airport_code] = {
                'code': airport_code,
                'name': get_airport_name(airport_code),
                'agents': []
            }

        agent_data = {
            'id': agent.id,
            'matricule': agent.matricule,
            'nom': agent.nom,
            'prenom': agent.prenom,
            'nom_complet': agent.nom_complet,
            'full_name': agent.get_full_name(),
            'date_naissance': agent.date_naissance.isoformat() if agent.date_naissance else None,
            'age': agent.age,
            'affectation': agent.affectation,
            'formation': agent.formation,
            'periode': agent.periode,
            'fonction_actuelle': agent.fonction_actuelle,
            'fonction_grade': agent.get_fonction_grade(),
            'source_file': agent.source_file,
            'sheet_name': agent.sheet_name,
            'status': agent.status,
            'created_at': agent.created_at.isoformat(),
            'updated_at': agent.updated_at.isoformat()
        }

        airports_data[airport_code]['agents'].append(agent_data)

    # Convert to list and sort by airport code
    airports_list = list(airports_data.values())
    airports_list.sort(key=lambda x: x['code'])

    return JsonResponse({
        'airports': airports_list,
        'total_airports': len(airports_list),
        'total_agents': sum(len(airport['agents']) for airport in airports_list)
    })


def get_airport_name(airport_code):
    """Get the full name of an airport from its code"""
    airport_names = {
        'AITC': 'Tunis-Carthage',
        'AIDZ': 'Djerba-Zarzis',
        'AITN': 'Tunis-El Borma',
        'AIST': 'Sfax-Thyna',
        'AIGK': 'Gafsa-Ksar',
        'AITAD': 'Tabarka-Ain Draham',
        'AIGM': 'Monastir',
    }
    return airport_names.get(airport_code, airport_code)


# CRUD API Endpoints
@csrf_exempt
@api_view(['POST'])
def create_agent_api(request):
    """API endpoint to create a new agent"""
    try:
        data = json.loads(request.body)

        # Validate required fields
        if not data.get('matricule') or not data.get('nom'):
            return JsonResponse({
                'error': 'Matricule et nom sont obligatoires'
            }, status=400)

        # Check if matricule already exists
        if Agent.objects.filter(matricule=data['matricule']).exists():
            return JsonResponse({
                'error': f'Un agent avec le matricule {data["matricule"]} existe déjà'
            }, status=400)

        # Create agent
        agent = Agent.objects.create(
            matricule=data['matricule'],
            nom=data.get('nom', ''),
            prenom=data.get('prenom', ''),
            nom_complet=data.get('nom_complet', ''),
            date_naissance=data.get('date_naissance') if data.get('date_naissance') else None,
            age=data.get('age') if data.get('age') else None,
            affectation=data.get('affectation', ''),
            formation=data.get('formation', ''),
            periode=data.get('periode', ''),
            status=data.get('status', ''),
            source_file=data.get('source_file', 'Manuel - Application Mobile'),
            sheet_name=data.get('sheet_name', 'Manuel')
        )

        # Return created agent data
        agent_data = {
            'id': agent.id,
            'matricule': agent.matricule,
            'nom': agent.nom,
            'prenom': agent.prenom,
            'nom_complet': agent.nom_complet,
            'full_name': agent.get_full_name(),
            'date_naissance': agent.date_naissance.isoformat() if agent.date_naissance else None,
            'age': agent.age,
            'anciennete': agent.get_anciennete_years(),
            'formation': agent.formation,
            'periode': agent.periode,
            'affectation': agent.affectation,
            'status': agent.status,
            'fonction_grade': agent.get_fonction_grade(),
            'source_file': agent.source_file,
            'sheet_name': agent.sheet_name,
            'created_at': agent.created_at.isoformat(),
            'updated_at': agent.updated_at.isoformat()
        }

        return JsonResponse({
            'message': 'Agent créé avec succès',
            'agent': agent_data
        }, status=201)

    except json.JSONDecodeError:
        return JsonResponse({'error': 'Données JSON invalides'}, status=400)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@csrf_exempt
@api_view(['PUT'])
def update_agent_api(request, agent_id):
    """API endpoint to update an existing agent"""
    try:
        agent = Agent.objects.get(id=agent_id)
        data = json.loads(request.body)

        # Update fields
        if 'matricule' in data:
            # Check if new matricule already exists (excluding current agent)
            if Agent.objects.filter(matricule=data['matricule']).exclude(id=agent_id).exists():
                return JsonResponse({
                    'error': f'Un autre agent avec le matricule {data["matricule"]} existe déjà'
                }, status=400)
            agent.matricule = data['matricule']

        if 'nom' in data:
            agent.nom = data['nom']
        if 'prenom' in data:
            agent.prenom = data['prenom']
        if 'nom_complet' in data:
            agent.nom_complet = data['nom_complet']
        if 'date_naissance' in data:
            agent.date_naissance = data['date_naissance'] if data['date_naissance'] else None
        if 'age' in data:
            agent.age = data['age'] if data['age'] else None
        if 'affectation' in data:
            agent.affectation = data['affectation']
        if 'formation' in data:
            agent.formation = data['formation']
        if 'periode' in data:
            agent.periode = data['periode']
        if 'status' in data:
            agent.status = data['status']
        if 'sheet_name' in data:
            agent.sheet_name = data['sheet_name']

        agent.save()

        # Return updated agent data
        agent_data = {
            'id': agent.id,
            'matricule': agent.matricule,
            'nom': agent.nom,
            'prenom': agent.prenom,
            'nom_complet': agent.nom_complet,
            'full_name': agent.get_full_name(),
            'date_naissance': agent.date_naissance.isoformat() if agent.date_naissance else None,
            'age': agent.age,
            'anciennete': agent.get_anciennete_years(),
            'formation': agent.formation,
            'periode': agent.periode,
            'affectation': agent.affectation,
            'status': agent.status,
            'fonction_grade': agent.get_fonction_grade(),
            'source_file': agent.source_file,
            'sheet_name': agent.sheet_name,
            'created_at': agent.created_at.isoformat(),
            'updated_at': agent.updated_at.isoformat()
        }

        return JsonResponse({
            'message': 'Agent mis à jour avec succès',
            'agent': agent_data
        })

    except Agent.DoesNotExist:
        return JsonResponse({'error': 'Agent non trouvé'}, status=404)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Données JSON invalides'}, status=400)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@csrf_exempt
@api_view(['DELETE'])
def delete_agent_api(request, agent_id):
    """API endpoint to delete an agent"""
    try:
        agent = Agent.objects.get(id=agent_id)

        # Store agent data before deletion
        agent_data = {
            'id': agent.id,
            'matricule': agent.matricule,
            'full_name': agent.get_full_name()
        }

        agent.delete()

        return JsonResponse({
            'message': 'Agent supprimé avec succès',
            'deleted_agent': agent_data
        })

    except Agent.DoesNotExist:
        return JsonResponse({'error': 'Agent non trouvé'}, status=404)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


def agents_web_view(request):
    """Vue web pour afficher tous les agents"""
    agents = Agent.objects.all().order_by('matricule')
    context = {
        'agents': agents,
        'total_agents': agents.count(),
        'affectations': agents.values_list('affectation', flat=True).distinct()
    }
    return render(request, 'agents/agents_list.html', context)


def agents_stats_json(request):
    """JSON view for agents statistics"""
    try:
        # Compter le total des agents
        total_agents = Agent.objects.count()

        # Compter par affectation (aéroport)
        agents_by_affectation = {}
        affectations = Agent.objects.values('affectation').annotate(count=Count('affectation'))
        for item in affectations:
            affectation = item['affectation'] or 'Non affecté'
            agents_by_affectation[affectation] = item['count']

        # Compter par fichier source
        agents_by_file = {}
        files = Agent.objects.values('source_file').annotate(count=Count('source_file'))
        for item in files:
            file_name = item['source_file'] or 'Fichier inconnu'
            agents_by_file[file_name] = item['count']

        return JsonResponse({
            'total_agents': total_agents,
            'total_files': len(agents_by_file),
            'agents_by_affectation': agents_by_affectation,
            'agents_by_file': agents_by_file,
        })

    except Exception as e:
        return JsonResponse({
            'error': f'Erreur lors du calcul des statistiques: {str(e)}'
        }, status=500)


def home_view(request):
    """
    Vue pour la page d'accueil affichant les aéroports et le nombre d'agents
    """
    try:
        # Obtenir les statistiques des aéroports
        agents_by_affectation = {}
        agents = Agent.objects.all()

        for agent in agents:
            affectation = agent.affectation or 'Non spécifié'
            if affectation not in agents_by_affectation:
                agents_by_affectation[affectation] = 0
            agents_by_affectation[affectation] += 1

        # Créer le HTML de la page d'accueil
        html_content = f"""
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>OACA Agents - Liste alphabétique des aéroports</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    margin: 0;
                    padding: 20px;
                    min-height: 100vh;
                }}
                .container {{
                    max-width: 1200px;
                    margin: 0 auto;
                    background: white;
                    border-radius: 10px;
                    padding: 20px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }}
                .header {{
                    text-align: center;
                    color: #333;
                    margin-bottom: 30px;
                }}
                .stats {{
                    text-align: center;
                    color: #666;
                    margin-bottom: 30px;
                }}
                .airport-card {{
                    background: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 8px;
                    padding: 15px;
                    margin: 10px 0;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    transition: transform 0.2s;
                    text-decoration: none;
                    color: inherit;
                    cursor: pointer;
                }}
                .airport-card:hover {{
                    transform: translateY(-2px);
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                    background: #e9ecef;
                }}
                .airport-info {{
                    display: flex;
                    align-items: center;
                }}
                .airport-icon {{
                    font-size: 24px;
                    margin-right: 15px;
                }}
                .airport-name {{
                    font-weight: bold;
                    color: #333;
                }}
                .agent-count {{
                    background: #007bff;
                    color: white;
                    padding: 5px 15px;
                    border-radius: 20px;
                    font-weight: bold;
                }}
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>🛩️ Tous les agents</h1>
                    <h2>Liste alphabétique des aéroports</h2>
                </div>

                <div class="stats">
                    <p>{len(agents_by_affectation)} aéroports • {sum(agents_by_affectation.values())} agents</p>
                </div>

                <div class="airports-list">
        """

        # Ajouter chaque aéroport
        for affectation, count in sorted(agents_by_affectation.items()):
            if affectation and affectation != 'Non spécifié':
                html_content += f"""
                    <a href="/airport/{affectation}/" class="airport-card">
                        <div class="airport-info">
                            <div class="airport-icon">✈️</div>
                            <div class="airport-name">Aéroport {affectation}</div>
                        </div>
                        <div class="agent-count">{count}</div>
                    </a>
                """

        html_content += """
                </div>
            </div>
        </body>
        </html>
        """

        return HttpResponse(html_content)

    except Exception as e:
        return HttpResponse(f"<h1>Erreur</h1><p>{str(e)}</p>", status=500)


def airport_detail_view(request, airport_code):
    """
    Vue pour afficher les agents d'un aéroport spécifique
    """
    try:
        # Obtenir les agents de cet aéroport
        agents = Agent.objects.filter(affectation=airport_code)

        if not agents.exists():
            return HttpResponse(f"<h1>Aucun agent trouvé pour l'aéroport {airport_code}</h1>", status=404)

        # Créer le HTML pour la page de détail de l'aéroport
        html_content = f"""
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Agents - Aéroport {airport_code}</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    margin: 0;
                    padding: 20px;
                    min-height: 100vh;
                }}
                .container {{
                    max-width: 1200px;
                    margin: 0 auto;
                    background: white;
                    border-radius: 10px;
                    padding: 20px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }}
                .header {{
                    text-align: center;
                    color: #333;
                    margin-bottom: 30px;
                }}
                .back-button {{
                    display: inline-block;
                    background: #6c757d;
                    color: white;
                    padding: 10px 20px;
                    text-decoration: none;
                    border-radius: 5px;
                    margin-bottom: 20px;
                }}
                .back-button:hover {{
                    background: #5a6268;
                }}
                .stats {{
                    text-align: center;
                    color: #666;
                    margin-bottom: 30px;
                }}
                .agent-card {{
                    background: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 8px;
                    padding: 15px;
                    margin: 10px 0;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }}
                .agent-info {{
                    display: flex;
                    flex-direction: column;
                }}
                .agent-name {{
                    font-weight: bold;
                    color: #333;
                    font-size: 18px;
                }}
                .agent-details {{
                    color: #666;
                    font-size: 14px;
                    margin-top: 5px;
                }}
                .agent-icon {{
                    font-size: 24px;
                    color: #007bff;
                }}
                .table-container {{
                    overflow-x: auto;
                }}
                table {{
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }}
                th, td {{
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #ddd;
                }}
                th {{
                    background-color: #f8f9fa;
                    font-weight: bold;
                }}
                tr:hover {{
                    background-color: #f5f5f5;
                }}
            </style>
        </head>
        <body>
            <div class="container">
                <a href="/" class="back-button">← Retour à la liste des aéroports</a>

                <div class="header">
                    <h1>✈️ Aéroport {airport_code}</h1>
                    <h2>Liste des agents</h2>
                </div>

                <div class="stats">
                    <p>{len(agents)} agents</p>
                </div>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Matricule</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Fonction Actuelle</th>
                                <th>Formation</th>
                                <th>Affectation</th>
                            </tr>
                        </thead>
                        <tbody>
        """

        # Ajouter chaque agent
        for agent in agents:
            matricule = agent.matricule or ''
            nom = agent.nom or ''
            prenom = agent.prenom or ''

            # Utiliser la méthode get_fonction_grade() comme l'application mobile
            fonction_actuelle = agent.get_fonction_grade()

            formation = agent.formation or 'Non spécifiée'
            affectation = agent.affectation or 'Non spécifiée'

            html_content += f"""
                            <tr>
                                <td>{matricule}</td>
                                <td>{nom}</td>
                                <td>{prenom}</td>
                                <td>{fonction_actuelle}</td>
                                <td>{formation}</td>
                                <td>{affectation}</td>
                            </tr>
            """

        html_content += """
                        </tbody>
                    </table>
                </div>
            </div>
        </body>
        </html>
        """

        return HttpResponse(html_content)

    except Exception as e:
        return HttpResponse(f"<h1>Erreur</h1><p>{str(e)}</p>", status=500)
