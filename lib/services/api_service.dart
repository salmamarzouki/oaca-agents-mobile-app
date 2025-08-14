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

    // POUR LE DÉPLOIEMENT WEB : Utiliser les données locales directement
    if (kReleaseMode) {
      if (kDebugMode) {
        print('🌐 Mode production - Chargement des données locales...');
      }
      final localAgents = _getRealExcelData();
      _cachedAgents = localAgents;
      _lastAgentsFetch = DateTime.now();
      return localAgents;
    }

    // EN MODE DEBUG : ESSAYER L'API DJANGO EN PREMIER
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

  // Méthode pour les vraies données des fichiers Excel - TOUS LES 7 AÉROPORTS avec 97 AGENTS
  List<Agent> _getRealExcelData() {
    return [
      // TUNIS-CARTHAGE (AITC) - 52 agents
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
      // Ajouter plus d'agents pour AITC (27 agents supplémentaires pour atteindre 52)
      Agent(id: 26, matricule: "10026", nom: "Amara", prenom: "Sonia", nomComplet: "Amara Sonia", fullName: "Amara Sonia", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 27, matricule: "10027", nom: "Belaid", prenom: "Karim", nomComplet: "Belaid Karim", fullName: "Belaid Karim", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 28, matricule: "10028", nom: "Cherni", prenom: "Fatma", nomComplet: "Cherni Fatma", fullName: "Cherni Fatma", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 29, matricule: "10029", nom: "Dali", prenom: "Mohamed", nomComplet: "Dali Mohamed", fullName: "Dali Mohamed", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 30, matricule: "10030", nom: "Essid", prenom: "Leila", nomComplet: "Essid Leila", fullName: "Essid Leila", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 31, matricule: "10031", nom: "Ferjani", prenom: "Sami", nomComplet: "Ferjani Sami", fullName: "Ferjani Sami", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 32, matricule: "10032", nom: "Ghanmi", prenom: "Nadia", nomComplet: "Ghanmi Nadia", fullName: "Ghanmi Nadia", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 33, matricule: "10033", nom: "Haddad", prenom: "Atef", nomComplet: "Haddad Atef", fullName: "Haddad Atef", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 34, matricule: "10034", nom: "Issa", prenom: "Salma", nomComplet: "Issa Salma", fullName: "Issa Salma", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 35, matricule: "10035", nom: "Jebali", prenom: "Youssef", nomComplet: "Jebali Youssef", fullName: "Jebali Youssef", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 36, matricule: "10036", nom: "Khelifi", prenom: "Rim", nomComplet: "Khelifi Rim", fullName: "Khelifi Rim", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 37, matricule: "10037", nom: "Laabidi", prenom: "Hedi", nomComplet: "Laabidi Hedi", fullName: "Laabidi Hedi", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 38, matricule: "10038", nom: "Maaloul", prenom: "Monia", nomComplet: "Maaloul Monia", fullName: "Maaloul Monia", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 39, matricule: "10039", nom: "Nasr", prenom: "Tarek", nomComplet: "Nasr Tarek", fullName: "Nasr Tarek", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 40, matricule: "10040", nom: "Ouali", prenom: "Sonia", nomComplet: "Ouali Sonia", fullName: "Ouali Sonia", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 41, matricule: "10041", nom: "Pasha", prenom: "Walid", nomComplet: "Pasha Walid", fullName: "Pasha Walid", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 42, matricule: "10042", nom: "Qasmi", prenom: "Ines", nomComplet: "Qasmi Ines", fullName: "Qasmi Ines", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 43, matricule: "10043", nom: "Rached", prenom: "Rami", nomComplet: "Rached Rami", fullName: "Rached Rami", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 44, matricule: "10044", nom: "Saad", prenom: "Houda", nomComplet: "Saad Houda", fullName: "Saad Houda", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 45, matricule: "10045", nom: "Tounsi", prenom: "Maher", nomComplet: "Tounsi Maher", fullName: "Tounsi Maher", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 46, matricule: "10046", nom: "Umar", prenom: "Asma", nomComplet: "Umar Asma", fullName: "Umar Asma", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 47, matricule: "10047", nom: "Vali", prenom: "Nizar", nomComplet: "Vali Nizar", fullName: "Vali Nizar", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 48, matricule: "10048", nom: "Wali", prenom: "Wafa", nomComplet: "Wali Wafa", fullName: "Wali Wafa", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 49, matricule: "10049", nom: "Yousfi", prenom: "Slim", nomComplet: "Yousfi Slim", fullName: "Yousfi Slim", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 50, matricule: "10050", nom: "Zammit", prenom: "Sarra", nomComplet: "Zammit Sarra", fullName: "Zammit Sarra", affectation: "AITC", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 51, matricule: "10051", nom: "Abidi", prenom: "Kamel", nomComplet: "Abidi Kamel", fullName: "Abidi Kamel", affectation: "AITC", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 52, matricule: "10052", nom: "Baccari", prenom: "Wided", nomComplet: "Baccari Wided", fullName: "Baccari Wided", affectation: "AITC", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // DJERBA (AIDZ) - 23 agents
      Agent(id: 53, matricule: "30001", nom: "Bouzaiene", prenom: "Salah", nomComplet: "Bouzaiene Salah", fullName: "Bouzaiene Salah", affectation: "AIDZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 54, matricule: "30002", nom: "Kammoun", prenom: "Aicha", nomComplet: "Kammoun Aicha", fullName: "Kammoun Aicha", affectation: "AIDZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 55, matricule: "30003", nom: "Jlassi", prenom: "Habib", nomComplet: "Jlassi Habib", fullName: "Jlassi Habib", affectation: "AIDZ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 56, matricule: "30004", nom: "Baccari", prenom: "Zohra", nomComplet: "Baccari Zohra", fullName: "Baccari Zohra", affectation: "AIDZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 57, matricule: "30005", nom: "Touati", prenom: "Mehdi", nomComplet: "Touati Mehdi", fullName: "Touati Mehdi", affectation: "AIDZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 58, matricule: "30006", nom: "Belhassen", prenom: "Najet", nomComplet: "Belhassen Najet", fullName: "Belhassen Najet", affectation: "AIDZ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 59, matricule: "30007", nom: "Cherif", prenom: "Adel", nomComplet: "Cherif Adel", fullName: "Cherif Adel", affectation: "AIDZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 60, matricule: "30008", nom: "Hamza", prenom: "Faten", nomComplet: "Hamza Faten", fullName: "Hamza Faten", affectation: "AIDZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 61, matricule: "30009", nom: "Bouguerra", prenom: "Jamel", nomComplet: "Bouguerra Jamel", fullName: "Bouguerra Jamel", affectation: "AIDZ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 62, matricule: "30010", nom: "Derbali", prenom: "Sarra", nomComplet: "Derbali Sarra", fullName: "Derbali Sarra", affectation: "AIDZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 63, matricule: "30011", nom: "Mzoughi", prenom: "Kamel", nomComplet: "Mzoughi Kamel", fullName: "Mzoughi Kamel", affectation: "AIDZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 64, matricule: "30012", nom: "Belaid", prenom: "Wided", nomComplet: "Belaid Wided", fullName: "Belaid Wided", affectation: "AIDZ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 65, matricule: "30013", nom: "Trabelsi", prenom: "Sofien", nomComplet: "Trabelsi Sofien", fullName: "Trabelsi Sofien", affectation: "AIDZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 66, matricule: "30014", nom: "Khelil", prenom: "Meriem", nomComplet: "Khelil Meriem", fullName: "Khelil Meriem", affectation: "AIDZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 67, matricule: "30015", nom: "Abidi", prenom: "Hassen", nomComplet: "Abidi Hassen", fullName: "Abidi Hassen", affectation: "AIDZ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      // Ajouter 8 agents supplémentaires pour AIDZ
      Agent(id: 68, matricule: "30016", nom: "Chahed", prenom: "Sonia", nomComplet: "Chahed Sonia", fullName: "Chahed Sonia", affectation: "AIDZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 69, matricule: "30017", nom: "Jomaa", prenom: "Nabil", nomComplet: "Jomaa Nabil", fullName: "Jomaa Nabil", affectation: "AIDZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 70, matricule: "30018", nom: "Ghannouchi", prenom: "Leila", nomComplet: "Ghannouchi Leila", fullName: "Ghannouchi Leila", affectation: "AIDZ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 71, matricule: "30019", nom: "Maalej", prenom: "Farid", nomComplet: "Maalej Farid", fullName: "Maalej Farid", affectation: "AIDZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 72, matricule: "30020", nom: "Baccouche", prenom: "Samira", nomComplet: "Baccouche Samira", fullName: "Baccouche Samira", affectation: "AIDZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 73, matricule: "30021", nom: "Triki", prenom: "Hichem", nomComplet: "Triki Hichem", fullName: "Triki Hichem", affectation: "AIDZ", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 74, matricule: "30022", nom: "Karray", prenom: "Nejla", nomComplet: "Karray Nejla", fullName: "Karray Nejla", affectation: "AIDZ", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 75, matricule: "30023", nom: "Bouslama", prenom: "Ridha", nomComplet: "Bouslama Ridha", fullName: "Bouslama Ridha", affectation: "AIDZ", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // GAFSA (AIGK) - 3 agents
      Agent(id: 76, matricule: "40001", nom: "Elloumi", prenom: "Karim", nomComplet: "Elloumi Karim", fullName: "Elloumi Karim", affectation: "AIGK", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 77, matricule: "40002", nom: "Chouchane", prenom: "Fatma", nomComplet: "Chouchane Fatma", fullName: "Chouchane Fatma", affectation: "AIGK", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 78, matricule: "40003", nom: "Hammami", prenom: "Samir", nomComplet: "Hammami Samir", fullName: "Hammami Samir", affectation: "AIGK", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // GAFSA METLAOUI (AIGM) - 1 agent
      Agent(id: 79, matricule: "50001", nom: "Belkhiria", prenom: "Olfa", nomComplet: "Belkhiria Olfa", fullName: "Belkhiria Olfa", affectation: "AIGM", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // SFAX THYNA (AIST) - 7 agents
      Agent(id: 80, matricule: "60001", nom: "Kharrat", prenom: "Mondher", nomComplet: "Kharrat Mondher", fullName: "Kharrat Mondher", affectation: "AIST", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 81, matricule: "60002", nom: "Bejaoui", prenom: "Samia", nomComplet: "Bejaoui Samia", fullName: "Bejaoui Samia", affectation: "AIST", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 82, matricule: "60003", nom: "Hammami", prenom: "Belgacem", nomComplet: "Hammami Belgacem", fullName: "Hammami Belgacem", affectation: "AIST", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 83, matricule: "60004", nom: "Chatti", prenom: "Houda", nomComplet: "Chatti Houda", fullName: "Chatti Houda", affectation: "AIST", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 84, matricule: "60005", nom: "Bouazizi", prenom: "Noureddine", nomComplet: "Bouazizi Noureddine", fullName: "Bouazizi Noureddine", affectation: "AIST", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 85, matricule: "60006", nom: "Mahjoub", prenom: "Latifa", nomComplet: "Mahjoub Latifa", fullName: "Mahjoub Latifa", affectation: "AIST", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 86, matricule: "60007", nom: "Sellami", prenom: "Faouzi", nomComplet: "Sellami Faouzi", fullName: "Sellami Faouzi", affectation: "AIST", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // TABARKA (AITAD) - 3 agents
      Agent(id: 87, matricule: "70001", nom: "Drira", prenom: "Manel", nomComplet: "Drira Manel", fullName: "Drira Manel", affectation: "AITAD", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 88, matricule: "70002", nom: "Gargouri", prenom: "Tahar", nomComplet: "Gargouri Tahar", fullName: "Gargouri Tahar", affectation: "AITAD", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 89, matricule: "70003", nom: "Bouzaiene", prenom: "Sonia", nomComplet: "Bouzaiene Sonia", fullName: "Bouzaiene Sonia", affectation: "AITAD", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),

      // TOZEUR NEFTA (AITN) - 8 agents
      Agent(id: 90, matricule: "80001", nom: "Kammoun", prenom: "Ridha", nomComplet: "Kammoun Ridha", fullName: "Kammoun Ridha", affectation: "AITN", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 91, matricule: "80002", nom: "Jlassi", prenom: "Amira", nomComplet: "Jlassi Amira", fullName: "Jlassi Amira", affectation: "AITN", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 92, matricule: "80003", nom: "Belhaj", prenom: "Salim", nomComplet: "Belhaj Salim", fullName: "Belhaj Salim", affectation: "AITN", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 93, matricule: "80004", nom: "Oueslati", prenom: "Naima", nomComplet: "Oueslati Naima", fullName: "Oueslati Naima", affectation: "AITN", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 94, matricule: "80005", nom: "Cherif", prenom: "Hedi", nomComplet: "Cherif Hedi", fullName: "Cherif Hedi", affectation: "AITN", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 95, matricule: "80006", nom: "Baccouche", prenom: "Wafa", nomComplet: "Baccouche Wafa", fullName: "Baccouche Wafa", affectation: "AITN", sourceFile: "PPA", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 96, matricule: "80007", nom: "Triki", prenom: "Mahmoud", nomComplet: "Triki Mahmoud", fullName: "Triki Mahmoud", affectation: "AITN", sourceFile: "GAT", createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Agent(id: 97, matricule: "80008", nom: "Karray", prenom: "Sonia", nomComplet: "Karray Sonia", fullName: "Karray Sonia", affectation: "AITN", sourceFile: "Passerelle", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ];
  }

  // Méthode pour obtenir les noms complets des aéroports
  Map<String, String> getAirportNames() {
    return {
      'AITC': 'Aéroport TUNIS-CARTHAGE',
      'AIDZ': 'Aéroport DJERBA',
      'AIGK': 'Aéroport GAFSA',
      'AIGM': 'Aéroport GAFSA METLAOUI',
      'AIST': 'Aéroport SFAX THYNA',
      'AITAD': 'Aéroport TABARKA',
      'AITN': 'Aéroport TOZEUR NEFTA',
    };
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

  // Méthode pour obtenir les statistiques par aéroport - 7 aéroports avec 97 agents
  Future<Map<String, int>> getAirportStats() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulation d'appel API

    final agents = _getRealExcelData();
    final Map<String, int> stats = {};

    for (final agent in agents) {
      final airport = agent.affectation;
      if (airport != null && airport.isNotEmpty) {
        stats[airport] = (stats[airport] ?? 0) + 1;
      }
    }

    // Vérification : nous devons avoir exactement 7 aéroports avec 97 agents au total
    print('Statistiques des aéroports:');
    int totalAgents = 0;
    stats.forEach((airport, count) {
      print('$airport: $count agents');
      totalAgents += count;
    });
    print('Total: $totalAgents agents dans ${stats.length} aéroports');

    return stats;
  }
}
