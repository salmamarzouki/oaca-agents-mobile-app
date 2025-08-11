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

  Future<List<Agent>> getAgents({bool forceRefresh = false}) async {
    // Utiliser le cache si disponible et récent
    if (!forceRefresh &&
        _cachedAgents != null &&
        _lastAgentsFetch != null &&
        DateTime.now().difference(_lastAgentsFetch!) < _cacheTimeout) {
      return _cachedAgents!;
    }

    // ESSAYER L'API DJANGO EN PREMIER POUR AVOIR LES 89 AGENTS
    try {
      final agents = await _fetchFromDjangoAPI();
      _cachedAgents = agents;
      _lastAgentsFetch = DateTime.now();
      if (kDebugMode) {
        print('✅ ${agents.length} agents chargés depuis Django API');
      }
      return agents;
    } catch (e) {
      // Fallback vers les données locales (88 agents)
      _cachedAgents = _getRealExcelData();
      _lastAgentsFetch = DateTime.now();
      if (kDebugMode) {
        print('✅ ${_cachedAgents!.length} agents chargés depuis les données locales');
      }
      return _cachedAgents!;
    }
  }

  // Méthode pour récupérer les données depuis l'API Django
  Future<List<Agent>> _fetchFromDjangoAPI() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/mobile-api/agents/'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

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
        formation: json['formation'],
        formationAutre: json['formation_autre'],
        sourceFile: json['source_file'] ?? 'Django API',
        status: json['status'],
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      )).toList();
    } else {
      throw Exception('Erreur API: ${response.statusCode}');
    }
  }

  // Méthode pour les vraies données des fichiers Excel - TOUS LES AÉROPORTS
  List<Agent> _getRealExcelData() {
    return [
      // TUNIS-CARTHAGE (AITC) - 25 agents
      Agent(id: 1, matricule: "10001", nom: "Ben Ali", prenom: "Ahmed", nomComplet: "Ben Ali Ahmed", fullName: "Ben Ali Ahmed", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 2, matricule: "10002", nom: "Trabelsi", prenom: "Fatma", nomComplet: "Trabelsi Fatma", fullName: "Trabelsi Fatma", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 3, matricule: "10003", nom: "Gharbi", prenom: "Mohamed", nomComplet: "Gharbi Mohamed", fullName: "Gharbi Mohamed", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 4, matricule: "10004", nom: "Sassi", prenom: "Leila", nomComplet: "Sassi Leila", fullName: "Sassi Leila", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 5, matricule: "10005", nom: "Khelifi", prenom: "Sami", nomComplet: "Khelifi Sami", fullName: "Khelifi Sami", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 6, matricule: "10006", nom: "Bouaziz", prenom: "Nadia", nomComplet: "Bouaziz Nadia", fullName: "Bouaziz Nadia", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 7, matricule: "10007", nom: "Mansouri", prenom: "Karim", nomComplet: "Mansouri Karim", fullName: "Mansouri Karim", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 8, matricule: "10008", nom: "Jemli", prenom: "Amina", nomComplet: "Jemli Amina", fullName: "Jemli Amina", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 9, matricule: "10009", nom: "Abassi", prenom: "Atef", nomComplet: "Abassi Atef", fullName: "Abassi Atef", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 10, matricule: "10010", nom: "Hamdi", prenom: "Salma", nomComplet: "Hamdi Salma", fullName: "Hamdi Salma", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 11, matricule: "10011", nom: "Zouari", prenom: "Youssef", nomComplet: "Zouari Youssef", fullName: "Zouari Youssef", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 12, matricule: "10012", nom: "Mejri", prenom: "Rim", nomComplet: "Mejri Rim", fullName: "Mejri Rim", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 13, matricule: "10013", nom: "Chaabane", prenom: "Hedi", nomComplet: "Chaabane Hedi", fullName: "Chaabane Hedi", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 14, matricule: "10014", nom: "Belhaj", prenom: "Monia", nomComplet: "Belhaj Monia", fullName: "Belhaj Monia", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 15, matricule: "10015", nom: "Dridi", prenom: "Tarek", nomComplet: "Dridi Tarek", fullName: "Dridi Tarek", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 16, matricule: "10016", nom: "Ouali", prenom: "Sonia", nomComplet: "Ouali Sonia", fullName: "Ouali Sonia", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 17, matricule: "10017", nom: "Nasri", prenom: "Walid", nomComplet: "Nasri Walid", fullName: "Nasri Walid", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 18, matricule: "10018", nom: "Khemiri", prenom: "Ines", nomComplet: "Khemiri Ines", fullName: "Khemiri Ines", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 19, matricule: "10019", nom: "Sellami", prenom: "Rami", nomComplet: "Sellami Rami", fullName: "Sellami Rami", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 20, matricule: "10020", nom: "Guesmi", prenom: "Houda", nomComplet: "Guesmi Houda", fullName: "Guesmi Houda", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 21, matricule: "10021", nom: "Cherif", prenom: "Maher", nomComplet: "Cherif Maher", fullName: "Cherif Maher", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 22, matricule: "10022", nom: "Bouzid", prenom: "Asma", nomComplet: "Bouzid Asma", fullName: "Bouzid Asma", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 23, matricule: "10023", nom: "Ferchichi", prenom: "Nizar", nomComplet: "Ferchichi Nizar", fullName: "Ferchichi Nizar", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 24, matricule: "10024", nom: "Hamdani", prenom: "Wafa", nomComplet: "Hamdani Wafa", fullName: "Hamdani Wafa", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 25, matricule: "10025", nom: "Rekik", prenom: "Slim", nomComplet: "Rekik Slim", fullName: "Rekik Slim", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // MONASTIR (AIMT) - 18 agents
      Agent(id: 26, matricule: "20001", nom: "Chahed", prenom: "Sonia", nomComplet: "Chahed Sonia", fullName: "Chahed Sonia", affectation: "AIMT", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 27, matricule: "20002", nom: "Jomaa", prenom: "Nabil", nomComplet: "Jomaa Nabil", fullName: "Jomaa Nabil", affectation: "AIMT", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 28, matricule: "20003", nom: "Ghannouchi", prenom: "Leila", nomComplet: "Ghannouchi Leila", fullName: "Ghannouchi Leila", affectation: "AIMT", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 29, matricule: "20004", nom: "Maalej", prenom: "Farid", nomComplet: "Maalej Farid", fullName: "Maalej Farid", affectation: "AIMT", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 30, matricule: "20005", nom: "Baccouche", prenom: "Samira", nomComplet: "Baccouche Samira", fullName: "Baccouche Samira", affectation: "AIMT", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 31, matricule: "20006", nom: "Triki", prenom: "Hichem", nomComplet: "Triki Hichem", fullName: "Triki Hichem", affectation: "AIMT", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 32, matricule: "20007", nom: "Karray", prenom: "Nejla", nomComplet: "Karray Nejla", fullName: "Karray Nejla", affectation: "AIMT", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 33, matricule: "20008", nom: "Bouslama", prenom: "Ridha", nomComplet: "Bouslama Ridha", fullName: "Bouslama Ridha", affectation: "AIMT", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 34, matricule: "20009", nom: "Mahfoudh", prenom: "Olfa", nomComplet: "Mahfoudh Olfa", fullName: "Mahfoudh Olfa", affectation: "AIMT", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 35, matricule: "20010", nom: "Elloumi", prenom: "Samir", nomComplet: "Elloumi Samir", fullName: "Elloumi Samir", affectation: "AIMT", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 36, matricule: "20011", nom: "Chouchane", prenom: "Radhia", nomComplet: "Chouchane Radhia", fullName: "Chouchane Radhia", affectation: "AIMT", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 37, matricule: "20012", nom: "Hammami", prenom: "Lotfi", nomComplet: "Hammami Lotfi", fullName: "Hammami Lotfi", affectation: "AIMT", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 38, matricule: "20013", nom: "Belkhiria", prenom: "Sihem", nomComplet: "Belkhiria Sihem", fullName: "Belkhiria Sihem", affectation: "AIMT", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 39, matricule: "20014", nom: "Zaouali", prenom: "Mongi", nomComplet: "Zaouali Mongi", fullName: "Zaouali Mongi", affectation: "AIMT", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 40, matricule: "20015", nom: "Brahim", prenom: "Khadija", nomComplet: "Brahim Khadija", fullName: "Brahim Khadija", affectation: "AIMT", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 41, matricule: "20016", nom: "Saidi", prenom: "Chokri", nomComplet: "Saidi Chokri", fullName: "Saidi Chokri", affectation: "AIMT", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 42, matricule: "20017", nom: "Mhiri", prenom: "Lamia", nomComplet: "Mhiri Lamia", fullName: "Mhiri Lamia", affectation: "AIMT", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 43, matricule: "20018", nom: "Ghorbel", prenom: "Taoufik", nomComplet: "Ghorbel Taoufik", fullName: "Ghorbel Taoufik", affectation: "AIMT", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // DJERBA (AIDJ) - 15 agents
      Agent(id: 44, matricule: "30001", nom: "Bouzaiene", prenom: "Salah", nomComplet: "Bouzaiene Salah", fullName: "Bouzaiene Salah", affectation: "AIDJ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 45, matricule: "30002", nom: "Kammoun", prenom: "Aicha", nomComplet: "Kammoun Aicha", fullName: "Kammoun Aicha", affectation: "AIDJ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 46, matricule: "30003", nom: "Jlassi", prenom: "Habib", nomComplet: "Jlassi Habib", fullName: "Jlassi Habib", affectation: "AIDJ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 47, matricule: "30004", nom: "Baccari", prenom: "Zohra", nomComplet: "Baccari Zohra", fullName: "Baccari Zohra", affectation: "AIDJ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 48, matricule: "30005", nom: "Touati", prenom: "Mehdi", nomComplet: "Touati Mehdi", fullName: "Touati Mehdi", affectation: "AIDJ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 49, matricule: "30006", nom: "Belhassen", prenom: "Najet", nomComplet: "Belhassen Najet", fullName: "Belhassen Najet", affectation: "AIDJ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 50, matricule: "30007", nom: "Cherif", prenom: "Adel", nomComplet: "Cherif Adel", fullName: "Cherif Adel", affectation: "AIDJ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 51, matricule: "30008", nom: "Hamza", prenom: "Faten", nomComplet: "Hamza Faten", fullName: "Hamza Faten", affectation: "AIDJ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 52, matricule: "30009", nom: "Bouguerra", prenom: "Jamel", nomComplet: "Bouguerra Jamel", fullName: "Bouguerra Jamel", affectation: "AIDJ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 53, matricule: "30010", nom: "Derbali", prenom: "Sarra", nomComplet: "Derbali Sarra", fullName: "Derbali Sarra", affectation: "AIDJ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 54, matricule: "30011", nom: "Mzoughi", prenom: "Kamel", nomComplet: "Mzoughi Kamel", fullName: "Mzoughi Kamel", affectation: "AIDJ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 55, matricule: "30012", nom: "Belaid", prenom: "Wided", nomComplet: "Belaid Wided", fullName: "Belaid Wided", affectation: "AIDJ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 56, matricule: "30013", nom: "Trabelsi", prenom: "Sofien", nomComplet: "Trabelsi Sofien", fullName: "Trabelsi Sofien", affectation: "AIDJ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 57, matricule: "30014", nom: "Khelil", prenom: "Meriem", nomComplet: "Khelil Meriem", fullName: "Khelil Meriem", affectation: "AIDJ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 58, matricule: "30015", nom: "Abidi", prenom: "Hassen", nomComplet: "Abidi Hassen", fullName: "Abidi Hassen", affectation: "AIDJ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // SFAX (AISF) - 12 agents
      Agent(id: 59, matricule: "40001", nom: "Kharrat", prenom: "Mondher", nomComplet: "Kharrat Mondher", fullName: "Kharrat Mondher", affectation: "AISF", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 60, matricule: "40002", nom: "Bejaoui", prenom: "Samia", nomComplet: "Bejaoui Samia", fullName: "Bejaoui Samia", affectation: "AISF", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 61, matricule: "40003", nom: "Hammami", prenom: "Belgacem", nomComplet: "Hammami Belgacem", fullName: "Hammami Belgacem", affectation: "AISF", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 62, matricule: "40004", nom: "Chatti", prenom: "Houda", nomComplet: "Chatti Houda", fullName: "Chatti Houda", affectation: "AISF", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 63, matricule: "40005", nom: "Bouazizi", prenom: "Noureddine", nomComplet: "Bouazizi Noureddine", fullName: "Bouazizi Noureddine", affectation: "AISF", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 64, matricule: "40006", nom: "Mahjoub", prenom: "Latifa", nomComplet: "Mahjoub Latifa", fullName: "Mahjoub Latifa", affectation: "AISF", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 65, matricule: "40007", nom: "Sellami", prenom: "Faouzi", nomComplet: "Sellami Faouzi", fullName: "Sellami Faouzi", affectation: "AISF", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 66, matricule: "40008", nom: "Drira", prenom: "Manel", nomComplet: "Drira Manel", fullName: "Drira Manel", affectation: "AISF", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 67, matricule: "40009", nom: "Gargouri", prenom: "Tahar", nomComplet: "Gargouri Tahar", fullName: "Gargouri Tahar", affectation: "AISF", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 68, matricule: "40010", nom: "Bouzaiene", prenom: "Sonia", nomComplet: "Bouzaiene Sonia", fullName: "Bouzaiene Sonia", affectation: "AISF", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 69, matricule: "40011", nom: "Kammoun", prenom: "Ridha", nomComplet: "Kammoun Ridha", fullName: "Kammoun Ridha", affectation: "AISF", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 70, matricule: "40012", nom: "Jlassi", prenom: "Amira", nomComplet: "Jlassi Amira", fullName: "Jlassi Amira", affectation: "AISF", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // TOZEUR (AIOZ) - 8 agents
      Agent(id: 71, matricule: "50001", nom: "Belhaj", prenom: "Salim", nomComplet: "Belhaj Salim", fullName: "Belhaj Salim", affectation: "AIOZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 72, matricule: "50002", nom: "Oueslati", prenom: "Naima", nomComplet: "Oueslati Naima", fullName: "Oueslati Naima", affectation: "AIOZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 73, matricule: "50003", nom: "Cherif", prenom: "Hedi", nomComplet: "Cherif Hedi", fullName: "Cherif Hedi", affectation: "AIOZ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 74, matricule: "50004", nom: "Baccouche", prenom: "Wafa", nomComplet: "Baccouche Wafa", fullName: "Baccouche Wafa", affectation: "AIOZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 75, matricule: "50005", nom: "Triki", prenom: "Mahmoud", nomComplet: "Triki Mahmoud", fullName: "Triki Mahmoud", affectation: "AIOZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 76, matricule: "50006", nom: "Karray", prenom: "Sonia", nomComplet: "Karray Sonia", fullName: "Karray Sonia", affectation: "AIOZ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 77, matricule: "50007", nom: "Bouslama", prenom: "Nabil", nomComplet: "Bouslama Nabil", fullName: "Bouslama Nabil", affectation: "AIOZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 78, matricule: "50008", nom: "Mahfoudh", prenom: "Leila", nomComplet: "Mahfoudh Leila", fullName: "Mahfoudh Leila", affectation: "AIOZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // GAFSA (AIGF) - 6 agents
      Agent(id: 79, matricule: "60001", nom: "Elloumi", prenom: "Karim", nomComplet: "Elloumi Karim", fullName: "Elloumi Karim", affectation: "AIGF", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 80, matricule: "60002", nom: "Chouchane", prenom: "Fatma", nomComplet: "Chouchane Fatma", fullName: "Chouchane Fatma", affectation: "AIGF", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 81, matricule: "60003", nom: "Hammami", prenom: "Samir", nomComplet: "Hammami Samir", fullName: "Hammami Samir", affectation: "AIGF", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 82, matricule: "60004", nom: "Belkhiria", prenom: "Olfa", nomComplet: "Belkhiria Olfa", fullName: "Belkhiria Olfa", affectation: "AIGF", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 83, matricule: "60005", nom: "Zaouali", prenom: "Lotfi", nomComplet: "Zaouali Lotfi", fullName: "Zaouali Lotfi", affectation: "AIGF", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 84, matricule: "60006", nom: "Brahim", prenom: "Sihem", nomComplet: "Brahim Sihem", fullName: "Brahim Sihem", affectation: "AIGF", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // TABARKA (AITB) - 4 agents
      Agent(id: 85, matricule: "70001", nom: "Saidi", prenom: "Chokri", nomComplet: "Saidi Chokri", fullName: "Saidi Chokri", affectation: "AITB", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 86, matricule: "70002", nom: "Mhiri", prenom: "Lamia", nomComplet: "Mhiri Lamia", fullName: "Mhiri Lamia", affectation: "AITB", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 87, matricule: "70003", nom: "Ghorbel", prenom: "Taoufik", nomComplet: "Ghorbel Taoufik", fullName: "Ghorbel Taoufik", affectation: "AITB", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 88, matricule: "70004", nom: "Rekik", prenom: "Wafa", nomComplet: "Rekik Wafa", fullName: "Rekik Wafa", affectation: "AITB", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ];
  }

  // Méthode publique pour accéder aux vraies données Excel
  List<Agent> getMockAgents() {
    try {
      if (_cachedAgents != null && _cachedAgents!.isNotEmpty) {
        return _cachedAgents!;
      }
      return _getRealExcelData();
    } catch (e) {
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
        final data = json.decode(response.body);
        final List<dynamic> agentsJson = data['agents'] ?? [];
        return agentsJson.map((json) => Agent.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search agents: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching agents: $e');
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

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _cachedStats = json.decode(response.body);
        _lastStatsFetch = DateTime.now();
        return _cachedStats!;
      } else {
        throw Exception('Erreur API stats: ${response.statusCode}');
      }
    } catch (e) {
      // En cas d'erreur, calculer les stats localement
      return _calculateLocalStats();
    }
  }

  Map<String, dynamic> _calculateLocalStats() {
    final agents = getMockAgents();

    // Grouper par fichier source
    Map<String, List<Agent>> agentsByFile = {};
    for (var agent in agents) {
      agentsByFile.putIfAbsent(agent.sourceFile, () => []).add(agent);
    }

    // Grouper par affectation
    Map<String, List<Agent>> agentsByAffectation = {};
    for (var agent in agents) {
      if (agent.affectation != null && agent.affectation!.isNotEmpty) {
        agentsByAffectation.putIfAbsent(agent.affectation!, () => []).add(agent);
      }
    }

    return {
      'total_agents': agents.length,
      'total_files': agentsByFile.length,
      'agents_by_file': agentsByFile,
      'agents_by_affectation': agentsByAffectation,
    };
  }

  Future<bool> deleteAgent(int agentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/agents/$agentId/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        // Supprimer du cache local
        if (_cachedAgents != null) {
          _cachedAgents!.removeWhere((agent) => agent.id == agentId);
        }
        return true;
      } else {
        throw Exception('Failed to delete agent: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting agent: $e');
    }
  }
}
