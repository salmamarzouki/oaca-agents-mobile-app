import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConditionsScreen extends StatefulWidget {
  const ConditionsScreen({super.key});

  @override
  State<ConditionsScreen> createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {
  List<dynamic> agents = [];
  Map<String, List<dynamic>> agentsByFunction = {};
  bool isLoading = true;
  String? error;

  // Conditions réglementaires tunisiennes pour l'aviation civile
  final Map<String, Map<String, dynamic>> conditions = {
    'Superviseur': {
      'description': 'Responsable de la supervision des opérations aéroportuaires',
      'requirements': [
        'Diplôme universitaire en aviation ou équivalent',
        'Minimum 5 ans d\'expérience dans l\'aviation civile',
        'Certification OACI en sécurité aéroportuaire',
        'Maîtrise de l\'anglais technique aéronautique',
      ],
      'color': Colors.purple,
      'icon': Icons.supervisor_account,
    },
    'Responsable': {
      'description': 'Responsable d\'équipe ou de service spécialisé',
      'requirements': [
        'Formation spécialisée dans le domaine d\'activité',
        'Minimum 3 ans d\'expérience professionnelle',
        'Capacités de management et leadership',
        'Connaissance des réglementations OACI/DGAC',
      ],
      'color': Colors.blue,
      'icon': Icons.person_pin_circle,
    },
    'Contrôleur': {
      'description': 'Contrôle et vérification des opérations',
      'requirements': [
        'Formation en contrôle aéroportuaire',
        'Certification médicale de classe 3',
        'Formation continue obligatoire',
        'Maîtrise des procédures de sécurité',
      ],
      'color': Colors.orange,
      'icon': Icons.verified_user,
    },
    'Agent': {
      'description': 'Agent opérationnel de base',
      'requirements': [
        'Formation de base en aviation civile',
        'Certificat médical valide',
        'Formation en sécurité aéroportuaire',
        'Respect des procédures opérationnelles',
      ],
      'color': Colors.green,
      'icon': Icons.person,
    },
  };

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
          _groupAgentsByFunction();
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

  void _groupAgentsByFunction() {
    agentsByFunction.clear();
    for (var agent in agents) {
      String fonction = agent['fonction'] ?? 'Non spécifié';
      // Simplifier les fonctions pour correspondre aux conditions
      String simplifiedFunction = _simplifyFunction(fonction);
      
      if (!agentsByFunction.containsKey(simplifiedFunction)) {
        agentsByFunction[simplifiedFunction] = [];
      }
      agentsByFunction[simplifiedFunction]!.add(agent);
    }
  }

  String _simplifyFunction(String fonction) {
    fonction = fonction.toLowerCase();
    if (fonction.contains('superviseur') || fonction.contains('chef')) {
      return 'Superviseur';
    } else if (fonction.contains('responsable')) {
      return 'Responsable';
    } else if (fonction.contains('contrôleur') || fonction.contains('controleur')) {
      return 'Contrôleur';
    } else {
      return 'Agent';
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
        backgroundColor: const Color(0xFF9C27B0),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // En-tête
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.rule,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  'Conditions Agent',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Tester les conditions et fonctions éligibles',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
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
            CircularProgressIndicator(color: Color(0xFF9C27B0)),
            SizedBox(height: 16),
            Text('Chargement des conditions...'),
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: conditions.length,
      itemBuilder: (context, index) {
        String functionType = conditions.keys.elementAt(index);
        Map<String, dynamic> condition = conditions[functionType]!;
        List<dynamic> functionAgents = agentsByFunction[functionType] ?? [];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: Icon(
              condition['icon'] as IconData,
              color: condition['color'] as Color,
              size: 32,
            ),
            title: Text(
              functionType,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(condition['description'] as String),
                const SizedBox(height: 4),
                Text(
                  '${functionAgents.length} agent(s) dans cette catégorie',
                  style: TextStyle(
                    color: condition['color'] as Color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Conditions requises:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ...((condition['requirements'] as List<String>).map((req) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: condition['color'] as Color,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(req)),
                          ],
                        ),
                      ),
                    )),
                    if (functionAgents.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Agents dans cette catégorie:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ...functionAgents.take(3).map((agent) => 
                        ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor: condition['color'] as Color,
                            radius: 16,
                            child: Text(
                              (agent['nom'] ?? 'N')[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          title: Text('${agent['nom']} ${agent['prenom']}'),
                          subtitle: Text(agent['affectation'] ?? 'Non spécifié'),
                        ),
                      ),
                      if (functionAgents.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            '... et ${functionAgents.length - 3} autre(s)',
                            style: TextStyle(
                              color: condition['color'] as Color,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
