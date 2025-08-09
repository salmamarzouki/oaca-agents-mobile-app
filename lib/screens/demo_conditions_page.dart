import 'package:flutter/material.dart';
import '../models/agent_conditions.dart';
import '../widgets/agent_fonction_display.dart';

class DemoConditionsPage extends StatefulWidget {
  const DemoConditionsPage({super.key});

  @override
  State<DemoConditionsPage> createState() => _DemoConditionsPageState();
}

class _DemoConditionsPageState extends State<DemoConditionsPage> {
  AgentConditions _conditions = AgentConditions();

  @override
  Widget build(BuildContext context) {
    final eligibleFunctions = AgentConditionsLogic.getFonctionsEligibles(_conditions);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎯 Démo Conditions Agent',
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.science,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Test des Conditions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Cochez les conditions pour voir les fonctions éligibles',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Conditions
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📚 Formations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1e3c72),
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        CheckboxListTile(
                          title: const Text('Formation Ab-Initio'),
                          value: _conditions.formationAbInitio,
                          onChanged: (value) {
                            setState(() {
                              _conditions = _conditions.copyWith(formationAbInitio: value);
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Formation Gestion Équipe'),
                          value: _conditions.formationGestionEquipe,
                          onChanged: (value) {
                            setState(() {
                              _conditions = _conditions.copyWith(formationGestionEquipe: value);
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Formation des Formateurs'),
                          value: _conditions.formationDesFormateurs,
                          onChanged: (value) {
                            setState(() {
                              _conditions = _conditions.copyWith(formationDesFormateurs: value);
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Formation Leadership'),
                          value: _conditions.formationLeadership,
                          onChanged: (value) {
                            setState(() {
                              _conditions = _conditions.copyWith(formationLeadership: value);
                            });
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        const Text(
                          '📝 Examens & Certificats',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1e3c72),
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        CheckboxListTile(
                          title: const Text('Examen Sécurité d\'Exploitation'),
                          value: _conditions.examenSecuriteExploitation,
                          onChanged: (value) {
                            setState(() {
                              _conditions = _conditions.copyWith(examenSecuriteExploitation: value);
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Certificat Médical'),
                          value: _conditions.certificatMedical,
                          onChanged: (value) {
                            setState(() {
                              _conditions = _conditions.copyWith(certificatMedical: value);
                            });
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        const Text(
                          '⏰ Ancienneté (années)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1e3c72),
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        _buildAncienneteSlider('Contrôleur Stagiaire', _conditions.ancienneteControleurStage, (value) {
                          setState(() {
                            _conditions = _conditions.copyWith(ancienneteControleurStage: value);
                          });
                        }),
                        _buildAncienneteSlider('Contrôleur Aire de Trafic', _conditions.ancienneteControleurAireTrafic, (value) {
                          setState(() {
                            _conditions = _conditions.copyWith(ancienneteControleurAireTrafic: value);
                          });
                        }),
                        _buildAncienneteSlider('Assistant', _conditions.ancienneteAssistant, (value) {
                          setState(() {
                            _conditions = _conditions.copyWith(ancienneteAssistant: value);
                          });
                        }),
                        _buildAncienneteSlider('Supervisor', _conditions.ancienneteSupervisor, (value) {
                          setState(() {
                            _conditions = _conditions.copyWith(ancienneteSupervisor: value);
                          });
                        }),
                        _buildAncienneteSlider('Contrôleur Instructeur', _conditions.ancienneteControleurInstructeur, (value) {
                          setState(() {
                            _conditions = _conditions.copyWith(ancienneteControleurInstructeur: value);
                          });
                        }),
                        _buildAncienneteSlider('Responsable Cellule', _conditions.ancienneteResponsableCellule, (value) {
                          setState(() {
                            _conditions = _conditions.copyWith(ancienneteResponsableCellule: value);
                          });
                        }),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Résultats
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🎯 Résultats',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1e3c72),
                          ),
                        ),
                        const SizedBox(height: 15),
                        
                        AgentConditionsDisplay(conditions: _conditions),
                        const SizedBox(height: 15),
                        AgentFonctionDisplay(conditions: _conditions),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAncienneteSlider(String title, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title: $value ans'),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 15,
          divisions: 15,
          onChanged: (newValue) => onChanged(newValue.round()),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
