import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAgentSimple extends StatefulWidget {
  const AddAgentSimple({super.key});

  @override
  State<AddAgentSimple> createState() => _AddAgentSimpleState();
}

class _AddAgentSimpleState extends State<AddAgentSimple> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _fonctionController = TextEditingController();
  final _affectationController = TextEditingController();
  final _ageController = TextEditingController();
  final _formationController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _matriculeController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _fonctionController.dispose();
    _affectationController.dispose();
    _ageController.dispose();
    _formationController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _addAgent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final agentData = {
        'matricule': _matriculeController.text,
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'fonction': _fonctionController.text,
        'affectation': _affectationController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'formation': _formationController.text,
        'telephone': _telephoneController.text,
        'email': _emailController.text,
      };

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/mobile-api/agents/create/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(agentData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agent ajouté avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Retourner true pour indiquer le succès
      } else {
        throw Exception('Erreur lors de l\'ajout: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
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
          'Ajouter un Agent',
          style: TextStyle(
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
                child: const Column(
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nouveau Agent',
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
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          
                          const SizedBox(height: 40),
                          // Boutons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    side: const BorderSide(color: Color(0xFF1565C0)),
                                  ),
                                  child: const Text(
                                    'Annuler',
                                    style: TextStyle(color: Color(0xFF1565C0)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _addAgent,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1565C0),
                                    padding: const EdgeInsets.symmetric(vertical: 15),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                            ],
                          ),
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
      padding: const EdgeInsets.only(bottom: 15),
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
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est requis';
              }
              return null;
            }
          : null,
    );
  }
}
