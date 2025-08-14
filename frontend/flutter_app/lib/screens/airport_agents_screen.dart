import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'agent_details_screen.dart';

class AirportAgentsScreen extends StatefulWidget {
  final String airportName;
  final List<Map<String, dynamic>> agents;

  const AirportAgentsScreen({
    super.key,
    required this.airportName,
    required this.agents,
  });

  @override
  State<AirportAgentsScreen> createState() => _AirportAgentsScreenState();
}

class _AirportAgentsScreenState extends State<AirportAgentsScreen> {
  List<Map<String, dynamic>> filteredAgents = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredAgents = widget.agents;
  }

  void _filterAgents(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredAgents = widget.agents;
      } else {
        filteredAgents = widget.agents.where((agent) {
          final nom = agent['nom']?.toString().toLowerCase() ?? '';
          final prenom = agent['prenom']?.toString().toLowerCase() ?? '';
          final matricule = agent['matricule']?.toString().toLowerCase() ?? '';
          final fonction = agent['fonction']?.toString().toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          
          return nom.contains(searchLower) ||
                 prenom.contains(searchLower) ||
                 matricule.contains(searchLower) ||
                 fonction.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.airportName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF42A5F5),
            ],
          ),
        ),
        child: Column(
          children: [
            // En-tête avec statistiques
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                        'Total Agents',
                        widget.agents.length.toString(),
                        Icons.people,
                        Colors.white,
                      ),
                      _buildStatCard(
                        'Résultats',
                        filteredAgents.length.toString(),
                        Icons.search,
                        Colors.white70,
                      ),
                    ],
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
                      onChanged: _filterAgents,
                      decoration: const InputDecoration(
                        hintText: 'Rechercher un agent...',
                        prefixIcon: Icon(Icons.search, color: Color(0xFF1565C0)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Liste des agents
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: filteredAgents.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredAgents.length,
                        itemBuilder: (context, index) {
                          final agent = filteredAgents[index];
                          return _buildAgentCard(agent);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentCard(Map<String, dynamic> agent) {
    final String initials = _getInitials(agent);
    final Color avatarColor = _getAvatarColor(agent['nom'] ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(
          backgroundColor: avatarColor,
          radius: 25,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          '${agent['nom'] ?? ''} ${agent['prenom'] ?? ''}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Matricule: ${agent['matricule'] ?? 'N/A'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            if (agent['fonction'] != null)
              Text(
                'Fonction: ${agent['fonction']}',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (agent['formation'] != null && agent['formation'].toString().isNotEmpty)
              _buildFormationSummary(agent['formation']),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF1565C0),
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgentDetailsScreen(agent: agent),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            searchQuery.isEmpty
                ? 'Aucun agent trouvé'
                : 'Aucun résultat pour "$searchQuery"',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Essayez avec d\'autres mots-clés',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(Map<String, dynamic> agent) {
    final nom = agent['nom']?.toString() ?? '';
    final prenom = agent['prenom']?.toString() ?? '';
    
    String initials = '';
    if (nom.isNotEmpty) initials += nom[0].toUpperCase();
    if (prenom.isNotEmpty) initials += prenom[0].toUpperCase();
    
    return initials.isEmpty ? '?' : initials;
  }

  Widget _buildFormationSummary(dynamic formation) {
    if (formation == null || formation.toString().isEmpty || formation.toString() == 'N/A') {
      return const SizedBox.shrink();
    }

    String formationsText = formation.toString();
    List<String> formations = formationsText.split('|').map((f) => f.trim()).where((f) => f.isNotEmpty && f != 'N/A').toList();

    if (formations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Icon(
            Icons.school,
            size: 16,
            color: Colors.green[600],
          ),
          const SizedBox(width: 5),
          Expanded(
            child: formations.length == 1
                ? Text(
                    'Formation: ${formations[0]}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                : Text(
                    'Formations: ${formations.length} (${formations[0]}...)',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.orange[700]!,
      Colors.purple[700]!,
      Colors.red[700]!,
      Colors.teal[700]!,
      Colors.indigo[700]!,
      Colors.pink[700]!,
    ];

    final index = name.hashCode % colors.length;
    return colors[index.abs()];
  }
}
