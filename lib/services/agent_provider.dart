import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/agent.dart';
import 'api_service.dart';

class AgentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Agent> _agents = [];
  List<Agent> _filteredAgents = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _stats;
  String? _selectedAffectation;

  List<Agent> get agents => _agents;
  List<Agent> get filteredAgents => _filteredAgents;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get stats => _stats;
  String? get selectedAffectation => _selectedAffectation;

  // Obtenir les affectations uniques
  List<String> getUniqueAffectations() {
    final affectations = _agents
        .map((agent) => agent.affectation)
        .where((affectation) => affectation != null && affectation.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    affectations.sort();
    return affectations;
  }

  Future<void> loadAgents({bool forceRefresh = false}) async {
    // Éviter les chargements multiples simultanés
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _agents = await _apiService.getAgents(forceRefresh: forceRefresh);
      _filteredAgents = List.from(_agents);
      _error = null; // Clear any previous errors

      // Charger les stats en parallèle pour améliorer les performances
      unawaited(loadStats(forceRefresh: forceRefresh));
    } catch (e) {
      _error = e.toString();
      // En cas d'erreur, on garde les données existantes si disponibles
      if (_agents.isEmpty) {
        // Si aucune donnée n'est disponible, on utilise les données mock
        _agents = await _apiService.getAgents(forceRefresh: false);
        _filteredAgents = List.from(_agents);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour charger les agents RAPIDEMENT - SANS BLOCAGE
  Future<void> loadAgentsWithFallback() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // CHARGER IMMÉDIATEMENT LES DONNÉES LOCALES POUR ÉVITER LE BLOCAGE
      debugPrint('📂 Chargement immédiat des données locales...');
      _agents = _apiService.getMockAgents();
      _filteredAgents = List.from(_agents);
      _error = null;
      _isLoading = false;

      // Notifier immédiatement pour débloquer l'interface
      notifyListeners();
      debugPrint('✅ ${_agents.length} agents chargés instantanément');

      // Essayer l'API Django en arrière-plan (optionnel)
      _tryLoadFromAPI();

      // Charger les stats en arrière-plan
      unawaited(loadStats(forceRefresh: false));
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Erreur lors du chargement: $e');
    }
  }

  // Tentative de chargement API en arrière-plan
  void _tryLoadFromAPI() async {
    try {
      final apiAgents = await _apiService.getAgents(forceRefresh: true);
      if (apiAgents.length > _agents.length) {
        _agents = apiAgents;
        _filteredAgents = List.from(_agents);
        notifyListeners();
        debugPrint('🔄 Mis à jour avec ${_agents.length} agents depuis Django API');
      }
    } catch (e) {
      debugPrint('⚠️ API Django non disponible, utilisation des données locales');
    }
  }

  Future<void> loadStats({bool forceRefresh = false}) async {
    try {
      _stats = await _apiService.getStats(forceRefresh: forceRefresh);
      notifyListeners(); // Notifier seulement quand les stats sont chargées
    } catch (e) {
      // Stats loading is optional, don't set error for this
      if (kDebugMode) {
        print('Failed to load stats: $e');
      }
    }
  }

  Timer? _searchTimer;

  void searchAgents(String query) {
    // Debounce la recherche pour éviter trop d'appels
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _filteredAgents = List.from(_agents);
      notifyListeners();
      return;
    }

    // Recherche locale uniquement pour de meilleures performances
    final queryLower = query.toLowerCase();
    _filteredAgents = _agents.where((agent) {
      return agent.matricule.toLowerCase().contains(queryLower) ||
             agent.fullName.toLowerCase().contains(queryLower) ||
             (agent.affectation?.toLowerCase().contains(queryLower) ?? false);
    }).toList();

    notifyListeners();
  }

  void filterByAffectation(String? affectation) {
    _selectedAffectation = affectation;
    if (affectation == null || affectation.isEmpty) {
      _filteredAgents = List.from(_agents);
    } else {
      _filteredAgents = _agents.where((agent) => agent.affectation == affectation).toList();
    }
    notifyListeners();
  }

  void filterBySourceFile(String? sourceFile) {
    if (sourceFile == null || sourceFile.isEmpty) {
      _filteredAgents = List.from(_agents);
    } else {
      _filteredAgents = _agents.where((agent) => agent.sourceFile == sourceFile).toList();
    }
    notifyListeners();
  }

  void clearFilters() {
    _selectedAffectation = null;
    _filteredAgents = List.from(_agents);
    notifyListeners();
  }

  Future<bool> deleteAgent(Agent agent) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Appeler l'API pour supprimer l'agent
      await _apiService.deleteAgent(agent.id);

      // Supprimer l'agent des listes locales
      _agents.removeWhere((a) => a.id == agent.id);
      _filteredAgents.removeWhere((a) => a.id == agent.id);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  List<String> get uniqueAffectations {
    return _agents
        .where((agent) => agent.affectation != null)
        .map((agent) => agent.affectation!)
        .toSet()
        .toList()
      ..sort();
  }

  List<String> get uniqueSourceFiles {
    return _agents
        .map((agent) => agent.sourceFile)
        .toSet()
        .toList()
      ..sort();
  }
}
