import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/agent.dart';

class SeparatedApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/mobile-api';
  
  // For Android emulator, use: http://10.0.2.2:8000/mobile-api
  // For iOS simulator, use: http://127.0.0.1:8000/mobile-api
  // For physical device, use your computer's IP address

  Future<Map<String, dynamic>> getAllAgents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/agents/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> agentsJson = data['agents'];
        return {
          'agents': agentsJson.map((json) => Agent.fromJson(json)).toList(),
          'count': data['count'],
        };
      } else {
        throw Exception('Failed to load all agents: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Error (all agents): $e');
      return {
        'agents': <Agent>[],
        'count': 0,
      };
    }
  }

  Future<Map<String, dynamic>> getPPAGATPTAgents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/agents/ppa-gat-pt/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> agentsJson = data['agents'];
        return {
          'agents': agentsJson.map((json) => Agent.fromJson(json)).toList(),
          'count': data['count'],
          'file_type': data['file_type'],
          'attributes': data['attributes'],
        };
      } else {
        throw Exception('Failed to load PPA&GAT&PT agents: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Error (PPA&GAT&PT): $e');
      return {
        'agents': _getMockPPAAgents(),
        'count': _getMockPPAAgents().length,
        'file_type': 'PPA&GAT&PT',
        'attributes': ['matricule', 'nom', 'prenom', 'nom_complet', 'affectation'],
      };
    }
  }

  Future<Map<String, dynamic>> getNaimaAgents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/agents/naima/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> agentsJson = data['agents'];
        return {
          'agents': agentsJson.map((json) => Agent.fromJson(json)).toList(),
          'count': data['count'],
          'file_type': data['file_type'],
          'attributes': data['attributes'],
        };
      } else {
        throw Exception('Failed to load Naima agents: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Error (Naima): $e');
      return {
        'agents': _getMockNaimaAgents(),
        'count': _getMockNaimaAgents().length,
        'file_type': 'Naima 2022',
        'attributes': ['matricule', 'nom', 'prenom', 'nom_complet', 'affectation', 'periode', 'status'],
      };
    }
  }

  List<Agent> _getMockPPAAgents() {
    return [
      Agent(
        id: 1,
        matricule: "12000",
        nom: "Asker",
        prenom: "Hamed Ben",
        nomComplet: "Hamed Ben Asker",
        fullName: "Hamed Ben Asker",
        affectation: null,
        periode: null,
        sourceFile: "Liste des agents aux unités PPA&GAT&PT .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Agent(
        id: 2,
        matricule: "88100",
        nom: "Ismail",
        prenom: "Mohamed adel",
        nomComplet: "Mohamed adel Ismail",
        fullName: "Mohamed adel Ismail",
        affectation: "AITC",
        periode: null,
        sourceFile: "Liste des agents aux unités PPA&GAT&PT .xlsx",
        status: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<Agent> _getMockNaimaAgents() {
    return [
      Agent(
        id: 1,
        matricule: "10010",
        nom: "Belgacem",
        prenom: "Khriji",
        nomComplet: "Khriji Belgacem",
        fullName: "Khriji Belgacem",
        affectation: null,
        periode: "Du 25/02/2019 au 01/03/2019",
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: "ok",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Agent(
        id: 2,
        matricule: "10041",
        nom: "Eddine",
        prenom: "Bouzrad Imed",
        nomComplet: "Bouzrad Imed Eddine",
        fullName: "Bouzrad Imed Eddine",
        affectation: "AIGK",
        periode: "Du 25/02/2019 au 01/03/2019",
        sourceFile: "liste des agents 2022 naima du 6 décembre 2022 .xlsx",
        status: "ok",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
