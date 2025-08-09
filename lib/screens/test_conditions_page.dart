import 'package:flutter/material.dart';
import '../models/agent_conditions.dart';

class TestConditionsPage extends StatefulWidget {
  const TestConditionsPage({super.key});

  @override
  State<TestConditionsPage> createState() => _TestConditionsPageState();
}

class _TestConditionsPageState extends State<TestConditionsPage> {
  // Conditions de test
  bool _formationAbInitio = false;
  bool _formationGestionEquipe = false;
  bool _formationFormateurs = false;
  bool _formationLeadership = false;
  bool _examenSecurite = false;
  bool _certificatMedical = false;
  
  int _ancienneteStage = 0;
  int _ancienneteControleur = 0;
  int _ancienneteAssistant = 0;
  int _ancienneteSupervisor = 0;
  int _ancienneteInstructeur = 0;
  int _ancienneteResponsable = 0;

  @override
  Widget build(BuildContext context) {
    // Créer les conditions actuelles
    AgentConditions conditions = AgentConditions(
      formationAbInitio: _formationAbInitio,
      formationGestionEquipe: _formationGestionEquipe,
      formationDesFormateurs: _formationFormateurs,
      formationLeadership: _formationLeadership,
      examenSecuriteExploitation: _examenSecurite,
      certificatMedical: _certificatMedical,
      ancienneteControleurStage: _ancienneteStage,
      ancienneteControleurAireTrafic: _ancienneteControleur,
      ancienneteAssistant: _ancienneteAssistant,
      ancienneteSupervisor: _ancienneteSupervisor,
      ancienneteControleurInstructeur: _ancienneteInstructeur,
      ancienneteResponsableCellule: _ancienneteResponsable,
    );

    // Obtenir les fonctions éligibles
    List<FonctionAgent> fonctionsEligibles = AgentConditionsLogic.getFonctionsEligibles(conditions);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎯 Test des Conditions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1e3c72),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.assignment_turned_in, color: Colors.white, size: 50),
                      SizedBox(height: 10),
                      Text(
                        'Testez les Conditions d\'Agent',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Cochez les conditions pour voir les fonctions éligibles',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Section Formations
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📚 Formations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1e3c72))),
                        const SizedBox(height: 10),
                        
                        CheckboxListTile(
                          title: const Text('Formation Ab-Initio'),
                          subtitle: const Text('Requis pour: Contrôleur Stagiaire'),
                          value: _formationAbInitio,
                          onChanged: (value) => setState(() => _formationAbInitio = value ?? false),
                          activeColor: const Color(0xFF1e3c72),
                        ),
                        CheckboxListTile(
                          title: const Text('Formation Gestion Équipe'),
                          subtitle: const Text('Requis pour: Supervisor'),
                          value: _formationGestionEquipe,
                          onChanged: (value) => setState(() => _formationGestionEquipe = value ?? false),
                          activeColor: const Color(0xFF1e3c72),
                        ),
                        CheckboxListTile(
                          title: const Text('Formation des Formateurs'),
                          subtitle: const Text('Requis pour: Contrôleur Instructeur'),
                          value: _formationFormateurs,
                          onChanged: (value) => setState(() => _formationFormateurs = value ?? false),
                          activeColor: const Color(0xFF1e3c72),
                        ),
                        CheckboxListTile(
                          title: const Text('Formation Leadership'),
                          subtitle: const Text('Requis pour: Responsable Unité GAT'),
                          value: _formationLeadership,
                          onChanged: (value) => setState(() => _formationLeadership = value ?? false),
                          activeColor: const Color(0xFF1e3c72),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Section Examens
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📝 Examens & Certificats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1e3c72))),
                        const SizedBox(height: 10),
                        
                        CheckboxListTile(
                          title: const Text('Examen Sécurité d\'Exploitation'),
                          subtitle: const Text('Requis pour: Contrôleur Aire de Trafic'),
                          value: _examenSecurite,
                          onChanged: (value) => setState(() => _examenSecurite = value ?? false),
                          activeColor: const Color(0xFF1e3c72),
                        ),
                        CheckboxListTile(
                          title: const Text('Certificat Médical'),
                          subtitle: const Text('Requis pour: Responsable Unité GAT'),
                          value: _certificatMedical,
                          onChanged: (value) => setState(() => _certificatMedical = value ?? false),
                          activeColor: const Color(0xFF1e3c72),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Section Ancienneté
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⏰ Ancienneté (années)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1e3c72))),
                        const SizedBox(height: 10),
                        
                        _buildSlider('Contrôleur Stagiaire', _ancienneteStage, (value) => setState(() => _ancienneteStage = value)),
                        _buildSlider('Contrôleur Aire de Trafic', _ancienneteControleur, (value) => setState(() => _ancienneteControleur = value)),
                        _buildSlider('Assistant', _ancienneteAssistant, (value) => setState(() => _ancienneteAssistant = value)),
                        _buildSlider('Supervisor', _ancienneteSupervisor, (value) => setState(() => _ancienneteSupervisor = value)),
                        _buildSlider('Contrôleur Instructeur', _ancienneteInstructeur, (value) => setState(() => _ancienneteInstructeur = value)),
                        _buildSlider('Responsable Cellule', _ancienneteResponsable, (value) => setState(() => _ancienneteResponsable = value)),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Résultats
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🎯 Fonctions Éligibles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1e3c72))),
                        const SizedBox(height: 10),
                        
                        if (fonctionsEligibles.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning, color: Colors.orange),
                                const SizedBox(width: 10),
                                Expanded(child: Text('Aucune fonction éligible avec les conditions actuelles', style: TextStyle(color: Colors.orange[800]))),
                              ],
                            ),
                          )
                        else
                          ...fonctionsEligibles.map((fonction) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(fonction.displayName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
                                      Text(AgentConditionsLogic.getConditionsDescription(fonction), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(String title, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title: $value ans', style: const TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          activeColor: const Color(0xFF1e3c72),
          onChanged: (newValue) => onChanged(newValue.round()),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
