import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/agent.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/mobile-api';

  // Cache pour optimiser les performances
  List<Agent>? _cachedAgents;
  Map<String, dynamic>? _cachedStats;
  DateTime? _lastAgentsFetch;
  DateTime? _lastStatsFetch;
  static const Duration _cacheTimeout = Duration(minutes: 5);

  // Flag pour forcer l'utilisation des vraies données
  // final bool _useRealData = true;

  // For Android emulator, use: http://10.0.2.2:8000/mobile-api
  // For iOS simulator, use: http://127.0.0.1:8000/mobile-api
  // For physical device, use your computer's IP address

  Future<List<Agent>> getAgents({bool forceRefresh = false}) async {
    // Utiliser le cache si disponible et récent
    if (!forceRefresh &&
        _cachedAgents != null &&
        _lastAgentsFetch != null &&
        DateTime.now().difference(_lastAgentsFetch!) < _cacheTimeout) {
      return _cachedAgents!;
    }

    // FORCER L'UTILISATION DE L'API DJANGO POUR AVOIR LES 97 AGENTS
    try {
      if (kDebugMode) {
        print('🌐 Connexion à l\'API Django pour charger tous les agents...');
      }
      final agents = await _fetchFromDjangoAPI();
      _cachedAgents = agents;
      _lastAgentsFetch = DateTime.now();
      if (kDebugMode) {
        print('✅ ${agents.length} agents chargés depuis Django API');
      }
      return agents;
    } catch (e) {
      if (kDebugMode) {
        print('❌ ERREUR API Django: $e');
        print('🔄 Nouvelle tentative avec timeout plus long...');
      }

      // Deuxième tentative avec timeout plus long
      try {
        final agents = await _fetchFromDjangoAPIWithLongerTimeout();
        _cachedAgents = agents;
        _lastAgentsFetch = DateTime.now();
        if (kDebugMode) {
          print('✅ ${agents.length} agents chargés (2ème tentative)');
        }
        return agents;
      } catch (e2) {
        if (kDebugMode) {
          print('❌ ÉCHEC TOTAL: $e2');
          print('⚠️ Vérifiez que le serveur Django fonctionne sur http://127.0.0.1:8000');
        }

        // En dernier recours, retourner une liste vide avec un message d'erreur
        throw Exception('Impossible de se connecter au serveur Django. Vérifiez que le serveur est démarré.');
      }
    }
  }

  // Méthode pour récupérer les données depuis l'API Django
  Future<List<Agent>> _fetchFromDjangoAPI() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/mobile-api/agents/'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> agentsJson = data['agents'] ?? [];

      return agentsJson.map((json) => Agent(
        id: json['id'] ?? 0,
        matricule: json['matricule'] ?? '',
        nom: json['nom'] ?? '',
        prenom: json['prenom'],
        nomComplet: json['nom_complet'],
        fullName: json['full_name'] ?? '',
        affectation: json['affectation'] ?? '',
        periode: json['periode'],
        sourceFile: json['source_file'] ?? 'Django API',
        status: json['status'],
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      )).toList();
    } else {
      throw Exception('Erreur API: ${response.statusCode}');
    }
  }

  // Méthode avec timeout plus long pour la deuxième tentative
  Future<List<Agent>> _fetchFromDjangoAPIWithLongerTimeout() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/mobile-api/agents/'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(Duration(seconds: 30)); // Timeout plus long

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> agentsJson = data['agents'] ?? [];

      return agentsJson.map((json) => Agent(
        id: json['id'] ?? 0,
        matricule: json['matricule'] ?? '',
        nom: json['nom'] ?? '',
        prenom: json['prenom'],
        nomComplet: json['nom_complet'],
        fullName: json['full_name'] ?? '',
        affectation: json['affectation'] ?? '',
        periode: json['periode'],
        sourceFile: json['source_file'] ?? 'Django API',
        status: json['status'],
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      )).toList();
    } else {
      throw Exception('Erreur API: ${response.statusCode}');
    }
  }

  // Méthode pour les vraies données des fichiers Excel - SYNCHRONISÉ AVEC DJANGO
  List<Agent> _getRealExcelData() {
    // VRAIES DONNÉES DES FICHIERS EXCEL - AGENTS DE DJANGO
    return [
      // Agent 1 - Abassi Atef
      Agent(
        id: 697,
        matricule: "10009",
        nom: "Atef",
        prenom: "Abassi",
        nomComplet: "Abassi Atef",
        fullName: "Abassi Atef",
        affectation: "AITC",
        periode: "Du 01/05 au 30/05/2012",
        sourceFile: "Liste des agents aux unités PPA&GAT&PT .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 2 - Khriji Belgacem
      Agent(
        id: 724,
        matricule: "10010",
        nom: "Belgacem",
        prenom: "Khriji",
        nomComplet: "Khriji Belgacem",
        fullName: "Khriji Belgacem",
        affectation: "AITC",
        periode: "Du 25/02/2019 au 01/03/2019",
        sourceFile: "Liste des agents aux unités PPA&GAT&PT .xlsx",
        status: "ok",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 3 - Bounagra Raouf
      Agent(
        id: 709,
        matricule: "10021",
        nom: "Raouf",
        prenom: "Bounagra",
        nomComplet: "Bounagra Raouf",
        fullName: "Bounagra Raouf",
        affectation: "AIDZ",
        periode: "Du 01/06 au 31/07/2014",
        sourceFile: "Liste des agents aux unités PPA&GAT&PT .xlsx",
        status: "ok",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 4 - Bouzrad Imed Eddine
      Agent(
        id: 730,
        matricule: "10041",
        nom: "Eddine",
        prenom: "Bouzrad Imed",
        nomComplet: "Bouzrad Imed Eddine",
        fullName: "Bouzrad Imed Eddine",
        affectation: "AIGK",
        periode: "Du 21/09/2020 au 25/09/2020",
        sourceFile: "Liste des agents aux unités PPA&GAT&PT .xlsx",
        status: "ok",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 5 - Ouertani Asma
      Agent(
        id: 710,
        matricule: "11151",
        nom: "Asma",
        prenom: "Ouertani",
        nomComplet: "Ouertani Asma",
        fullName: "Ouertani Asma",
        affectation: "AIDZ",
        periode: "Du 01/06 au 31/07/2014",
        sourceFile: "Liste des agents aux unités PPA&GAT&PT .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 6 - Hamed Ben Asker
      Agent(
        id: 658,
        matricule: "12000",
        nom: "Asker",
        prenom: "Hamed Ben",
        nomComplet: "Hamed Ben Asker",
        fullName: "Hamed Ben Asker",
        affectation: "AITC",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 7 - Issam Bouhéni
      Agent(
        id: 659,
        matricule: "12008",
        nom: "Bouhéni",
        prenom: "Issam",
        nomComplet: "Issam Bouhéni",
        fullName: "Issam Bouhéni",
        affectation: "AITC",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 8 - Ben Abed Ahmed
      Agent(
        id: 660,
        matricule: "12009",
        nom: "Ahmed",
        prenom: "Ben Abed",
        nomComplet: "Ben Abed Ahmed",
        fullName: "Ben Abed Ahmed",
        affectation: "AIDZ",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 9 - Anis Troudi
      Agent(
        id: 661,
        matricule: "12010",
        nom: "Troudi",
        prenom: "Anis",
        nomComplet: "Anis Troudi",
        fullName: "Anis Troudi",
        affectation: "AITC",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 10 - Mondher Guizeni
      Agent(
        id: 662,
        matricule: "12012",
        nom: "Guizeni",
        prenom: "Mondher",
        nomComplet: "Mondher Guizeni",
        fullName: "Mondher Guizeni",
        affectation: "AITC",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Plus d'agents des deux fichiers Excel
      // Agent 11 - Malek Trabelsi
      Agent(
        id: 663,
        matricule: "12016",
        nom: "Malek",
        prenom: "Trabelsi",
        nomComplet: "Trabelsi Malek",
        fullName: "Trabelsi Malek",
        affectation: "AIDZ",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 12 - Salem Bouden
      Agent(
        id: 664,
        matricule: "12030",
        nom: "Salem",
        prenom: "Bouden",
        nomComplet: "Bouden Salem",
        fullName: "Bouden Salem",
        affectation: "AIDZ",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 13 - Fakhreddine Jlassi
      Agent(
        id: 665,
        matricule: "12042",
        nom: "Fakhreddine",
        prenom: "Jlassi",
        nomComplet: "Jlassi Fakhreddine",
        fullName: "Jlassi Fakhreddine",
        affectation: "AIDZ",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 14 - Imed Amer
      Agent(
        id: 666,
        matricule: "12060",
        nom: "Imed",
        prenom: "Amer",
        nomComplet: "Amer Imed",
        fullName: "Amer Imed",
        affectation: "AIGK",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Agent 15 - Abdelfattah Douahem
      Agent(
        id: 667,
        matricule: "12073",
        nom: "Abdelfattah",
        prenom: "Douahem",
        nomComplet: "Douahem Abdelfattah",
        fullName: "Douahem Abdelfattah",
        affectation: "AIGK",
        periode: null,
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Méthode publique pour accéder aux vraies données Excel - UTILISE L'API DJANGO
  List<Agent> getMockAgents() {
    // Essayer de charger depuis l'API Django en premier
    try {
      // Si on a des données en cache, les utiliser
      if (_cachedAgents != null && _cachedAgents!.isNotEmpty) {
        return _cachedAgents!;
      }
      // Sinon, utiliser les données locales comme fallback
      return _getRealExcelData();
    } catch (e) {
      // En cas d'erreur, utiliser les données locales
      return _getRealExcelData();
    }
  }


  Future<Agent> getAgent(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/agents/$id/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Agent.fromJson(data);
      } else {
        throw Exception('Failed to load agent: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching agent: $e');
    }
  }

  Future<List<Agent>> searchAgents(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/agents/search/?q=$query'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> agentsJson = data['results'];
        return agentsJson.map((json) => Agent.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search agents: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching agents: $e');
    }
  }

  Future<Map<String, dynamic>> deleteAgent(int agentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/agents/delete/$agentId/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Invalider le cache après suppression
        _cachedAgents = null;
        _lastAgentsFetch = null;

        return data;
      } else if (response.statusCode == 404) {
        throw Exception('Agent non trouvé');
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Erreur lors de la suppression');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Erreur de connexion lors de la suppression: $e');
    }
  }

  Future<Map<String, dynamic>> getStats({bool forceRefresh = false}) async {
    // Utiliser le cache si disponible et récent
    if (!forceRefresh &&
        _cachedStats != null &&
        _lastStatsFetch != null &&
        DateTime.now().difference(_lastStatsFetch!) < _cacheTimeout) {
      return _cachedStats!;
    }

    // FORCER L'UTILISATION DE L'API DJANGO POUR LES STATS
    try {
      if (kDebugMode) {
        print('📊 Chargement des statistiques depuis Django API...');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/agents/stats/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15)); // Timeout plus long

      if (response.statusCode == 200) {
        _cachedStats = json.decode(response.body);
        _lastStatsFetch = DateTime.now();
        if (kDebugMode) {
          print('✅ Statistiques chargées: ${_cachedStats!['total_agents']} agents');
        }
        return _cachedStats!;
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur stats API: $e');
        print('📊 Calcul des stats depuis les agents chargés...');
      }

      // Calculer les stats depuis les agents déjà chargés
      if (_cachedAgents != null && _cachedAgents!.isNotEmpty) {
        return _calculateStatsFromAgents(_cachedAgents!);
      }

      // En dernier recours, essayer de charger les agents puis calculer les stats
      try {
        final agents = await getAgents();
        return _calculateStatsFromAgents(agents);
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Impossible de calculer les stats: $e2');
        }
        return _getMockStats(); // Fallback vers les données de test
      }
    }
  }

  // Calculer les statistiques depuis une liste d'agents
  Map<String, dynamic> _calculateStatsFromAgents(List<Agent> agents) {
    final agentsByFile = <String, int>{};
    final agentsByAffectation = <String, int>{};

    for (final agent in agents) {
      // Compter par fichier source
      agentsByFile[agent.sourceFile] = (agentsByFile[agent.sourceFile] ?? 0) + 1;

      // Compter par affectation
      final affectation = agent.affectation ?? 'Non affecté';
      agentsByAffectation[affectation] = (agentsByAffectation[affectation] ?? 0) + 1;
    }

    return {
      'total_agents': agents.length,
      'total_files': agentsByFile.length,
      'agents_by_file': agentsByFile,
      'agents_by_affectation': agentsByAffectation,
    };
  }

  Map<String, dynamic> _getMockStats() {
    final agents = _getRealExcelData(); // Utiliser les vraies données
    return _calculateStatsFromAgents(agents);
  }
}
