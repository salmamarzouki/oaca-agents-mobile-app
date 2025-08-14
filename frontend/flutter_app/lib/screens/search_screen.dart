import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/agent.dart';
import 'edit_agent_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> allAgents = [];
  List<dynamic> filteredAgents = [];
  bool isLoading = true;
  bool isSearching = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/mobile-api/agents/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> agentsData = responseData['agents'] ?? [];
        final List<Map<String, dynamic>> agents = agentsData.cast<Map<String, dynamic>>();
        setState(() {
          allAgents = agents;
          filteredAgents = agents;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Erreur de chargement: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Erreur de connexion: $e';
        isLoading = false;
      });
    }
  }

  void _performSearch(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredAgents = allAgents;
      } else {
        filteredAgents = allAgents.where((agent) {
          final nom = (agent['nom'] ?? '').toString().toLowerCase();
          final prenom = (agent['prenom'] ?? '').toString().toLowerCase();
          final fonction = (agent['fonction'] ?? '').toString().toLowerCase();
          final affectation = (agent['affectation'] ?? '').toString().toLowerCase();
          final grade = (agent['grade'] ?? '').toString().toLowerCase();
          
          final searchLower = query.toLowerCase();
          
          return nom.contains(searchLower) ||
                 prenom.contains(searchLower) ||
                 fonction.contains(searchLower) ||
                 affectation.contains(searchLower) ||
                 grade.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'ديوان الطيران المدني والمطارات',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              'OFFICE DE L\'AVIATION CIVILE ET DES AÉROPORTS',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // En-tête avec barre de recherche
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.search,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rechercher',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Recherche par nom, prénom, fonction ou aéroport',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                // Barre de recherche
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _performSearch,
                    decoration: const InputDecoration(
                      hintText: 'Tapez votre recherche...',
                      prefixIcon: Icon(Icons.search, color: Color(0xFF4CAF50)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Statistiques de recherche
                if (isSearching)
                  Text(
                    '${filteredAgents.length} résultat(s) trouvé(s)',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          
          // Contenu principal
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF4CAF50)),
            SizedBox(height: 16),
            Text('Chargement des agents...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAgents,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (filteredAgents.isEmpty && isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Aucun résultat trouvé'),
            Text(
              'Essayez avec d\'autres mots-clés',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (filteredAgents.isEmpty && !isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Commencez à taper pour rechercher'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAgents.length,
      itemBuilder: (context, index) {
        final agent = filteredAgents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF4CAF50),
              child: Text(
                (agent['nom'] ?? 'N')[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text('${agent['nom'] ?? ''} ${agent['prenom'] ?? ''}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (agent['fonction'] != null) Text('Fonction: ${agent['fonction']}'),
                if (agent['affectation'] != null) Text('Aéroport: ${agent['affectation']}'),
                if (agent['grade'] != null) Text('Grade: ${agent['grade']}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAgentScreen(agent: agent),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
