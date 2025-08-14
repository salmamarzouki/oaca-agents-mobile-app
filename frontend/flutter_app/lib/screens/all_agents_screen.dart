import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'agent_details_screen.dart';
import 'airport_agents_screen.dart';

class AllAgentsScreen extends StatefulWidget {
  const AllAgentsScreen({super.key});

  @override
  State<AllAgentsScreen> createState() => _AllAgentsScreenState();
}

class _AllAgentsScreenState extends State<AllAgentsScreen> {
  List<dynamic> agents = [];
  Map<String, List<dynamic>> agentsByAirport = {};
  bool isLoading = true;
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
        setState(() {
          agents = agentsData.cast<Map<String, dynamic>>();
          _groupAgentsByAirport();
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

  void _groupAgentsByAirport() {
    agentsByAirport.clear();
    for (var agent in agents) {
      String airport = agent['affectation'] ?? 'Non spécifié';
      if (!agentsByAirport.containsKey(airport)) {
        agentsByAirport[airport] = [];
      }
      agentsByAirport[airport]!.add(agent);
    }
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
        backgroundColor: const Color(0xFF1565C0),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // En-tête avec statistiques
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.people,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tous les Agents',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard('Total', agents.length.toString(), Colors.blue),
                    _buildStatCard('Aéroports', agentsByAirport.length.toString(), Colors.green),
                  ],
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

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
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
            CircularProgressIndicator(color: Color(0xFF1565C0)),
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

    if (agents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Aucun agent trouvé'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: agentsByAirport.length,
      itemBuilder: (context, index) {
        String airport = agentsByAirport.keys.elementAt(index);
        List<dynamic> airportAgents = agentsByAirport[airport]!;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: const Icon(Icons.flight_takeoff, color: Color(0xFF1565C0)),
            title: Text(
              airport,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${airportAgents.length} agent(s)'),
            trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1565C0)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AirportAgentsScreen(
                    airportName: airport,
                    agents: airportAgents.cast<Map<String, dynamic>>(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAgentTile(dynamic agent) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF1565C0),
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
          if (agent['grade'] != null) Text('Grade: ${agent['grade']}'),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgentDetailsScreen(agent: agent),
          ),
        );
      },
    );
  }
}
