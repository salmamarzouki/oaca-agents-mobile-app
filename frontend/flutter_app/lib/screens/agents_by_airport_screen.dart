import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/agent_provider.dart';
import '../models/agent.dart';
import 'agent_detail_screen.dart';

class AgentsByAirportScreen extends StatelessWidget {
  final String airportCode;

  const AgentsByAirportScreen({
    super.key,
    required this.airportCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agents - $airportCode',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1e3c72),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
          ),
        ),
        child: Consumer<AgentProvider>(
          builder: (context, provider, child) {
            // Filtrer les agents par aéroport
            final airportAgents = provider.agents
                .where((agent) => agent.affectation == airportCode)
                .toList();

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

            if (airportAgents.isEmpty) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, color: Colors.grey, size: 64),
                      SizedBox(height: 20),
                      Text(
                        'Aucun agent trouvé pour cet aéroport',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // En-tête
                  Container(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Text(
                          'Aéroport $airportCode',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1e3c72),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${airportAgents.length} agent${airportAgents.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Liste des agents
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: airportAgents.length,
                      itemBuilder: (context, index) {
                        final agent = airportAgents[index];
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(20),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF1e3c72).withOpacity(0.1),
                              radius: 30,
                              child: Text(
                                _getInitials(agent.nom, agent.prenom),
                                style: const TextStyle(
                                  color: Color(0xFF1e3c72),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            title: Text(
                              '${agent.nom ?? ''} ${agent.prenom ?? ''}'.trim(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1e3c72),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (agent.fonctionActuelle != null && agent.fonctionActuelle!.isNotEmpty)
                                  Text(
                                    agent.fonctionActuelle!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                if (agent.matricule.isNotEmpty)
                                  Text(
                                    'Matricule: ${agent.matricule}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFF1e3c72),
                            ),
                            onTap: () {
                              // Afficher les détails de l'agent
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('${agent.nom} ${agent.prenom ?? ''}'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildDetailRow('Matricule', agent.matricule),
                                        _buildDetailRow('Fonction', agent.fonctionActuelle),
                                        _buildDetailRow('Affectation', agent.affectation),
                                        _buildDetailRow('Date naissance', agent.dateNaissance),
                                        _buildDetailRow('Formation', agent.formation),
                                        _buildDetailRow('Source', agent.sourceFile),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Fermer'),
                                    ),
                                  ],
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
          },
        ),
      ),
    );
  }

  String _getInitials(String? nom, String? prenom) {
    final n = nom?.isNotEmpty == true ? nom![0].toUpperCase() : '';
    final p = prenom?.isNotEmpty == true ? prenom![0].toUpperCase() : '';
    return '$n$p'.isNotEmpty ? '$n$p' : '?';
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1e3c72),
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
