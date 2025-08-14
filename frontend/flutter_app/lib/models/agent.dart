import 'agent_conditions.dart';

class Agent {
  final int id;
  final String matricule;
  final String nom;
  final String? prenom;
  final String? nomComplet;
  final String fullName;
  final String? dateNaissance;
  final int? age;
  final String? affectation;
  final String? periode;
  final String? fonctionActuelle;
  final String? dateFonctionActuelle;
  final String? fonctionTechniqueActuelle;
  final String? dateFonctionTechniqueActuelle;
  final String? affectationUnite;
  final String? dateAffectationUnite;
  final String? fonctionAdministration;
  final String? dateFonctionAdministration;
  final String? fonctionGrade;
  final String? formation;
  final String? formationAutre;
  final String sourceFile;
  final String? status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Nouveaux champs pour les conditions et fonctions
  final AgentConditions? conditions;
  final FonctionAgent? fonctionEligible;

  Agent({
    required this.id,
    required this.matricule,
    required this.nom,
    this.prenom,
    this.nomComplet,
    required this.fullName,
    this.dateNaissance,
    this.age,
    this.affectation,
    this.periode,
    this.fonctionActuelle,
    this.dateFonctionActuelle,
    this.fonctionTechniqueActuelle,
    this.dateFonctionTechniqueActuelle,
    this.affectationUnite,
    this.dateAffectationUnite,
    this.fonctionAdministration,
    this.dateFonctionAdministration,
    this.fonctionGrade,
    this.formation,
    this.formationAutre,
    required this.sourceFile,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    this.conditions,
    this.fonctionEligible,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      matricule: json['matricule'],
      nom: json['nom'],
      prenom: json['prenom'],
      nomComplet: json['nom_complet'],
      fullName: json['full_name'],
      dateNaissance: json['date_naissance'],
      age: json['age'],
      affectation: json['affectation'],
      periode: json['periode'],
      fonctionActuelle: json['fonction_actuelle'],
      dateFonctionActuelle: json['date_fonction_actuelle'],
      fonctionTechniqueActuelle: json['fonction_technique_actuelle'],
      dateFonctionTechniqueActuelle: json['date_fonction_technique_actuelle'],
      affectationUnite: json['affectation_unite'],
      dateAffectationUnite: json['date_affectation_unite'],
      fonctionAdministration: json['fonction_administration'],
      dateFonctionAdministration: json['date_fonction_administration'],
      fonctionGrade: json['fonction_grade'],
      formation: json['formation'],
      formationAutre: json['formation_autre'],
      sourceFile: json['source_file'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      conditions: json['conditions'] != null
          ? AgentConditions.fromJson(json['conditions'])
          : null,
      fonctionEligible: json['fonction_eligible'] != null
          ? FonctionAgent.values.firstWhere(
              (f) => f.name == json['fonction_eligible'],
              orElse: () => FonctionAgent.controleurAireTraficStagiaire,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricule': matricule,
      'nom': nom,
      'prenom': prenom,
      'nom_complet': nomComplet,
      'full_name': fullName,
      'date_naissance': dateNaissance,
      'age': age,
      'affectation': affectation,
      'periode': periode,
      'fonction_actuelle': fonctionActuelle,
      'date_fonction_actuelle': dateFonctionActuelle,
      'fonction_technique_actuelle': fonctionTechniqueActuelle,
      'date_fonction_technique_actuelle': dateFonctionTechniqueActuelle,
      'affectation_unite': affectationUnite,
      'date_affectation_unite': dateAffectationUnite,
      'fonction_administration': fonctionAdministration,
      'date_fonction_administration': dateFonctionAdministration,
      'fonction_grade': fonctionGrade,
      'formation': formation,
      'formation_autre': formationAutre,
      'source_file': sourceFile,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'conditions': conditions?.toJson(),
      'fonction_eligible': fonctionEligible?.name,
    };
  }

  @override
  String toString() {
    return 'Agent{id: $id, matricule: $matricule, fullName: $fullName}';
  }
}
