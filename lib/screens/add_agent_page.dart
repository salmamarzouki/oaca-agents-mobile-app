import 'package:flutter/material.dart';
import '../models/agent_conditions.dart';
import '../widgets/agent_conditions_widget.dart';

class AddAgentPage extends StatefulWidget {
  const AddAgentPage({super.key});

  @override
  AddAgentPageState createState() => AddAgentPageState();
}

class AddAgentPageState extends State<AddAgentPage> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _ageController = TextEditingController();
  final _affectationController = TextEditingController();
  final _formationController = TextEditingController();
  final _fonctionTechniqueController = TextEditingController();
  final _dateFonctionTechniqueController = TextEditingController();
  final _affectationUsineController = TextEditingController();
  final _dateFonctionUsineController = TextEditingController();
  final _fonctionAdministrativeController = TextEditingController();
  final _dateFonctionAdministrativeController = TextEditingController();
  final _periodeController = TextEditingController();

  bool _isLoading = false;

  // Variables pour les conditions et fonctions
  AgentConditions _conditions = AgentConditions();
  FonctionAgent? _selectedFonction;

  @override
  void dispose() {
    _matriculeController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _dateNaissanceController.dispose();
    _ageController.dispose();
    _affectationController.dispose();
    _formationController.dispose();
    _fonctionTechniqueController.dispose();
    _dateFonctionTechniqueController.dispose();
    _affectationUsineController.dispose();
    _dateFonctionUsineController.dispose();
    _fonctionAdministrativeController.dispose();
    _dateFonctionAdministrativeController.dispose();
    _periodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAgent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Ajout dans le provider (décommentez la ligne suivante si le provider est prêt)
      // await Provider.of<AgentProvider>(context, listen: false).addAgent(
      //   Agent(
      //     id: DateTime.now().millisecondsSinceEpoch, // ID temporaire
      //     matricule: _matriculeController.text.trim(),
      //     nom: _nomController.text.trim(),
      //     prenom: _prenomController.text.trim().isEmpty ? null : _prenomController.text.trim(),
      //     nomComplet: '${_nomController.text.trim()} ${_prenomController.text.trim()}'.trim(),
      //     fullName: '${_nomController.text.trim()} ${_prenomController.text.trim()}'.trim(),
      //     affectation: _affectationController.text.trim().isEmpty ? null : _affectationController.text.trim(),
      //     periode: _periodeController.text.trim().isEmpty ? null : _periodeController.text.trim(),
      //     sourceFile: 'Ajout manuel',
      //     status: 'Actif',
      //     createdAt: DateTime.now(),
      //     updatedAt: DateTime.now(),
      //   ),
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Agent ajouté avec succès'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur lors de l\'ajout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '➕ Ajouter un agent',
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 60,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Nouveau Agent',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Remplissez les informations ci-dessous',
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
                  
                  // Formulaire
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Matricule
                          TextFormField(
                            controller: _matriculeController,
                            decoration: InputDecoration(
                              labelText: 'Matricule *',
                              prefixIcon: const Icon(Icons.badge),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Le matricule est obligatoire';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 15),
                          
                          // Nom
                          TextFormField(
                            controller: _nomController,
                            decoration: InputDecoration(
                              labelText: 'Nom *',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Le nom est obligatoire';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 15),
                          
                          // Prénom
                          TextFormField(
                            controller: _prenomController,
                            decoration: InputDecoration(
                              labelText: 'Prénom',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Date de naissance
                          TextFormField(
                            controller: _dateNaissanceController,
                            decoration: InputDecoration(
                              labelText: 'Date de naissance (YYYY-MM-DD)',
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Ex: 1990-05-15',
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Âge
                          TextFormField(
                            controller: _ageController,
                            decoration: InputDecoration(
                              labelText: 'Âge',
                              prefixIcon: const Icon(Icons.cake),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Ex: 34',
                            ),
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 15),

                          // Affectation (Aéroport)
                          TextFormField(
                            controller: _affectationController,
                            decoration: InputDecoration(
                              labelText: 'Affectation',
                              prefixIcon: const Icon(Icons.flight_takeoff),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Ex: AITC, AIGK, AIDZ...',
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Formation
                          TextFormField(
                            controller: _formationController,
                            decoration: InputDecoration(
                              labelText: 'Formation',
                              prefixIcon: const Icon(Icons.school),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Ex: Contrôle Aérien, Sécurité...',
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Fonction technique actuelle
                          TextFormField(
                            controller: _fonctionTechniqueController,
                            decoration: InputDecoration(
                              labelText: 'Fonction technique actuelle',
                              prefixIcon: const Icon(Icons.engineering),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Date fonction technique actuelle
                          TextFormField(
                            controller: _dateFonctionTechniqueController,
                            decoration: InputDecoration(
                              labelText: 'Date fonction technique actuelle (YYYY-MM-DD)',
                              prefixIcon: const Icon(Icons.date_range),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Affectation usine
                          TextFormField(
                            controller: _affectationUsineController,
                            decoration: InputDecoration(
                              labelText: 'Affectation usine',
                              prefixIcon: const Icon(Icons.factory),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Date affectation usine
                          TextFormField(
                            controller: _dateFonctionUsineController,
                            decoration: InputDecoration(
                              labelText: 'Date affectation usine (YYYY-MM-DD)',
                              prefixIcon: const Icon(Icons.date_range),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Fonction administrative
                          TextFormField(
                            controller: _fonctionAdministrativeController,
                            decoration: InputDecoration(
                              labelText: 'Fonction administrative',
                              prefixIcon: const Icon(Icons.admin_panel_settings),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Date fonction administrative
                          TextFormField(
                            controller: _dateFonctionAdministrativeController,
                            decoration: InputDecoration(
                              labelText: 'Date fonction administrative (YYYY-MM-DD)',
                              prefixIcon: const Icon(Icons.date_range),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section Conditions et Fonctions
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
                            '🎯 Conditions et Fonctions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1e3c72),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Cochez les conditions remplies par l\'agent pour déterminer les fonctions éligibles',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),

                          AgentConditionsWidget(
                            conditions: _conditions,
                            onConditionsChanged: (newConditions) {
                              setState(() {
                                _conditions = newConditions;
                              });
                            },
                            onFonctionSelected: (fonction) {
                              setState(() {
                                _selectedFonction = fonction;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Boutons
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isLoading ? null : () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Annuler',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 15),
                              
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _saveAgent,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Ajouter',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Note
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Les champs marqués d\'un * sont obligatoires',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
