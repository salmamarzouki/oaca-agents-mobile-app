import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const CompleteOacaApp());
}

class CompleteOacaApp extends StatelessWidget {
  const CompleteOacaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OACA - Aviation Civile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1e3c72),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const CompleteHomePage(),
    );
  }
}

class CompleteHomePage extends StatefulWidget {
  const CompleteHomePage({super.key});

  @override
  State<CompleteHomePage> createState() => _CompleteHomePageState();
}

class _CompleteHomePageState extends State<CompleteHomePage> {
  List<dynamic> agents = [];
  Map<String, List<dynamic>> agentsByAirport = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAgentsFromDjango();
  }

  Future<void> _loadAgentsFromDjango() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/mobile-api/agents/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          agents = data['agents'];
          _groupAgentsByAirport();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur API: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion: $e';
        isLoading = false;
      });
    }
  }

  void _groupAgentsByAirport() {
    agentsByAirport.clear();
    for (var agent in agents) {
      String airport = agent['affectation'] ?? 'Non affecté';
      if (!agentsByAirport.containsKey(airport)) {
        agentsByAirport[airport] = [];
      }
      agentsByAirport[airport]!.add(agent);
    }
    
    // Trier les aéroports par ordre alphabétique et vérifier les comptages
    final sortedKeys = agentsByAirport.keys.toList()..sort();
    final sortedMap = <String, List<dynamic>>{};
    for (String key in sortedKeys) {
      // S'assurer que la liste n'est pas vide avant de l'ajouter
      if (agentsByAirport[key]!.isNotEmpty) {
        sortedMap[key] = agentsByAirport[key]!;
      }
    }
    agentsByAirport = sortedMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ OACA - Aviation Civile'),
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
        child: isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Chargement des données depuis Django...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            : errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 60),
                        const SizedBox(height: 20),
                        Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              errorMessage = '';
                            });
                            _loadAgentsFromDjango();
                          },
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // HEADER
                        Text(
                          '🎯 Gestion des ${agents.length} Agents OACA',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Données en temps réel depuis Django',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        
                        // MENU PRINCIPAL
                        Row(
                          children: [
                            Expanded(
                              child: _buildMenuCard(
                                '🧑‍✈️ Liste des agents',
                                'Par aéroport',
                                Colors.blue,
                                () => _showAgentsList(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMenuCard(
                                '🛠️ CRUD',
                                'Gérer agents',
                                Colors.orange,
                                () => _showCrud(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMenuCard(
                                '🔍 Rechercher',
                                'Trouver agent',
                                Colors.green,
                                () => _showSearch(),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // APERÇU DES AÉROPORTS
                        const Text(
                          '✈️ Aéroports (triés alphabétiquement)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        
                        ...agentsByAirport.entries.map((entry) => 
                          _buildAirportCard(entry.key, entry.value.length)
                        ),
                        
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

  Widget _buildMenuCard(String title, String subtitle, Color color, VoidCallback onTap) {
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

  Widget _buildAirportCard(String airport, int count) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.flight_takeoff, color: Color(0xFF1e3c72)),
        title: Text(airport, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_getAirportName(airport)),
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
        onTap: () => _showAirportAgents(airport),
      ),
    );
  }

  String _getAirportName(String code) {
    final names = {
      'AITC': 'Aéroport International Tunis-Carthage',
      'AIDZ': 'Aéroport International Djerba-Zarzis',
      'AIMT': 'Aéroport International Monastir',
      'AISF': 'Aéroport International Sfax',
      'AIGK': 'Aéroport International Gafsa',
      'AITN': 'Aéroport International Tozeur',
      'AIST': 'Aéroport International Sfax-Thyna',
      'AITAD': 'Aéroport International Tabarka',
      'AIGM': 'Aéroport International Gafsa-Metlaoui',
    };
    return names[code] ?? code;
  }

  void _showAgentsList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgentsListPage(agentsByAirport: agentsByAirport),
      ),
    );
  }

  void _showCrud() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrudPage(onRefresh: _loadAgentsFromDjango),
      ),
    );
  }

  void _showSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(agents: agents),
      ),
    );
  }

  void _showAirportAgents(String airport) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AirportAgentsPage(
          airport: airport,
          agents: agentsByAirport[airport]!,
        ),
      ),
    );
  }
}

// PAGE LISTE DES AGENTS PAR AÉROPORT
class AgentsListPage extends StatelessWidget {
  final Map<String, List<dynamic>> agentsByAirport;

  const AgentsListPage({super.key, required this.agentsByAirport});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧑‍✈️ Liste des agents'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: agentsByAirport.keys.length,
        itemBuilder: (context, index) {
          final airport = agentsByAirport.keys.elementAt(index);
          final agents = agentsByAirport[airport]!;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: const Icon(Icons.flight_takeoff, color: Color(0xFF1e3c72)),
              title: Text(
                airport,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${agents.length} agents'),
              children: agents.map((agent) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF1e3c72),
                  child: Text(
                    agent['matricule'].toString().substring(
                      agent['matricule'].toString().length - 2
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                title: Text(agent['full_name'] ?? agent['nom_complet'] ?? agent['nom']),
                subtitle: Text('Matricule: ${agent['matricule']}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showAgentDetails(context, agent),
              )).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showAgentDetails(BuildContext context, Map<String, dynamic> agent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('👤 ${agent['full_name'] ?? agent['nom_complet'] ?? agent['nom']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Matricule: ${agent['matricule']}'),
            Text('Affectation: ${agent['affectation'] ?? 'Non affecté'}'),
            if (agent['periode'] != null) Text('Période: ${agent['periode']}'),
            if (agent['sheet_name'] != null) Text('Section: ${agent['sheet_name']}'),
            if (agent['source_file'] != null)
              Text('Source: ${agent['source_file'].toString().split('/').last}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

// PAGE AGENTS D'UN AÉROPORT SPÉCIFIQUE
class AirportAgentsPage extends StatelessWidget {
  final String airport;
  final List<dynamic> agents;

  const AirportAgentsPage({
    super.key,
    required this.airport,
    required this.agents,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('✈️ $airport'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1e3c72),
            child: Text(
              '${agents.length} agents affectés à $airport',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: agents.length,
              itemBuilder: (context, index) {
                final agent = agents[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1e3c72),
                      child: Text(
                        agent['matricule'].toString().substring(
                          agent['matricule'].toString().length - 2
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    title: Text(agent['full_name'] ?? agent['nom_complet'] ?? agent['nom']),
                    subtitle: Text('Matricule: ${agent['matricule']}'),
                    trailing: agent['sheet_name'] != null
                        ? Chip(
                            label: Text(
                              agent['sheet_name'],
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: Colors.blue.shade100,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// PAGE CRUD
class CrudPage extends StatefulWidget {
  final VoidCallback onRefresh;

  const CrudPage({super.key, required this.onRefresh});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _affectationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛠️ CRUD - Gestion des agents'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FORMULAIRE D'AJOUT
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '➕ Ajouter un nouvel agent',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1e3c72),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _matriculeController,
                        decoration: const InputDecoration(
                          labelText: 'Matricule *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le matricule est obligatoire';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nomController,
                        decoration: const InputDecoration(
                          labelText: 'Nom *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le nom est obligatoire';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _prenomController,
                        decoration: const InputDecoration(
                          labelText: 'Prénom',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _affectationController,
                        decoration: const InputDecoration(
                          labelText: 'Affectation',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flight_takeoff),
                          hintText: 'Ex: AITC, AIDZ, etc.',
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addAgent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1e3c72),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Ajouter l\'agent'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ACTIONS CRUD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚙️ Autres actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1e3c72),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.edit, color: Colors.orange),
                      title: const Text('Modifier un agent'),
                      subtitle: const Text('Rechercher et modifier les informations'),
                      onTap: () => _showModifyDialog(),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text('Supprimer un agent'),
                      subtitle: const Text('Rechercher et supprimer un agent'),
                      onTap: () => _showDeleteDialog(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addAgent() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/mobile-api/agents/create/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'matricule': _matriculeController.text,
          'nom': _nomController.text,
          'prenom': _prenomController.text.isEmpty ? null : _prenomController.text,
          'affectation': _affectationController.text.isEmpty ? null : _affectationController.text,
          'source_file': 'Ajouté via mobile app',
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Agent ajouté avec succès!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _clearForm();
        widget.onRefresh();
      } else {
        final error = json.decode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Erreur: ${error['error'] ?? 'Erreur inconnue'}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur de connexion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearForm() {
    _matriculeController.clear();
    _nomController.clear();
    _prenomController.clear();
    _affectationController.clear();
  }

  void _showModifyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔧 Modifier un agent'),
        content: const Text('Fonctionnalité de modification en cours de développement.\n\nPour modifier un agent:\n1. Notez son matricule\n2. Utilisez l\'interface Django admin\n3. Ou implémentez cette fonctionnalité'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🗑️ Supprimer un agent'),
        content: const Text('Fonctionnalité de suppression en cours de développement.\n\nPour supprimer un agent:\n1. Notez son matricule\n2. Utilisez l\'interface Django admin\n3. Ou implémentez cette fonctionnalité'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _matriculeController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _affectationController.dispose();
    super.dispose();
  }
}

// PAGE RECHERCHE
class SearchPage extends StatefulWidget {
  final List<dynamic> agents;

  const SearchPage({super.key, required this.agents});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<dynamic> filteredAgents = [];
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
          final matricule = agent['matricule'].toString().toLowerCase();
          final nom = (agent['full_name'] ?? agent['nom_complet'] ?? agent['nom']).toString().toLowerCase();
          final affectation = (agent['affectation'] ?? '').toString().toLowerCase();
          final sheetName = (agent['sheet_name'] ?? '').toString().toLowerCase();

          return matricule.contains(query.toLowerCase()) ||
                 nom.contains(query.toLowerCase()) ||
                 affectation.contains(query.toLowerCase()) ||
                 sheetName.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Rechercher un agent'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // BARRE DE RECHERCHE
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: TextField(
              controller: _searchController,
              onChanged: _filterAgents,
              decoration: InputDecoration(
                hintText: 'Rechercher par matricule, nom, affectation...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterAgents('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // RÉSULTATS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filteredAgents.length} résultat(s) trouvé(s)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1e3c72),
                  ),
                ),
                if (searchQuery.isNotEmpty) ...[
                  const Text(' pour "'),
                  Text(
                    searchQuery,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF1e3c72),
                    ),
                  ),
                  const Text('"'),
                ],
              ],
            ),
          ),

          // LISTE DES RÉSULTATS
          Expanded(
            child: filteredAgents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          searchQuery.isEmpty ? Icons.search : Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isEmpty
                              ? 'Tapez pour rechercher un agent'
                              : 'Aucun agent trouvé pour "$searchQuery"',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAgents.length,
                    itemBuilder: (context, index) {
                      final agent = filteredAgents[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF1e3c72),
                            child: Text(
                              agent['matricule'].toString().substring(
                                agent['matricule'].toString().length - 2
                              ),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          title: Text(
                            agent['full_name'] ?? agent['nom_complet'] ?? agent['nom'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Matricule: ${agent['matricule']}'),
                              if (agent['affectation'] != null)
                                Text('Affectation: ${agent['affectation']}'),
                            ],
                          ),
                          trailing: agent['sheet_name'] != null
                              ? Chip(
                                  label: Text(
                                    agent['sheet_name'],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor: Colors.blue.shade100,
                                )
                              : const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _showAgentDetails(agent),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAgentDetails(Map<String, dynamic> agent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('👤 ${agent['full_name'] ?? agent['nom_complet'] ?? agent['nom']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Matricule', agent['matricule']),
            _buildDetailRow('Affectation', agent['affectation']),
            if (agent['periode'] != null) _buildDetailRow('Période', agent['periode']),
            if (agent['sheet_name'] != null) _buildDetailRow('Section', agent['sheet_name']),
            if (agent['source_file'] != null)
              _buildDetailRow('Source', agent['source_file'].toString().split('/').last),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.toString())),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

