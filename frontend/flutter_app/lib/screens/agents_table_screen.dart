import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'agent_details_screen.dart';
import 'edit_agent_screen.dart';
import 'add_agent_simple.dart';

class AgentsTableScreen extends StatefulWidget {
  const AgentsTableScreen({super.key});

  @override
  State<AgentsTableScreen> createState() => _AgentsTableScreenState();
}

class _AgentsTableScreenState extends State<AgentsTableScreen> {
  List<Map<String, dynamic>> agents = [];
  List<Map<String, dynamic>> filteredAgents = [];
  bool isLoading = true;
  String? error;
  String searchQuery = '';
  int sortColumnIndex = 0;
  bool sortAscending = true;

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
        setState(() {
          agents = agentsData.cast<Map<String, dynamic>>();
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

  void _filterAgents(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredAgents = agents;
      } else {
        filteredAgents = agents.where((agent) {
          final nom = agent['nom']?.toString().toLowerCase() ?? '';
          final prenom = agent['prenom']?.toString().toLowerCase() ?? '';
          final matricule = agent['matricule']?.toString().toLowerCase() ?? '';
          final fonction = agent['fonction']?.toString().toLowerCase() ?? '';
          final affectation = agent['affectation']?.toString().toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          
          return nom.contains(searchLower) ||
                 prenom.contains(searchLower) ||
                 matricule.contains(searchLower) ||
                 fonction.contains(searchLower) ||
                 affectation.contains(searchLower);
        }).toList();
      }
    });
  }

  void _sortAgents(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
      
      filteredAgents.sort((a, b) {
        dynamic aValue, bValue;
        
        switch (columnIndex) {
          case 0: // Matricule
            aValue = a['matricule'] ?? '';
            bValue = b['matricule'] ?? '';
            break;
          case 1: // Nom
            aValue = a['nom'] ?? '';
            bValue = b['nom'] ?? '';
            break;
          case 2: // Prénom
            aValue = a['prenom'] ?? '';
            bValue = b['prenom'] ?? '';
            break;
          case 3: // Fonction
            aValue = a['fonction'] ?? '';
            bValue = b['fonction'] ?? '';
            break;
          case 4: // Affectation
            aValue = a['affectation'] ?? '';
            bValue = b['affectation'] ?? '';
            break;
          case 5: // Âge
            aValue = a['age'] ?? 0;
            bValue = b['age'] ?? 0;
            break;
          default:
            aValue = '';
            bValue = '';
        }
        
        if (ascending) {
          return aValue.toString().compareTo(bValue.toString());
        } else {
          return bValue.toString().compareTo(aValue.toString());
        }
      });
    });
  }

  Future<void> _deleteAgent(int agentId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/mobile-api/agents/delete/$agentId/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agent supprimé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        _loadAgents(); // Recharger la liste
      } else {
        throw Exception('Erreur lors de la suppression');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestion des Agents',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAgents,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAgentSimple(),
                ),
              );
              if (result == true) {
                _loadAgents(); // Recharger la liste
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1565C0),
            child: TextField(
              onChanged: _filterAgents,
              decoration: InputDecoration(
                hintText: 'Rechercher un agent...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Statistiques
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatChip('Total', agents.length.toString(), Colors.blue),
                _buildStatChip('Affichés', filteredAgents.length.toString(), Colors.green),
                _buildStatChip('Recherche', searchQuery.isEmpty ? 'Aucune' : searchQuery, Colors.orange),
              ],
            ),
          ),
          // Tableau
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, size: 64, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(error!, style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadAgents,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : _buildDataTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color,
        child: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
          columns: [
            DataColumn(
              label: const Text('Matricule', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, ascending) => _sortAgents(columnIndex, ascending),
            ),
            DataColumn(
              label: const Text('Nom', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, ascending) => _sortAgents(columnIndex, ascending),
            ),
            DataColumn(
              label: const Text('Prénom', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, ascending) => _sortAgents(columnIndex, ascending),
            ),
            DataColumn(
              label: const Text('Fonction', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, ascending) => _sortAgents(columnIndex, ascending),
            ),
            DataColumn(
              label: const Text('Affectation', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, ascending) => _sortAgents(columnIndex, ascending),
            ),
            DataColumn(
              label: const Text('Âge', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, ascending) => _sortAgents(columnIndex, ascending),
              numeric: true,
            ),
            const DataColumn(
              label: Text('Formation(s)', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const DataColumn(
              label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          rows: filteredAgents.map((agent) => _buildDataRow(agent)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> agent) {
    return DataRow(
      cells: [
        DataCell(Text(agent['matricule']?.toString() ?? '')),
        DataCell(Text(agent['nom']?.toString() ?? '')),
        DataCell(Text(agent['prenom']?.toString() ?? '')),
        DataCell(Text(agent['fonction']?.toString() ?? '')),
        DataCell(Text(agent['affectation']?.toString() ?? '')),
        DataCell(Text(agent['age']?.toString() ?? '')),
        DataCell(_buildFormationCell(agent['formation'])),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgentDetailsScreen(agent: agent),
                    ),
                  );
                },
                tooltip: 'Voir détails',
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAgentScreen(agent: agent),
                    ),
                  ).then((result) {
                    // Recharger les données si l'agent a été modifié
                    if (result == true) {
                      _loadAgents();
                    }
                  });
                },
                tooltip: 'Modifier',
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(agent),
                tooltip: 'Supprimer',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormationCell(dynamic formation) {
    if (formation == null || formation.toString().isEmpty || formation.toString() == 'N/A') {
      return const Text(
        'Aucune',
        style: TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    String formationsText = formation.toString();

    List<String> formations = formationsText
        .split('|')
        .map((f) => f.trim())
        .where((f) => f.isNotEmpty && f != 'N/A')
        .toList();

    if (formations.isEmpty) {
      return const Text(
        'Aucune',
        style: TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    if (formations.length == 1) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 250),
        child: Text(
          formations[0],
          style: const TextStyle(fontSize: 13),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      );
    }

    // Plusieurs formations
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[100]!, Colors.blue[200]!],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school,
                  size: 14,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 4),
                Text(
                  '${formations.length} formations',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formations[0],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (formations.length > 1)
            Text(
              '+ ${formations.length - 1} autre(s)',
              style: TextStyle(
                fontSize: 11,
                color: Colors.orange[600],
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> agent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer l\'agent ${agent['nom']} ${agent['prenom']} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAgent(agent['id']);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
