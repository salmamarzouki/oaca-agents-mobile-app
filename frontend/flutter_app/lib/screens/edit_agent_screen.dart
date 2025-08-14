import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditAgentScreen extends StatefulWidget {
  final Map<String, dynamic> agent;

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
  late TextEditingController _dateNaissanceController;
  late TextEditingController _ageController;
  late TextEditingController _fonctionController;
  late TextEditingController _affectationController;
  late TextEditingController _uniteController;
  late TextEditingController _serviceController;
  late TextEditingController _gradeController;
  late TextEditingController _telephoneController;
  late TextEditingController _emailController;
  late TextEditingController _adresseController;
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
    _matriculeController = TextEditingController(text: widget.agent['matricule']?.toString() ?? '');
    _nomController = TextEditingController(text: widget.agent['nom']?.toString() ?? '');
    _prenomController = TextEditingController(text: widget.agent['prenom']?.toString() ?? '');
    _dateNaissanceController = TextEditingController(text: widget.agent['date_naissance']?.toString() ?? '');
    _ageController = TextEditingController(text: widget.agent['age']?.toString() ?? '');
    _fonctionController = TextEditingController(text: widget.agent['fonction']?.toString() ?? '');
    _affectationController = TextEditingController(text: widget.agent['affectation']?.toString() ?? '');
    _uniteController = TextEditingController(text: widget.agent['unite']?.toString() ?? '');
    _serviceController = TextEditingController(text: widget.agent['service']?.toString() ?? '');
    _gradeController = TextEditingController(text: widget.agent['grade']?.toString() ?? '');
    _telephoneController = TextEditingController(text: widget.agent['telephone']?.toString() ?? '');
    _emailController = TextEditingController(text: widget.agent['email']?.toString() ?? '');
    _adresseController = TextEditingController(text: widget.agent['adresse']?.toString() ?? '');
    _formationController = TextEditingController(text: widget.agent['formation']?.toString() ?? '');
    _periodeController = TextEditingController(text: widget.agent['periode']?.toString() ?? '');
    _statusController = TextEditingController(text: widget.agent['status']?.toString() ?? '');
    _fonctionTechniqueController = TextEditingController(text: widget.agent['fonction_technique_actuelle']?.toString() ?? '');
    _dateFonctionTechniqueController = TextEditingController(text: widget.agent['date_fonction_technique_actuelle']?.toString() ?? '');
    _affectationUniteController = TextEditingController(text: widget.agent['affectation_unite']?.toString() ?? '');
    _dateAffectationUniteController = TextEditingController(text: widget.agent['date_affectation_unite']?.toString() ?? '');
  }

  @override
  void dispose() {
    _matriculeController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _dateNaissanceController.dispose();
    _ageController.dispose();
    _fonctionController.dispose();
    _affectationController.dispose();
    _uniteController.dispose();
    _serviceController.dispose();
    _gradeController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
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
      appBar: AppBar(
        title: Text(
          'Modifier Agent',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF42A5F5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // En-tête
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.edit,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Modifier Agent',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Formulaire
              Expanded(
                child: Container(
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
                            required: true,
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
                            label: 'Fonction',
                            icon: Icons.work,
                            required: true,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _affectationController,
                            label: 'Affectation',
                            icon: Icons.location_on,
                            required: true,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _formationController,
                            label: 'Formation',
                            icon: Icons.school,
                          ),

                          const SizedBox(height: 30),
                          _buildSectionTitle('Contact'),
                          _buildTextField(
                            controller: _telephoneController,
                            label: 'Téléphone',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 40),

                          // Bouton de sauvegarde
                          SizedBox(
                            width: double.infinity,
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
                                      'Enregistrer les modifications',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
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
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        labelStyle: TextStyle(
          color: enabled ? const Color(0xFF1565C0) : Colors.grey,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: enabled ? const Color(0xFF1565C0) : Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[100],
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
        Uri.parse('http://127.0.0.1:8000/mobile-api/agents/${widget.agent['id']}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'matricule': _matriculeController.text.trim(),
          'nom': _nomController.text.trim(),
          'prenom': _prenomController.text.trim().isEmpty ? null : _prenomController.text.trim(),
          'age': _ageController.text.trim().isEmpty ? null : int.tryParse(_ageController.text.trim()),
          'fonction': _fonctionController.text.trim().isEmpty ? null : _fonctionController.text.trim(),
          'affectation': _affectationController.text.trim().isEmpty ? null : _affectationController.text.trim(),
          'formation': _formationController.text.trim().isEmpty ? null : _formationController.text.trim(),
          'telephone': _telephoneController.text.trim().isEmpty ? null : _telephoneController.text.trim(),
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
