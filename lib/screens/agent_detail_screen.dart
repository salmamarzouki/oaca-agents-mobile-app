import 'package:flutter/material.dart';
import '../models/agent.dart';
import '../models/agent_conditions.dart';
import '../widgets/agent_fonction_display.dart';

class AgentDetailScreen extends StatefulWidget {
  final Agent agent;

  const AgentDetailScreen({super.key, required this.agent});

  @override
  State<AgentDetailScreen> createState() => _AgentDetailScreenState();
}

class _AgentDetailScreenState extends State<AgentDetailScreen> {
  // Variables pour les conditions interactives
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

  // Contrôleurs pour les champs modifiables
  late TextEditingController _fonctionTechniqueController;
  late TextEditingController _dateFonctionTechniqueController;
  late TextEditingController _affectationUsineController;
  late TextEditingController _dateAffectationUsineController;
  late TextEditingController _fonctionAdministrativeController;
  late TextEditingController _dateFonctionAdministrativeController;
  late TextEditingController _periodeController;
  late TextEditingController _formationAutreController;

  // Variables pour les formations (cases à cocher) - renommées pour éviter les conflits
  bool _selectedFormationAbInitio = false;
  bool _selectedFormationControleurStage = false;
  bool _selectedFormationControleurAireTrafic = false;
  bool _selectedFormationFormateurs = false;
  bool _selectedFormationLeadership = false;
  bool _selectedFormationGestionEquipe = false;
  bool _selectedFormationAutre = false;

  @override
  void initState() {
    super.initState();
    _initializeConditionsFromAgent();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialiser les contrôleurs avec les valeurs actuelles
    _fonctionTechniqueController = TextEditingController(text: widget.agent.fonctionTechniqueActuelle ?? '');
    _dateFonctionTechniqueController = TextEditingController(text: widget.agent.dateFonctionTechniqueActuelle ?? '');
    _affectationUsineController = TextEditingController(text: widget.agent.affectationUnite ?? '');
    _dateAffectationUsineController = TextEditingController(text: widget.agent.dateAffectationUnite ?? '');
    _fonctionAdministrativeController = TextEditingController(text: widget.agent.fonctionAdministration ?? '');
    _dateFonctionAdministrativeController = TextEditingController(text: widget.agent.dateFonctionAdministration ?? '');
    _periodeController = TextEditingController(text: widget.agent.periode ?? '');
    _formationAutreController = TextEditingController(text: widget.agent.formationAutre ?? '');

    // Initialiser les cases à cocher des formations basées sur les données existantes
    _initializeFormationCheckboxes();
  }

  void _initializeFormationCheckboxes() {
    if (widget.agent.formation != null) {
      String formation = widget.agent.formation!.toLowerCase();
      _selectedFormationAbInitio = formation.contains('ab initio');
      _selectedFormationControleurStage = formation.contains('contrôleur') && formation.contains('stage');
      _selectedFormationControleurAireTrafic = formation.contains('contrôleur') && formation.contains('trafic');
      _selectedFormationFormateurs = formation.contains('formateur');
      _selectedFormationLeadership = formation.contains('leadership');
      _selectedFormationGestionEquipe = formation.contains('gestion') && formation.contains('équipe');
      _selectedFormationAutre = formation.contains('autre') || (widget.agent.formationAutre != null && widget.agent.formationAutre!.isNotEmpty);
    }
  }

  String _getFormationInitialeDisplay() {
    // DEBUG: Afficher les valeurs pour déboguer
    print('🔍 DEBUG Formation - Agent ${widget.agent.matricule}:');
    print('  formation: "${widget.agent.formation}"');
    print('  fonctionGrade: "${widget.agent.fonctionGrade}"');
    print('  formationAutre: "${widget.agent.formationAutre}"');

    // Afficher la formation exactement comme elle est dans les données Excel
    if (widget.agent.formation?.isNotEmpty == true) {
      print('  ✅ Retourne formation: "${widget.agent.formation}"');

      // Séparer les formations multiples par " | " et les afficher sur plusieurs lignes
      String formations = widget.agent.formation!;
      if (formations.contains(' | ')) {
        List<String> formationsList = formations.split(' | ');
        return formationsList.map((f) => '• ${f.trim()}').join('\n');
      }

      return widget.agent.formation!;
    }

    // Si pas de formation, vérifier d'autres champs
    if (widget.agent.fonctionGrade?.isNotEmpty == true) {
      print('  ✅ Retourne fonctionGrade: "${widget.agent.fonctionGrade}"');
      return widget.agent.fonctionGrade!;
    }

    print('  ❌ Aucune formation trouvée - retourne "Non spécifiée"');
    return 'Non spécifiée';
  }

  @override
  void dispose() {
    // Nettoyer les contrôleurs
    _fonctionTechniqueController.dispose();
    _dateFonctionTechniqueController.dispose();
    _affectationUsineController.dispose();
    _dateAffectationUsineController.dispose();
    _fonctionAdministrativeController.dispose();
    _dateFonctionAdministrativeController.dispose();
    _periodeController.dispose();
    _formationAutreController.dispose();
    super.dispose();
  }

  void _initializeConditionsFromAgent() {
    // Initialiser les conditions basées sur les données existantes de l'agent
    if (widget.agent.formation != null) {
      String formation = widget.agent.formation!.toLowerCase();
      _formationAbInitio = formation.contains('ab initio') || formation.contains('ab_initio');
      _formationGestionEquipe = formation.contains('gestion') && formation.contains('équipe');
      _formationFormateurs = formation.contains('formateur');
      _formationLeadership = formation.contains('leadership');
    }

    // Supposer quelques valeurs par défaut basées sur la fonction actuelle
    if (widget.agent.fonctionActuelle != null) {
      String fonction = widget.agent.fonctionActuelle!.toLowerCase();
      if (fonction.contains('contrôleur') || fonction.contains('controleur')) {
        _ancienneteControleur = 3; // Valeur d'exemple
        _examenSecurite = true;
      }
      if (fonction.contains('assistant')) {
        _ancienneteAssistant = 2;
      }
      if (fonction.contains('supervisor')) {
        _ancienneteSupervisor = 1;
      }
    }

    _certificatMedical = true; // Supposé pour les agents actifs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agent ${widget.agent.matricule}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            widget.agent.fullName.isNotEmpty
                                ? widget.agent.fullName[0].toUpperCase()
                                : widget.agent.matricule[0],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.agent.fullName,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Matricule: ${widget.agent.matricule}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // En-tête avec informations principales
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1e3c72).withOpacity(0.1),
                      const Color(0xFF2a5298).withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom complet en gras
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1e3c72).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF1e3c72),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            widget.agent.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1e3c72),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Informations principales en ligne
                    Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      children: [
                        // Matricule
                        _buildInfoChip(Icons.badge, 'Matricule', widget.agent.matricule),

                        // Âge
                        if (widget.agent.age != null)
                          _buildInfoChip(Icons.cake, 'Âge', '${widget.agent.age} ans'),

                        // Affectation
                        if (widget.agent.affectation != null && widget.agent.affectation!.isNotEmpty)
                          _buildInfoChip(Icons.flight_takeoff, 'Affectation', widget.agent.affectation!),

                        // Formation - seulement si elle existe
                        if (widget.agent.formation != null && widget.agent.formation!.isNotEmpty)
                          _buildFormationChip(Icons.school, 'Formation', widget.agent.formation!),

                        // Fonction actuelle
                        if (widget.agent.fonctionActuelle != null && widget.agent.fonctionActuelle!.isNotEmpty)
                          _buildInfoChip(Icons.work, 'Fonction', widget.agent.fonctionActuelle!),

                        // Fonction technique
                        if (widget.agent.fonctionTechniqueActuelle != null && widget.agent.fonctionTechniqueActuelle!.isNotEmpty)
                          _buildInfoChip(Icons.engineering, 'Fonction technique', widget.agent.fonctionTechniqueActuelle!),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Informations Personnelles Détaillées
            _buildSectionCard(
              context,
              '👤 Informations Personnelles Détaillées',
              [
                if (widget.agent.nom.isNotEmpty)
                  _buildDetailRow(context, 'Nom', widget.agent.nom, Icons.person_outline),
                if (widget.agent.prenom != null && widget.agent.prenom!.isNotEmpty)
                  _buildDetailRow(context, 'Prénom', widget.agent.prenom!, Icons.person_outline),
                if (widget.agent.dateNaissance != null && widget.agent.dateNaissance!.isNotEmpty)
                  _buildDetailRow(context, 'Date de naissance', _formatDate(widget.agent.dateNaissance!), Icons.cake),
                _buildDetailRow(context, 'Fichier source', widget.agent.sourceFile, Icons.source),
                if (widget.agent.status != null && widget.agent.status!.isNotEmpty)
                  _buildDetailRow(context, 'Statut', widget.agent.status!, Icons.info),
              ],
            ),

            const SizedBox(height: 16),

            // Affectations
            _buildSectionCard(
              context,
              '🏢 Affectations',
              [
                if (widget.agent.affectation != null && widget.agent.affectation!.isNotEmpty)
                  _buildDetailRow(context, 'Affectation principale', widget.agent.affectation!, Icons.work),
                if (widget.agent.affectationUnite != null && widget.agent.affectationUnite!.isNotEmpty)
                  _buildDetailRow(context, 'Affectation unité', widget.agent.affectationUnite!, Icons.business),
                if (widget.agent.dateAffectationUnite != null && widget.agent.dateAffectationUnite!.isNotEmpty)
                  _buildDetailRow(context, 'Date affectation unité', _formatDate(widget.agent.dateAffectationUnite!), Icons.date_range),
              ],
            ),

            const SizedBox(height: 16),

            // Fonctions
            _buildSectionCard(
              context,
              '💼 Fonctions',
              [
                if (widget.agent.fonctionActuelle != null && widget.agent.fonctionActuelle!.isNotEmpty)
                  _buildDetailRow(context, 'Fonction actuelle', widget.agent.fonctionActuelle!, Icons.work_outline),
                if (widget.agent.dateFonctionActuelle != null && widget.agent.dateFonctionActuelle!.isNotEmpty)
                  _buildDetailRow(context, 'Date fonction actuelle', _formatDate(widget.agent.dateFonctionActuelle!), Icons.date_range),
                if (widget.agent.fonctionTechniqueActuelle != null && widget.agent.fonctionTechniqueActuelle!.isNotEmpty)
                  _buildDetailRow(context, 'Fonction technique actuelle', widget.agent.fonctionTechniqueActuelle!, Icons.engineering),
                if (widget.agent.dateFonctionTechniqueActuelle != null && widget.agent.dateFonctionTechniqueActuelle!.isNotEmpty)
                  _buildDetailRow(context, 'Date fonction technique', _formatDate(widget.agent.dateFonctionTechniqueActuelle!), Icons.date_range),
                if (widget.agent.fonctionAdministration != null && widget.agent.fonctionAdministration!.isNotEmpty)
                  _buildDetailRow(context, 'Fonction administration', widget.agent.fonctionAdministration!, Icons.admin_panel_settings),
                if (widget.agent.dateFonctionAdministration != null && widget.agent.dateFonctionAdministration!.isNotEmpty)
                  _buildDetailRow(context, 'Date fonction administration', _formatDate(widget.agent.dateFonctionAdministration!), Icons.date_range),
                if (widget.agent.fonctionGrade != null && widget.agent.fonctionGrade!.isNotEmpty)
                  _buildDetailRow(context, 'Fonction/Grade', widget.agent.fonctionGrade!, Icons.military_tech),
              ],
            ),

            const SizedBox(height: 16),

            // Fonctions
            _buildSectionCard(
              context,
              '🎯 Fonctions',
              [
                // Champs modifiables pour les fonctions
                _buildEditableField(
                  context,
                  'Fonction technique actuelle',
                  _fonctionTechniqueController,
                  Icons.engineering
                ),
                _buildEditableField(
                  context,
                  'Date fonction technique actuelle (YYYY-MM-DD)',
                  _dateFonctionTechniqueController,
                  Icons.date_range
                ),
                _buildEditableField(
                  context,
                  'Affectation usine',
                  _affectationUsineController,
                  Icons.factory
                ),
                _buildEditableField(
                  context,
                  'Date affectation usine (YYYY-MM-DD)',
                  _dateAffectationUsineController,
                  Icons.date_range
                ),
                _buildEditableField(
                  context,
                  'Fonction administrative',
                  _fonctionAdministrativeController,
                  Icons.admin_panel_settings
                ),
                _buildEditableField(
                  context,
                  'Date fonction administrative (YYYY-MM-DD)',
                  _dateFonctionAdministrativeController,
                  Icons.date_range
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Formation
            _buildFormationSection(context),

            const SizedBox(height: 16),

            // Conditions et Fonctions Éligibles
            _buildConditionsSection(context),

            const SizedBox(height: 16),

            // Informations Système
            _buildSectionCard(
              context,
              '📋 Informations Système',
              [
                if (widget.agent.status != null && widget.agent.status!.isNotEmpty)
                  _buildDetailRow(context, 'Status', widget.agent.status!, Icons.info, statusColor: _getStatusColor(widget.agent.status!)),
                _buildDetailRow(context, 'Source fichier', widget.agent.sourceFile, Icons.file_present),
                _buildDetailRow(context, 'Créé le', _formatDateTime(widget.agent.createdAt), Icons.access_time),
                _buildDetailRow(context, 'Modifié le', _formatDateTime(widget.agent.updatedAt), Icons.update),
              ],
            ),

            const SizedBox(height: 24),

            // Bouton Sauvegarder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1e3c72),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sauvegarder les modifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    try {
      // Construire la chaîne de formation à partir des cases cochées
      List<String> formations = [];
      if (_selectedFormationAbInitio) formations.add('Formation Ab Initio');
      if (_selectedFormationControleurStage) formations.add('Formation Contrôleur Stage');
      if (_selectedFormationControleurAireTrafic) formations.add('Formation Contrôleur Aire de Trafic');
      if (_selectedFormationFormateurs) formations.add('Formation Formateurs');
      if (_selectedFormationLeadership) formations.add('Formation Leadership');
      if (_selectedFormationGestionEquipe) formations.add('Formation Gestion Équipe');
      if (_selectedFormationAutre && _formationAutreController.text.isNotEmpty) {
        formations.add('Autre: ${_formationAutreController.text}');
      }

      // Créer un Map avec les données modifiées
      Map<String, dynamic> updatedData = {
        'fonction_technique_actuelle': _fonctionTechniqueController.text,
        'date_fonction_technique_actuelle': _dateFonctionTechniqueController.text,
        'affectation_unite': _affectationUsineController.text,
        'date_affectation_unite': _dateAffectationUsineController.text,
        'fonction_administration': _fonctionAdministrativeController.text,
        'date_fonction_administration': _dateFonctionAdministrativeController.text,
        'formation': formations.join(', '),
        'periode': _periodeController.text,
        'formation_autre': _formationAutreController.text,
      };

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Modifications sauvegardées avec succès !'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      print('Données à sauvegarder: $updatedData');

    } catch (e) {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Text('Erreur lors de la sauvegarde: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: statusColor ?? Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ok':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'N/A';
    try {
      // Si c'est déjà au format DD/MM/YYYY, on le retourne tel quel
      if (dateString.contains('/')) {
        return dateString;
      }
      // Si c'est au format YYYY-MM-DD, on le convertit
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString; // Retourne la chaîne originale si la conversion échoue
    }
  }

  String _getFormationDisplay(String formation) {
    if (formation.isEmpty) return 'N/A';

    // Si c'est un code de formation, on affiche le libellé français
    final formationLabels = {
      'formation_base': 'Formation de base',
      'ab_initio': 'Ab initio',
      'formation_gestion_equipe': 'Formation gestion d\'équipe',
      'formation_formateur': 'Formation des formateurs',
      'formation_leadership': 'Formation leadership',
      'autre': 'Autre',
    };

    // Si c'est un code connu, on retourne le libellé
    if (formationLabels.containsKey(formation)) {
      return formationLabels[formation]!;
    }

    // Sinon, on affiche le texte original du fichier Excel
    return formation;
  }

  Widget _buildConditionsSection(BuildContext context) {
    // Créer les conditions actuelles basées sur les checkboxes
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

    return _buildSectionCard(
      context,
      '🎯 Conditions et Fonctions Éligibles',
      [


        const SizedBox(height: 16),

        // Section Examens et Certificats
        Text('📝 Examens & Certificats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
        const SizedBox(height: 8),

        CheckboxListTile(
          title: const Text('Examen Sécurité d\'Exploitation'),
          subtitle: const Text('Requis pour: Contrôleur Aire de Trafic'),
          value: _examenSecurite,
          onChanged: (value) => setState(() => _examenSecurite = value ?? false),
          activeColor: Theme.of(context).primaryColor,
          dense: true,
        ),
        CheckboxListTile(
          title: const Text('Certificat Médical'),
          subtitle: const Text('Requis pour: Responsable Unité GAT'),
          value: _certificatMedical,
          onChanged: (value) => setState(() => _certificatMedical = value ?? false),
          activeColor: Theme.of(context).primaryColor,
          dense: true,
        ),

        const SizedBox(height: 16),

        // Section Ancienneté (sliders)
        Text('⏰ Ancienneté (années)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
        const SizedBox(height: 8),

        _buildSlider('Contrôleur Stagiaire', _ancienneteStage, (value) => setState(() => _ancienneteStage = value)),
        _buildSlider('Contrôleur Aire de Trafic', _ancienneteControleur, (value) => setState(() => _ancienneteControleur = value)),
        _buildSlider('Assistant', _ancienneteAssistant, (value) => setState(() => _ancienneteAssistant = value)),
        _buildSlider('Supervisor', _ancienneteSupervisor, (value) => setState(() => _ancienneteSupervisor = value)),
        _buildSlider('Contrôleur Instructeur', _ancienneteInstructeur, (value) => setState(() => _ancienneteInstructeur = value)),
        _buildSlider('Responsable Cellule', _ancienneteResponsable, (value) => setState(() => _ancienneteResponsable = value)),

        const SizedBox(height: 20),

        // Affichage des fonctions éligibles EN TEMPS RÉEL
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.assignment_turned_in, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Text('Fonctions Éligibles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[800])),
                ],
              ),
              const SizedBox(height: 12),

              if (fonctionsEligibles.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
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
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fonction.displayName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800], fontSize: 14)),
                            Text(AgentConditionsLogic.getConditionsDescription(fonction), style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(String title, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title: $value ans', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (newValue) => onChanged(newValue.round()),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  AgentConditions _createConditionsFromAgent() {
    // Analyser les formations existantes de l'agent
    bool hasAbInitio = false;
    bool hasGestionEquipe = false;
    bool hasFormateurs = false;
    bool hasLeadership = false;

    if (widget.agent.formation != null) {
      String formation = widget.agent.formation!.toLowerCase();
      hasAbInitio = formation.contains('ab initio') || formation.contains('ab_initio');
      hasGestionEquipe = formation.contains('gestion') && formation.contains('équipe');
      hasFormateurs = formation.contains('formateur');
      hasLeadership = formation.contains('leadership');
    }

    // Analyser la fonction actuelle pour déterminer l'ancienneté
    int ancienneteControleur = 0;
    int ancienneteAssistant = 0;
    int ancienneteSupervisor = 0;

    if (widget.agent.fonctionActuelle != null) {
      String fonction = widget.agent.fonctionActuelle!.toLowerCase();
      if (fonction.contains('contrôleur') || fonction.contains('controleur')) {
        ancienneteControleur = 3; // Valeur d'exemple
      }
      if (fonction.contains('assistant')) {
        ancienneteAssistant = 2; // Valeur d'exemple
      }
      if (fonction.contains('supervisor') || fonction.contains('superviseur')) {
        ancienneteSupervisor = 1; // Valeur d'exemple
      }
    }

    return AgentConditions(
      formationAbInitio: hasAbInitio,
      formationGestionEquipe: hasGestionEquipe,
      formationDesFormateurs: hasFormateurs,
      formationLeadership: hasLeadership,
      examenSecuriteExploitation: hasAbInitio, // Si ab-initio, probablement passé
      ancienneteControleurAireTrafic: ancienneteControleur,
      ancienneteAssistant: ancienneteAssistant,
      ancienneteSupervisor: ancienneteSupervisor,
      certificatMedical: true, // Supposé pour les agents actifs
    );
  }

  FonctionAgent? _getCurrentFonction() {
    if (widget.agent.fonctionActuelle == null) return null;

    String fonction = widget.agent.fonctionActuelle!.toLowerCase();
    if (fonction.contains('stagiaire')) return FonctionAgent.controleurAireTraficStagiaire;
    if (fonction.contains('contrôleur') && !fonction.contains('instructeur')) return FonctionAgent.controleurAireTrafic;
    if (fonction.contains('assistant')) return FonctionAgent.assistant;
    if (fonction.contains('supervisor')) return FonctionAgent.supervisor;
    if (fonction.contains('instructeur')) return FonctionAgent.controleurAireTraficInstructeur;
    if (fonction.contains('responsable') && fonction.contains('cellule')) return FonctionAgent.responsableCelluleInstruction;
    if (fonction.contains('responsable') && fonction.contains('gat')) return FonctionAgent.responsableUniteGAT;

    return null;
  }

  bool _hasAnyAnciennete(AgentConditions conditions) {
    return conditions.ancienneteControleurStage > 0 ||
           conditions.ancienneteControleurAireTrafic > 0 ||
           conditions.ancienneteAssistant > 0 ||
           conditions.ancienneteSupervisor > 0 ||
           conditions.ancienneteControleurInstructeur > 0 ||
           conditions.ancienneteResponsableCellule > 0;
  }

  void _showConditionsDialog(BuildContext context, AgentConditions currentConditions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier les conditions'),
          content: const Text('Fonctionnalité en cours de développement.\n\nPour tester les conditions, utilisez la page "🎯 Conditions Agent" depuis le menu principal.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF1e3c72),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormationChip(IconData icon, String label, String value) {
    // Nettoyer et formater la formation pour un affichage compact
    String formationText = value.trim();

    // Si la formation est trop longue, la tronquer avec "..."
    if (formationText.length > 60) {
      formationText = '${formationText.substring(0, 57)}...';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.green[700],
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Afficher la formation sur une seule ligne, compacte
              Text(
                formationText,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green[800],
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormationSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de section
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1e3c72).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Color(0xFF1e3c72),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '🎓 Formation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1e3c72),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Formation initiale (lecture seule)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Formation initiale',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _getFormationInitialeDisplay(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Formations disponibles (cases à cocher)
            Text(
              'Sélectionner les formations :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),

            // Cases à cocher pour les formations
            _buildFormationCheckbox('Formation Ab Initio', _selectedFormationAbInitio, (value) {
              setState(() {
                _selectedFormationAbInitio = value ?? false;
              });
            }),
            _buildFormationCheckbox('Formation Contrôleur Stage', _selectedFormationControleurStage, (value) {
              setState(() {
                _selectedFormationControleurStage = value ?? false;
              });
            }),
            _buildFormationCheckbox('Formation Contrôleur Aire de Trafic', _selectedFormationControleurAireTrafic, (value) {
              setState(() {
                _selectedFormationControleurAireTrafic = value ?? false;
              });
            }),
            _buildFormationCheckbox('Formation Formateurs', _selectedFormationFormateurs, (value) {
              setState(() {
                _selectedFormationFormateurs = value ?? false;
              });
            }),
            _buildFormationCheckbox('Formation Leadership', _selectedFormationLeadership, (value) {
              setState(() {
                _selectedFormationLeadership = value ?? false;
              });
            }),
            _buildFormationCheckbox('Formation Gestion Équipe', _selectedFormationGestionEquipe, (value) {
              setState(() {
                _selectedFormationGestionEquipe = value ?? false;
              });
            }),
            _buildFormationCheckbox('Autre formation', _selectedFormationAutre, (value) {
              setState(() {
                _selectedFormationAutre = value ?? false;
              });
            }),

            // Champ "Formation autre" (affiché seulement si "Autre" est coché)
            if (_selectedFormationAutre) ...[
              const SizedBox(height: 12),
              _buildEditableField(
                context,
                'Préciser la formation autre',
                _formationAutreController,
                Icons.edit
              ),
            ],

            const SizedBox(height: 16),

            // Période
            _buildEditableField(
              context,
              'Période',
              _periodeController,
              Icons.calendar_today
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormationCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1e3c72),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(BuildContext context, String label, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF1e3c72),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.grey[50],
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                hintText: 'Saisir $label...',
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
