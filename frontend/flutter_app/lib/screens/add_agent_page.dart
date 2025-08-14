import 'package:flutter/material.dart';
import '../models/agent_conditions.dart';
import '../widgets/agent_conditions_widget.dart';

class AddAgentPage extends StatefulWidget {
  @override
  AddAgentPageState createState() => AddAgentPageState();
}

class AddAgentPageState extends State<AddAgentPage> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _affectationController = TextEditingController();
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
    _affectationController.dispose();
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
        SnackBar(
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
        title: Text(
          '➕ Ajouter un agent',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF1e3c72),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
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
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
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
                  
                  SizedBox(height: 20),
                  
                  // Formulaire
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Matricule
                          TextFormField(
                            controller: _matriculeController,
                            decoration: InputDecoration(
                              labelText: 'Matricule *',
                              prefixIcon: Icon(Icons.badge),
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
                          
                          SizedBox(height: 15),
                          
                          // Nom
                          TextFormField(
                            controller: _nomController,
                            decoration: InputDecoration(
                              labelText: 'Nom *',
                              prefixIcon: Icon(Icons.person),
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
                          
                          SizedBox(height: 15),
                          
                          // Prénom
                          TextFormField(
                            controller: _prenomController,
                            decoration: InputDecoration(
                              labelText: 'Prénom',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 15),
                          
                          // Affectation (Aéroport)
                          TextFormField(
                            controller: _affectationController,
                            decoration: InputDecoration(
                              labelText: 'Aéroport d\'affectation',
                              prefixIcon: Icon(Icons.flight_takeoff),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Ex: AITC, AIGK, AIDZ...',
                            ),
                          ),
                          
                          SizedBox(height: 15),
                          
                          // Période
                          TextFormField(
                            controller: _periodeController,
                            decoration: InputDecoration(
                              labelText: 'Période',
                              prefixIcon: Icon(Icons.schedule),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Ex: 2024, Permanent...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Section Conditions et Fonctions
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🎯 Conditions et Fonctions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1e3c72),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Cochez les conditions remplies par l\'agent pour déterminer les fonctions éligibles',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 20),

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

                  SizedBox(height: 30),

                  // Boutons
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
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
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Annuler',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              
                              SizedBox(width: 15),
                              
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _saveAgent,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
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
                  
                  SizedBox(height: 20),
                  
                  // Note
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
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
