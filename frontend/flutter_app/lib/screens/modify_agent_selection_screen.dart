import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_agent_screen.dart';

class ModifyAgentSelectionScreen extends StatefulWidget {
  const ModifyAgentSelectionScreen({super.key});

  @override
  State<ModifyAgentSelectionScreen> createState() => _ModifyAgentSelectionScreenState();
}

class _ModifyAgentSelectionScreenState extends State<ModifyAgentSelectionScreen> {
  List<Map<String, dynamic>> _allAgents = [];
  List<Map<String, dynamic>> _filteredAgents = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAgents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/mobile-api/agents/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _allAgents = List<Map<String, dynamic>>.from(data['results'] ?? data);
          _filteredAgents = _allAgents;
          _isLoading = false;
        });
      } else {
        throw Exception('Erreur lors du chargement des agents');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterAgents(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredAgents = _allAgents;
      } else {
        _filteredAgents = _allAgents.where((agent) {
          final searchLower = query.toLowerCase();
          final nom = agent['nom']?.toString().toLowerCase() ?? '';
          final prenom = agent['prenom']?.toString().toLowerCase() ?? '';
          final matricule = agent['matricule']?.toString().toLowerCase() ?? '';
          final affectation = agent['affectation']?.toString().toLowerCase() ?? '';
          
          return nom.contains(searchLower) ||
                 prenom.contains(searchLower) ||
                 matricule.contains(searchLower) ||
                 affectation.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF0D47A1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            'Modifier un agent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sélectionnez l\'agent à modifier',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    
                    // Barre de recherche
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterAgents,
                        decoration: const InputDecoration(
                          hintText: 'Rechercher par nom, matricule, aéroport...',
                          prefixIcon: Icon(Icons.search, color: Color(0xFF1565C0)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Liste des agents
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Color(0xFF1565C0)),
                              SizedBox(height: 20),
                              Text(
                                'Chargement des agents...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            // Header des résultats
                            if (_filteredAgents.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Text(
                                      '${_filteredAgents.length} agent${_filteredAgents.length > 1 ? 's' : ''} trouvé${_filteredAgents.length > 1 ? 's' : ''}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1565C0),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: _loadAgents,
                                      icon: const Icon(Icons.refresh, color: Color(0xFF1565C0)),
                                      tooltip: 'Actualiser',
                                    ),
                                  ],
                                ),
                              ),
                            
                            // Liste
                            Expanded(
                              child: _filteredAgents.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _searchQuery.isEmpty ? Icons.people_outline : Icons.search_off,
                                            size: 80,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            _searchQuery.isEmpty 
                                                ? 'Aucun agent trouvé'
                                                : 'Aucun résultat pour "$_searchQuery"',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          if (_searchQuery.isNotEmpty)
                                            const SizedBox(height: 10),
                                          if (_searchQuery.isNotEmpty)
                                            Text(
                                              'Essayez avec d\'autres mots-clés',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      itemCount: _filteredAgents.length,
                                      itemBuilder: (context, index) {
                                        final agent = _filteredAgents[index];
                                        return _buildAgentCard(agent);
                                      },
                                    ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgentCard(Map<String, dynamic> agent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditAgentScreen(agent: agent),
            ),
          ).then((result) {
            // Recharger la liste si l'agent a été modifié
            if (result == true) {
              _loadAgents();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF1565C0),
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 15),
              
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${agent['nom'] ?? ''} ${agent['prenom'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Matricule: ${agent['matricule'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (agent['affectation'] != null && agent['affectation'].toString().isNotEmpty)
                      Text(
                        'Aéroport: ${agent['affectation']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (agent['fonction'] != null && agent['fonction'].toString().isNotEmpty)
                      Text(
                        'Fonction: ${agent['fonction']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Indicateur
              const Icon(
                Icons.edit,
                color: Colors.orange,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
