import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/agent.dart';

class EditAgentScreen extends StatefulWidget {
  final Agent agent;

  const EditAgentScreen({
    super.key,
    required this.agent,
  });

  @override
  State<EditAgentScreen> createState() => _EditAgentScreenState();
}

class _EditAgentScreenState extends State<EditAgentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Controllers pour les champs
  late TextEditingController _matriculeController;
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _ageController;
  late TextEditingController _fonctionController;
  late TextEditingController _affectationController;
  late TextEditingController _formationController;
  late TextEditingController _periodeController;
  late TextEditingController _statusController;
  late TextEditingController _fonctionTechniqueController;
  late TextEditingController _dateFonctionTechniqueController;
  late TextEditingController _affectationUniteController;
  late TextEditingController _dateAffectationUniteController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _matriculeController = TextEditingController(text: widget.agent.matricule);
    _nomController = TextEditingController(text: widget.agent.nom);
    _prenomController = TextEditingController(text: widget.agent.prenom ?? '');
    _ageController = TextEditingController(text: widget.agent.age?.toString() ?? '');
    _fonctionController = TextEditingController(text: widget.agent.fonctionActuelle ?? '');
    _affectationController = TextEditingController(text: widget.agent.affectation ?? '');
    _formationController = TextEditingController(text: widget.agent.formation ?? '');
    _periodeController = TextEditingController(text: widget.agent.periode ?? '');
    _statusController = TextEditingController(text: widget.agent.status ?? '');
    _fonctionTechniqueController = TextEditingController(text: widget.agent.fonctionTechniqueActuelle ?? '');
    _dateFonctionTechniqueController = TextEditingController(text: widget.agent.dateFonctionTechniqueActuelle ?? '');
    _affectationUniteController = TextEditingController(text: widget.agent.affectationUnite ?? '');
    _dateAffectationUniteController = TextEditingController(text: widget.agent.dateAffectationUnite ?? '');
  }

  @override
  void dispose() {
    _matriculeController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _ageController.dispose();
    _fonctionController.dispose();
    _affectationController.dispose();
    _formationController.dispose();
    _periodeController.dispose();
    _statusController.dispose();
    _fonctionTechniqueController.dispose();
    _dateFonctionTechniqueController.dispose();
    _affectationUniteController.dispose();
    _dateAffectationUniteController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF0D47A1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            'Modifier Agent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // Pour équilibrer le bouton retour
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Modifiez les informations de ${widget.agent.fullName}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Formulaire
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Informations Personnelles'),
                          _buildTextField(
                            controller: _matriculeController,
                            label: 'Matricule',
                            icon: Icons.badge,
                            required: true,
                            enabled: false, // Matricule non modifiable
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _nomController,
                            label: 'Nom',
                            icon: Icons.person,
                            required: true,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _prenomController,
                            label: 'Prénom',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _ageController,
                            label: 'Âge',
                            icon: Icons.cake,
                            keyboardType: TextInputType.number,
                          ),
                          
                          const SizedBox(height: 30),
                          _buildSectionTitle('Informations Professionnelles'),
                          _buildTextField(
                            controller: _fonctionController,
                            label: 'Fonction Actuelle',
                            icon: Icons.work,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _affectationController,
                            label: 'Affectation',
                            icon: Icons.location_on,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _fonctionTechniqueController,
                            label: 'Fonction Technique Actuelle',
                            icon: Icons.engineering,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _dateFonctionTechniqueController,
                            label: 'Date Fonction Technique Actuelle',
                            icon: Icons.calendar_today,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _affectationUniteController,
                            label: 'Affectation Unité',
                            icon: Icons.business,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _dateAffectationUniteController,
                            label: 'Date Affectation Unité',
                            icon: Icons.calendar_today,
                          ),
                          
                          const SizedBox(height: 30),
                          _buildSectionTitle('Formation et Statut'),
                          _buildTextField(
                            controller: _formationController,
                            label: 'Formation',
                            icon: Icons.school,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _periodeController,
                            label: 'Période',
                            icon: Icons.date_range,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _statusController,
                            label: 'Statut',
                            icon: Icons.info,
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Boutons d'action
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: const BorderSide(color: Color(0xFF1565C0)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Annuler',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1565C0),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _saveAgent,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1565C0),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text(
                                          'Enregistrer',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1565C0),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        prefixIcon: Icon(icon, color: enabled ? const Color(0xFF1565C0) : Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        filled: true,
        fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label est obligatoire';
              }
              return null;
            }
          : null,
    );
  }

  Future<void> _saveAgent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/mobile-api/agents/${widget.agent.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'matricule': _matriculeController.text.trim(),
          'nom': _nomController.text.trim(),
          'prenom': _prenomController.text.trim().isEmpty ? null : _prenomController.text.trim(),
          'age': _ageController.text.trim().isEmpty ? null : int.tryParse(_ageController.text.trim()),
          'fonction_actuelle': _fonctionController.text.trim().isEmpty ? null : _fonctionController.text.trim(),
          'affectation': _affectationController.text.trim().isEmpty ? null : _affectationController.text.trim(),
          'formation': _formationController.text.trim().isEmpty ? null : _formationController.text.trim(),
          'periode': _periodeController.text.trim().isEmpty ? null : _periodeController.text.trim(),
          'status': _statusController.text.trim().isEmpty ? null : _statusController.text.trim(),
          'fonction_technique_actuelle': _fonctionTechniqueController.text.trim().isEmpty ? null : _fonctionTechniqueController.text.trim(),
          'date_fonction_technique_actuelle': _dateFonctionTechniqueController.text.trim().isEmpty ? null : _dateFonctionTechniqueController.text.trim(),
          'affectation_unite': _affectationUniteController.text.trim().isEmpty ? null : _affectationUniteController.text.trim(),
          'date_affectation_unite': _dateAffectationUniteController.text.trim().isEmpty ? null : _dateAffectationUniteController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Agent modifié avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Retourner true pour indiquer que l'agent a été modifié
        }
      } else {
        throw Exception('Erreur lors de la modification: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
