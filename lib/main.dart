import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/agent_provider.dart';
import 'services/api_service.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';
import 'models/agent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AgentProvider()),
      ],
      child: MaterialApp(
        title: 'OACA Agents',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

// Widget qui gère l'authentification
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialiser le provider d'authentification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Afficher un écran de chargement pendant l'initialisation
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement...'),
                ],
              ),
            ),
          );
        }

        // Rediriger vers la page appropriée selon l'état d'authentification
        if (authProvider.isLoggedIn) {
          return const HomePage();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header OACA
              Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  children: [
                    Text(
                      'ديوان الطيران المدني و المطارات',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'OFFICE DE L\'AVIATION CIVILE ET DES AÉROPORTS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flight, color: Colors.white, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Gestion des Agents',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Menu Principal
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Menu Principal',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1e3c72),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Bouton Tous les Agents
                        _buildMenuButton(
                          context: context,
                          icon: Icons.people,
                          title: 'Tous les Agents',
                          subtitle: 'Consulter la liste complète des agents',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AgentsListScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Bouton CRUD
                        _buildMenuButton(
                          context: context,
                          icon: Icons.settings,
                          title: 'CRUD',
                          subtitle: 'Ajouter, modifier, supprimer des agents',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CrudScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Bouton Recherche
                        _buildMenuButton(
                          context: context,
                          icon: Icons.search,
                          title: 'Recherche',
                          subtitle: 'Rechercher un agent spécifique',
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchScreen(),
                              ),
                            );
                          },
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// Écran Liste des Agents
class AgentsListScreen extends StatefulWidget {
  const AgentsListScreen({super.key});

  @override
  State<AgentsListScreen> createState() => _AgentsListScreenState();
}

class _AgentsListScreenState extends State<AgentsListScreen> {
  final ApiService _apiService = ApiService();

  // Données statiques pour test - PPA&GAT&PT (7 aéroports)
  static const List<Map<String, String?>> ppaGatAgents = [
    // AIMT - Monastir Habib Bourguiba
    {
      'nom': 'ABBASSI Sonia',
      'matricule': '10001',
      'affectation': 'AIMT',
      'source': 'PPA&GAT&PT',
      'sheet': 'PPA',
      'formation': null,
      'periode': null,
      'status': null,
    },
    // AISF - Sfax Thyna
    {
      'nom': 'ABDELLI Farid',
      'matricule': '10002',
      'affectation': 'AISF',
      'source': 'PPA&GAT&PT',
      'sheet': 'GAT',
      'formation': null,
      'periode': null,
      'status': null,
    },
    // AITC - Tunis-Carthage
    {
      'nom': 'ACHOUR Mohamed',
      'matricule': '10003',
      'affectation': 'AITC',
      'source': 'PPA&GAT&PT',
      'sheet': 'PT',
      'formation': null,
      'periode': null,
      'status': null,
    },
    // AIDZ - Djerba-Zarzis
    {
      'nom': 'BOUNAGRA Raouf',
      'matricule': '10021',
      'affectation': 'AIDZ',
      'source': 'PPA&GAT&PT',
      'sheet': 'Passerelle',
      'formation': null,
      'periode': null,
      'status': null,
    },
    // AIGK - Gafsa-Ksar
    {
      'nom': 'BOUZRAD Imed Eddine',
      'matricule': '10041',
      'affectation': 'AIGK',
      'source': 'PPA&GAT&PT',
      'sheet': 'PPA',
      'formation': null,
      'periode': null,
      'status': null,
    },
    // AIGM - Gafsa-Metlaoui
    {
      'nom': 'CHAIBI Moncef',
      'matricule': '23086',
      'affectation': 'AIGM',
      'source': 'PPA&GAT&PT',
      'sheet': 'GAT',
      'formation': null,
      'periode': null,
      'status': null,
    },
    // AITK - Tabarka
    {
      'nom': 'MANSOURI Karim',
      'matricule': '10050',
      'affectation': 'AITK',
      'source': 'PPA&GAT&PT',
      'sheet': 'PPA',
      'formation': null,
      'periode': null,
      'status': null,
    },
  ];

  // Données statiques pour test - Naima 2022
  static const List<Map<String, String?>> naimaAgents = [
    {
      'nom': 'BENALI Ahmed',
      'matricule': '20001',
      'affectation': 'AIMT',
      'source': 'Naima 2022',
      'sheet': 'Formation',
      'formation': 'Contrôle Aérien',
      'periode': '2022-2023',
      'status': 'Certifié',
    },
    {
      'nom': 'GHARBI Fatma',
      'matricule': '20002',
      'affectation': 'AISF',
      'source': 'Naima 2022',
      'sheet': 'Formation',
      'formation': 'Sécurité Aéroportuaire',
      'periode': '2022-2023',
      'status': 'En cours',
    },
  ];



  // Méthode pour grouper les agents par aéroport
  Map<String, List<Map<String, String?>>> _groupAgentsByAirport(List<Map<String, String?>> agents) {
    Map<String, List<Map<String, String?>>> grouped = {};

    for (var agent in agents) {
      String airport = agent['affectation'] ?? 'Inconnu';
      if (!grouped.containsKey(airport)) {
        grouped[airport] = [];
      }
      grouped[airport]!.add(agent);
    }

    return grouped;
  }

  Map<String, List<Map<String, String?>>> _groupAgentsByAirportFromApi(List<Agent> agents) {
    final Map<String, List<Map<String, String?>>> grouped = {};

    for (final agent in agents) {
      final airport = agent.affectation ?? 'Non affecté';
      if (!grouped.containsKey(airport)) {
        grouped[airport] = [];
      }
      grouped[airport]!.add({
        'nom': agent.fullName,
        'matricule': agent.matricule,
        'affectation': agent.affectation,
        'formation': agent.formation,
        'source': agent.sourceFile,
        'status': agent.status,
      });
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agents par Aéroport'),
        backgroundColor: const Color(0xFF1e3c72),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Agent>>(
        future: _apiService.getAgents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement des agents...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text('Erreur: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final allAgents = snapshot.data ?? [];
          final agentsByAirport = _groupAgentsByAirportFromApi(allAgents);
          final sortedAirports = agentsByAirport.keys.toList()..sort();

          // Séparer les agents par source
          final ppaGatAgents = allAgents.where((agent) =>
            agent.sourceFile.contains('PPA&GAT&PT')).toList();
          final naimaAgents = allAgents.where((agent) =>
            agent.sourceFile.contains('naima')).toList();

          return Column(
            children: [
              // En-tête avec statistiques
              Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFF1e3c72).withOpacity(0.1),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('Total', allAgents.length.toString(), Colors.blue),
                        _buildStatCard('Aéroports', sortedAirports.length.toString(), Colors.purple),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('PPA&GAT&PT', ppaGatAgents.length.toString(), Colors.orange),
                        _buildStatCard('Naima 2022', naimaAgents.length.toString(), Colors.green),
                      ],
                    ),
                  ],
                ),
              ),

          // Liste des agents par aéroport
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedAirports.length,
              itemBuilder: (context, airportIndex) {
                final airport = sortedAirports[airportIndex];
                final airportAgents = agentsByAirport[airport]!;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getAffectationColor(airport),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.flight_takeoff,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AirportAgentsScreen(
                              airport: airport,
                              agents: airportAgents,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        airport,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _getAffectationColor(airport),
                        ),
                      ),
                    ),
                    subtitle: Text(
                      '${airportAgents.length} agent${airportAgents.length > 1 ? 's' : ''}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    children: airportAgents.map((agent) {
                      final isFromNaima = agent['source'] == 'Naima 2022';
                      final sourceColor = isFromNaima ? Colors.green : Colors.blue;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: sourceColor,
                          child: Text(
                            agent['matricule']!.substring(agent['matricule']!.length - 2),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          agent['nom']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Matricule: ${agent['matricule']}'),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getAffectationColor(agent['affectation']!).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getAffectationColor(agent['affectation']!),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                agent['affectation']!,
                                style: TextStyle(
                                  color: _getAffectationColor(agent['affectation']!),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (agent['status'] != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  agent['status']!.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: sourceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        agent['source']!,
                        style: TextStyle(
                          color: sourceColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                        onTap: () {
                          _showAgentDetails(context, agent);
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAffectationColor(String affectation) {
    switch (affectation) {
      case 'AIMT':
        return Colors.blue;
      case 'AISF':
        return Colors.green;
      case 'AITC':
        return Colors.orange;
      case 'AIDZ':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showAgentDetails(BuildContext context, Map<String, String?> agent) {
    final isFromNaima = agent['source'] == 'Naima 2022';
    final sourceColor = isFromNaima ? Colors.green : Colors.blue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: sourceColor,
                child: Text(
                  agent['matricule']!.substring(agent['matricule']!.length - 2),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agent['nom']!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: sourceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Source: ${agent['source']}',
                        style: TextStyle(
                          color: sourceColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(Icons.badge, 'Matricule', agent['matricule']!),
              const SizedBox(height: 10),
              _buildDetailRow(Icons.location_on, 'Affectation', agent['affectation']!),
              const SizedBox(height: 10),
              _buildDetailRow(Icons.tab, 'Sheet', agent['sheet'] ?? 'N/A'),
              if (agent['formation'] != null) ...[
                const SizedBox(height: 10),
                _buildDetailRow(Icons.school, 'Formation', agent['formation']!),
              ],
              if (agent['periode'] != null) ...[
                const SizedBox(height: 10),
                _buildDetailRow(Icons.calendar_today, 'Période', agent['periode']!),
              ],
              if (agent['status'] != null) ...[
                const SizedBox(height: 10),
                _buildDetailRow(Icons.check_circle, 'Statut', agent['status']!),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1e3c72)),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}

// Écran CRUD
class CrudScreen extends StatelessWidget {
  const CrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD - Gestion'),
        backgroundColor: const Color(0xFF1e3c72),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCrudOption(
              context: context,
              icon: Icons.add,
              title: 'Ajouter un Agent',
              subtitle: 'Créer un nouveau profil d\'agent',
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité en développement')),
                );
              },
            ),
            const SizedBox(height: 15),
            _buildCrudOption(
              context: context,
              icon: Icons.edit,
              title: 'Modifier un Agent',
              subtitle: 'Modifier les informations d\'un agent',
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité en développement')),
                );
              },
            ),
            const SizedBox(height: 15),
            _buildCrudOption(
              context: context,
              icon: Icons.delete,
              title: 'Supprimer un Agent',
              subtitle: 'Supprimer un agent du système',
              color: Colors.red,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité en développement')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrudOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Écran Recherche
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  // Données statiques pour test
  final List<Map<String, String>> allAgents = const [
    {'nom': 'Ahmed Ben Ali', 'matricule': '10001', 'affectation': 'AIMT'},
    {'nom': 'Fatma Trabelsi', 'matricule': '10002', 'affectation': 'AISF'},
    {'nom': 'Mohamed Gharbi', 'matricule': '10003', 'affectation': 'AITC'},
    {'nom': 'Leila Mansouri', 'matricule': '10004', 'affectation': 'AIMT'},
    {'nom': 'Karim Bouazizi', 'matricule': '10005', 'affectation': 'AISF'},
  ];

  List<Map<String, String>> filteredAgents = [];

  void searchAgents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAgents = [];
      } else {
        filteredAgents = allAgents.where((agent) {
          final name = agent['nom']!.toLowerCase();
          final matricule = agent['matricule']!.toLowerCase();
          final affectation = agent['affectation']!.toLowerCase();
          final searchTerm = query.toLowerCase();

          return name.contains(searchTerm) ||
                 matricule.contains(searchTerm) ||
                 affectation.contains(searchTerm);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche'),
        backgroundColor: const Color(0xFF1e3c72),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: searchAgents,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, matricule, affectation...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredAgents.isEmpty
                ? const Center(
                    child: Text('Tapez pour rechercher un agent'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAgents.length,
                    itemBuilder: (context, index) {
                      final agent = filteredAgents[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF1e3c72),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            agent['nom']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Matricule: ${agent['matricule']}'),
                              Text('Affectation: ${agent['affectation']}'),
                            ],
                          ),
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

// Écran des agents d'un aéroport spécifique
class AirportAgentsScreen extends StatelessWidget {
  final String airport;
  final List<Map<String, String?>> agents;

  const AirportAgentsScreen({
    super.key,
    required this.airport,
    required this.agents,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agents - $airport'),
        backgroundColor: const Color(0xFF1e3c72),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // En-tête avec informations de l'aéroport
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1e3c72).withOpacity(0.1),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getAffectationColor(airport),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.flight_takeoff,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aéroport $airport',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _getAffectationColor(airport),
                        ),
                      ),
                      Text(
                        '${agents.length} agent${agents.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Liste des agents
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: agents.length,
              itemBuilder: (context, index) {
                final agent = agents[index];
                final isFromNaima = agent['source'] == 'Naima 2022';
                final sourceColor = isFromNaima ? Colors.green : Colors.blue;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: sourceColor,
                      child: Text(
                        agent['matricule']!.substring(agent['matricule']!.length - 2),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      agent['nom']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Matricule: ${agent['matricule']}'),
                        if (agent['sheet'] != null)
                          Text('Section: ${agent['sheet']}'),
                        if (agent['formation'] != null)
                          Text('Formation: ${agent['formation']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: sourceColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            agent['source']!,
                            style: TextStyle(
                              color: sourceColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.edit,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ],
                    ),
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
            ),
          ),
        ],
      ),
    );
  }

  Color _getAffectationColor(String affectation) {
    switch (affectation) {
      case 'AIMT':
        return Colors.blue;
      case 'AISF':
        return Colors.green;
      case 'AITC':
        return Colors.orange;
      case 'AIDZ':
        return Colors.purple;
      case 'AIGK':
        return Colors.red;
      case 'AIGM':
        return Colors.teal;
      case 'AITK':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}

// Écran de modification d'un agent
class EditAgentScreen extends StatefulWidget {
  final Map<String, String?> agent;

  const EditAgentScreen({
    super.key,
    required this.agent,
  });

  @override
  State<EditAgentScreen> createState() => _EditAgentScreenState();
}

class _EditAgentScreenState extends State<EditAgentScreen> {
  late TextEditingController nomController;
  late TextEditingController matriculeController;
  late TextEditingController affectationController;
  late TextEditingController formationController;
  late TextEditingController periodeController;
  late TextEditingController statusController;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.agent['nom'] ?? '');
    matriculeController = TextEditingController(text: widget.agent['matricule'] ?? '');
    affectationController = TextEditingController(text: widget.agent['affectation'] ?? '');
    formationController = TextEditingController(text: widget.agent['formation'] ?? '');
    periodeController = TextEditingController(text: widget.agent['periode'] ?? '');
    statusController = TextEditingController(text: widget.agent['status'] ?? '');
  }

  @override
  void dispose() {
    nomController.dispose();
    matriculeController.dispose();
    affectationController.dispose();
    formationController.dispose();
    periodeController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Agent'),
        backgroundColor: const Color(0xFF1e3c72),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              _saveChanges();
            },
            child: const Text(
              'Sauvegarder',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec informations de base
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF1e3c72),
                      radius: 30,
                      child: Text(
                        widget.agent['matricule']!.substring(widget.agent['matricule']!.length - 2),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Modification Agent',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Source: ${widget.agent['source']}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Formulaire de modification
            _buildTextField('Nom', nomController, Icons.person),
            const SizedBox(height: 16),
            _buildTextField('Matricule', matriculeController, Icons.badge),
            const SizedBox(height: 16),
            _buildTextField('Affectation', affectationController, Icons.location_on),
            const SizedBox(height: 16),
            _buildTextField('Formation', formationController, Icons.school),
            const SizedBox(height: 16),
            _buildTextField('Période', periodeController, Icons.calendar_today),
            const SizedBox(height: 16),
            _buildTextField('Statut', statusController, Icons.check_circle),

            const SizedBox(height: 30),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _saveChanges();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Sauvegarder les modifications'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1e3c72),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1e3c72)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1e3c72), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _saveChanges() {
    // Ici, vous pouvez ajouter la logique pour sauvegarder les modifications
    // Par exemple, appeler une API ou mettre à jour une base de données locale

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modifications sauvegardées avec succès!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}
