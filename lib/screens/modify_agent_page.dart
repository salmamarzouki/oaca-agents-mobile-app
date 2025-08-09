import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/agent_provider.dart';
import '../models/agent.dart';

class ModifyAgentPage extends StatefulWidget {
  const ModifyAgentPage({super.key});

  @override
  ModifyAgentPageState createState() => ModifyAgentPageState();
}

class ModifyAgentPageState extends State<ModifyAgentPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AgentProvider>(context, listen: false).loadAgentsWithFallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📝 Modifier un agent',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1e3c72),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1e3c72),
              Color(0xFF2a5298),
            ],
          ),
        ),
        child: Consumer<AgentProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Chargement des agents...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Modifier un Agent',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Sélectionnez un agent à modifier',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Liste des agents
                Expanded(
                  child: provider.agents.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_off,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Aucun agent disponible',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: provider.agents.length,
                          itemBuilder: (context, index) {
                            final agent = provider.agents[index];
                            return _buildAgentCard(agent);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAgentCard(Agent agent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showModifyDialog(agent);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 15),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agent.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Informations de base
                    Row(
                      children: [
                        Icon(Icons.badge, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Matricule: ${agent.matricule}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (agent.age != null) ...[
                          const SizedBox(width: 15),
                          Icon(Icons.cake, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Âge: ${agent.age}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Affectation et Formation
                    if (agent.affectation != null && agent.affectation!.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.flight_takeoff, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Affectation: ${agent.affectation}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),

                    if (agent.formation != null && agent.formation!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.school, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Formation: ${agent.formation}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Fonctions
                    if (agent.fonctionActuelle != null && agent.fonctionActuelle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.work, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Fonction: ${agent.fonctionActuelle}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (agent.fonctionTechniqueActuelle != null && agent.fonctionTechniqueActuelle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.engineering, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Fonction technique: ${agent.fonctionTechniqueActuelle}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
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

  void _showModifyDialog(Agent agent) {
    // Contrôleurs pour les champs de texte
    final TextEditingController nomController = TextEditingController(text: agent.nom);
    final TextEditingController prenomController = TextEditingController(text: agent.prenom ?? '');
    final TextEditingController affectationController = TextEditingController(text: agent.affectation);
    final TextEditingController formationController = TextEditingController(text: agent.formation ?? '');
    final TextEditingController periodeController = TextEditingController(text: agent.periode ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier ${agent.fullName}'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: prenomController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: affectationController,
                    decoration: const InputDecoration(
                      labelText: 'Affectation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: formationController,
                    decoration: const InputDecoration(
                      labelText: 'Formation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: periodeController,
                    decoration: const InputDecoration(
                      labelText: 'Période',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Matricule: ${agent.matricule} (non modifiable)',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Sauvegarder les modifications
                await _saveAgentModifications(
                  agent,
                  nomController.text,
                  prenomController.text,
                  affectationController.text,
                  formationController.text,
                  periodeController.text,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Sauvegarder', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveAgentModifications(
    Agent agent,
    String nom,
    String prenom,
    String affectation,
    String formation,
    String periode,
  ) async {
    try {
      // Fermer le dialog
      Navigator.of(context).pop();

      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Appeler l'API Django pour sauvegarder
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/mobile-api/agents/update/${agent.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nom': nom,
          'prenom': prenom,
          'affectation': affectation,
          'formation': formation,
          'periode': periode,
        }),
      );

      // Fermer l'indicateur de chargement
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        // Succès - recharger les données
        Provider.of<AgentProvider>(context, listen: false).loadAgentsWithFallback();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Agent modifié avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // Fermer l'indicateur de chargement si encore ouvert
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur lors de la modification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
