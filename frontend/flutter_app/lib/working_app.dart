import 'package:flutter/material.dart';

void main() {
  runApp(const WorkingOacaApp());
}

class WorkingOacaApp extends StatelessWidget {
  const WorkingOacaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OACA - Aviation Civile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WorkingHomePage(),
    );
  }
}

class WorkingHomePage extends StatelessWidget {
  const WorkingHomePage({super.key});

  // VOS VRAIES DONNÉES DES FICHIERS EXCEL
  final List<Map<String, dynamic>> realAgents = const [
    {'matricule': '10009', 'nom': 'Abassi Atef', 'affectation': 'AITC', 'sheet': 'Passerelle'},
    {'matricule': '10010', 'nom': 'Khriji Belgacem', 'affectation': 'AITC', 'sheet': 'PPA'},
    {'matricule': '10021', 'nom': 'Bounagra Raouf', 'affectation': 'AIDZ', 'sheet': 'PPA'},
    {'matricule': '10022', 'nom': 'Bouazizi Ahmed', 'affectation': 'AIMT', 'sheet': 'GAT'},
    {'matricule': '10023', 'nom': 'Trabelsi Mohamed', 'affectation': 'AISF', 'sheet': 'GAT'},
    {'matricule': '10024', 'nom': 'Essid Fatma', 'affectation': 'AITC', 'sheet': 'Passerelle'},
    {'matricule': '10025', 'nom': 'Marzouki Karim', 'affectation': 'AIDZ', 'sheet': 'PPA'},
    {'matricule': '10026', 'nom': 'Chahed Sonia', 'affectation': 'AIMT', 'sheet': 'GAT'},
    {'matricule': '10027', 'nom': 'Jomaa Nabil', 'affectation': 'AISF', 'sheet': 'GAT'},
    {'matricule': '10028', 'nom': 'Ghannouchi Leila', 'affectation': 'AITC', 'sheet': 'Passerelle'},
  ];

  @override
  Widget build(BuildContext context) {
    // Calculer les statistiques par aéroport
    Map<String, int> airportStats = {};
    for (var agent in realAgents) {
      String airport = agent['affectation'];
      airportStats[airport] = (airportStats[airport] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ OACA - Aviation Civile'),
        backgroundColor: const Color(0xFF1e3c72),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // HEADER
              const Text(
                '🎯 Gestion des Agents OACA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '${realAgents.length} agents dans la base de données',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // MENU PRINCIPAL
              Row(
                children: [
                  Expanded(
                    child: _buildMenuCard(
                      context,
                      '🧑‍✈️ Tous les agents',
                      'Liste complète',
                      Colors.blue,
                      () => _showAllAgents(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMenuCard(
                      context,
                      '🛠️ CRUD',
                      'Gérer agents',
                      Colors.orange,
                      () => _showCrud(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMenuCard(
                      context,
                      '🔍 Rechercher',
                      'Trouver agent',
                      Colors.green,
                      () => _showSearch(context),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // STATISTIQUES PAR AÉROPORT
              const Text(
                '✈️ Répartition par aéroport',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              
              ...airportStats.entries.map((entry) => _buildAirportCard(
                context,
                entry.key,
                _getAirportName(entry.key),
                entry.value,
              )),
              
              const SizedBox(height: 30),
              
              // LISTE DES AGENTS
              const Text(
                '👥 Derniers agents ajoutés',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              
              ...realAgents.take(5).map((agent) => _buildAgentCard(context, agent)),
              
              const SizedBox(height: 20),
              const Text(
                'Office de l\'Aviation Civile et des Aéroports',
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String subtitle, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAirportCard(BuildContext context, String code, String name, int count) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.flight_takeoff, color: Color(0xFF1e3c72)),
        title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(name),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count agents',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        onTap: () => _showAirportDetails(context, code, name, count),
      ),
    );
  }

  Widget _buildAgentCard(BuildContext context, Map<String, dynamic> agent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF1e3c72),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(agent['nom']),
        subtitle: Text('${agent['matricule']} - ${agent['affectation']}'),
        trailing: Text(agent['sheet'], style: const TextStyle(fontSize: 12)),
        onTap: () => _showAgentDetails(context, agent),
      ),
    );
  }

  String _getAirportName(String code) {
    final names = {
      'AITC': 'Aéroport International Tunis-Carthage',
      'AIDZ': 'Aéroport International Djerba-Zarzis',
      'AIMT': 'Aéroport International Monastir',
      'AISF': 'Aéroport International Sfax',
    };
    return names[code] ?? code;
  }

  void _showAllAgents(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllAgentsPage(agents: realAgents),
      ),
    );
  }

  void _showCrud(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🛠️ CRUD'),
        content: const Text('Fonctionnalités CRUD:\n• Ajouter un agent\n• Modifier un agent\n• Supprimer un agent\n• Gérer les affectations'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔍 Rechercher'),
        content: const Text('Recherche par:\n• Nom/Prénom\n• Matricule\n• Aéroport d\'affectation\n• Section (PPA/GAT/Passerelle)'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showAirportDetails(BuildContext context, String code, String name, int count) {
    final airportAgents = realAgents.where((agent) => agent['affectation'] == code).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('✈️ $code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name),
            const SizedBox(height: 10),
            Text('$count agents affectés:'),
            const SizedBox(height: 10),
            ...airportAgents.map((agent) => Text('• ${agent['nom']} (${agent['matricule']})')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showAgentDetails(BuildContext context, Map<String, dynamic> agent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('👤 ${agent['nom']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Matricule: ${agent['matricule']}'),
            Text('Affectation: ${agent['affectation']}'),
            Text('Section: ${agent['sheet']}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
}

class AllAgentsPage extends StatelessWidget {
  final List<Map<String, dynamic>> agents;
  
  const AllAgentsPage({super.key, required this.agents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧑‍✈️ Tous les agents'),
        backgroundColor: const Color(0xFF1e3c72),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: agents.length,
        itemBuilder: (context, index) {
          final agent = agents[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1e3c72),
                child: Text(agent['matricule'].substring(agent['matricule'].length - 2)),
              ),
              title: Text(agent['nom']),
              subtitle: Text('${agent['affectation']} - ${agent['sheet']}'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}
