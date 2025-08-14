import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/agent.dart';

void main() {
  runApp(const ApiTestApp());
}

class ApiTestApp extends StatelessWidget {
  const ApiTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OACA API Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ApiTestScreen(),
    );
  }
}

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final ApiService _apiService = ApiService();
  List<Agent> _agents = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String _statusMessage = 'Prêt à tester l\'API';
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OACA API Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: _errorMessage.isNotEmpty ? Colors.red.shade50 : Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _errorMessage.isNotEmpty ? Icons.error : Icons.info,
                          color: _errorMessage.isNotEmpty ? Colors.red : Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Status API',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _errorMessage.isNotEmpty ? Colors.red : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_statusMessage),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Erreur: $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Test Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testGetAgents,
                    icon: const Icon(Icons.people),
                    label: const Text('Test Agents'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testGetStats,
                    icon: const Icon(Icons.analytics),
                    label: const Text('Test Stats'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testSearchAgents,
              icon: const Icon(Icons.search),
              label: const Text('Test Search (Abassi)'),
            ),
            const SizedBox(height: 16),

            // Loading Indicator
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Test en cours...'),
                  ],
                ),
              ),

            // Results
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_stats != null) ...[
                      const Text(
                        'Statistiques:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total agents: ${_stats!['total_agents']}'),
                              Text('Total fichiers: ${_stats!['total_files']}'),
                              const SizedBox(height: 8),
                              const Text('Par affectation:'),
                              ...(_stats!['agents_by_affectation'] as Map<String, dynamic>)
                                  .entries
                                  .map((e) => Text('  ${e.key}: ${e.value}')),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_agents.isNotEmpty) ...[
                      Text(
                        'Agents (${_agents.length}):',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ..._agents.take(10).map((agent) => Card(
                        child: ListTile(
                          title: Text(agent.fullName ?? agent.nomComplet ?? 'Nom inconnu'),
                          subtitle: Text('${agent.matricule} - ${agent.affectation}'),
                          trailing: Text(agent.sourceFile ?? ''),
                        ),
                      )),
                      if (_agents.length > 10)
                        Card(
                          child: ListTile(
                            title: Text('... et ${_agents.length - 10} autres agents'),
                            leading: const Icon(Icons.more_horiz),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testGetAgents() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Test de récupération des agents...';
      _errorMessage = '';
    });

    try {
      final agents = await _apiService.getAgents(forceRefresh: true);
      setState(() {
        _agents = agents;
        _statusMessage = 'Agents récupérés avec succès! (${agents.length} agents)';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _statusMessage = 'Échec du test des agents';
        _isLoading = false;
      });
    }
  }

  Future<void> _testGetStats() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Test de récupération des statistiques...';
      _errorMessage = '';
    });

    try {
      final stats = await _apiService.getStats(forceRefresh: true);
      setState(() {
        _stats = stats;
        _statusMessage = 'Statistiques récupérées avec succès!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _statusMessage = 'Échec du test des statistiques';
        _isLoading = false;
      });
    }
  }

  Future<void> _testSearchAgents() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Test de recherche d\'agents (Abassi)...';
      _errorMessage = '';
    });

    try {
      final agents = await _apiService.searchAgents('Abassi');
      setState(() {
        _agents = agents;
        _statusMessage = 'Recherche réussie! (${agents.length} résultats pour "Abassi")';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _statusMessage = 'Échec du test de recherche';
        _isLoading = false;
      });
    }
  }
}