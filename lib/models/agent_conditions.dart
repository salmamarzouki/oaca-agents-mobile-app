class AgentConditions {
  // Formations
  bool formationAbInitio;
  bool formationGestionEquipe;
  bool formationDesFormateurs;
  bool formationLeadership;
  bool formationAutre;
  String formationAutreTexte;

  // Examens
  bool examenSecuriteExploitation;
  
  // Ancienneté (en années)
  int ancienneteControleurStage;
  int ancienneteControleurAireTrafic;
  int ancienneteAssistant;
  int ancienneteSupervisor;
  int ancienneteControleurInstructeur;
  int ancienneteResponsableCellule;
  
  // Certificats
  bool certificatMedical;
  
  AgentConditions({
    this.formationAbInitio = false,
    this.formationGestionEquipe = false,
    this.formationDesFormateurs = false,
    this.formationLeadership = false,
    this.formationAutre = false,
    this.formationAutreTexte = '',
    this.examenSecuriteExploitation = false,
    this.ancienneteControleurStage = 0,
    this.ancienneteControleurAireTrafic = 0,
    this.ancienneteAssistant = 0,
    this.ancienneteSupervisor = 0,
    this.ancienneteControleurInstructeur = 0,
    this.ancienneteResponsableCellule = 0,
    this.certificatMedical = false,
  });

  // Convertir vers JSON
  Map<String, dynamic> toJson() {
    return {
      'formation_ab_initio': formationAbInitio,
      'formation_gestion_equipe': formationGestionEquipe,
      'formation_des_formateurs': formationDesFormateurs,
      'formation_leadership': formationLeadership,
      'examen_securite_exploitation': examenSecuriteExploitation,
      'anciennete_controleur_stage': ancienneteControleurStage,
      'anciennete_controleur_aire_trafic': ancienneteControleurAireTrafic,
      'anciennete_assistant': ancienneteAssistant,
      'anciennete_supervisor': ancienneteSupervisor,
      'anciennete_controleur_instructeur': ancienneteControleurInstructeur,
      'anciennete_responsable_cellule': ancienneteResponsableCellule,
      'certificat_medical': certificatMedical,
    };
  }

  // Créer depuis JSON
  factory AgentConditions.fromJson(Map<String, dynamic> json) {
    return AgentConditions(
      formationAbInitio: json['formation_ab_initio'] ?? false,
      formationGestionEquipe: json['formation_gestion_equipe'] ?? false,
      formationDesFormateurs: json['formation_des_formateurs'] ?? false,
      formationLeadership: json['formation_leadership'] ?? false,
      examenSecuriteExploitation: json['examen_securite_exploitation'] ?? false,
      ancienneteControleurStage: json['anciennete_controleur_stage'] ?? 0,
      ancienneteControleurAireTrafic: json['anciennete_controleur_aire_trafic'] ?? 0,
      ancienneteAssistant: json['anciennete_assistant'] ?? 0,
      ancienneteSupervisor: json['anciennete_supervisor'] ?? 0,
      ancienneteControleurInstructeur: json['anciennete_controleur_instructeur'] ?? 0,
      ancienneteResponsableCellule: json['anciennete_responsable_cellule'] ?? 0,
      certificatMedical: json['certificat_medical'] ?? false,
    );
  }

  // Copier avec modifications
  AgentConditions copyWith({
    bool? formationAbInitio,
    bool? formationGestionEquipe,
    bool? formationDesFormateurs,
    bool? formationLeadership,
    bool? formationAutre,
    String? formationAutreTexte,
    bool? examenSecuriteExploitation,
    int? ancienneteControleurStage,
    int? ancienneteControleurAireTrafic,
    int? ancienneteAssistant,
    int? ancienneteSupervisor,
    int? ancienneteControleurInstructeur,
    int? ancienneteResponsableCellule,
    bool? certificatMedical,
  }) {
    return AgentConditions(
      formationAbInitio: formationAbInitio ?? this.formationAbInitio,
      formationGestionEquipe: formationGestionEquipe ?? this.formationGestionEquipe,
      formationDesFormateurs: formationDesFormateurs ?? this.formationDesFormateurs,
      formationLeadership: formationLeadership ?? this.formationLeadership,
      formationAutre: formationAutre ?? this.formationAutre,
      formationAutreTexte: formationAutreTexte ?? this.formationAutreTexte,
      examenSecuriteExploitation: examenSecuriteExploitation ?? this.examenSecuriteExploitation,
      ancienneteControleurStage: ancienneteControleurStage ?? this.ancienneteControleurStage,
      ancienneteControleurAireTrafic: ancienneteControleurAireTrafic ?? this.ancienneteControleurAireTrafic,
      ancienneteAssistant: ancienneteAssistant ?? this.ancienneteAssistant,
      ancienneteSupervisor: ancienneteSupervisor ?? this.ancienneteSupervisor,
      ancienneteControleurInstructeur: ancienneteControleurInstructeur ?? this.ancienneteControleurInstructeur,
      ancienneteResponsableCellule: ancienneteResponsableCellule ?? this.ancienneteResponsableCellule,
      certificatMedical: certificatMedical ?? this.certificatMedical,
    );
  }
}

// Énumération des fonctions possibles
enum FonctionAgent {
  controleurAireTraficStagiaire('Contrôleur Aire de Trafic Stagiaire'),
  controleurAireTrafic('Contrôleur Aire de Trafic'),
  assistant('Assistant'),
  supervisor('Supervisor'),
  controleurAireTraficInstructeur('Contrôleur Aire de Trafic Instructeur'),
  responsableCelluleInstruction('Responsable Cellule d\'Instruction'),
  responsableUniteGAT('Responsable de l\'Unité GAT');

  const FonctionAgent(this.displayName);
  final String displayName;
}

// Classe pour gérer la logique des conditions
class AgentConditionsLogic {
  
  // Déterminer les fonctions éligibles selon les conditions
  static List<FonctionAgent> getFonctionsEligibles(AgentConditions conditions) {
    List<FonctionAgent> fonctionsEligibles = [];

    // 1. Contrôleur Aire de Trafic Stagiaire
    if (conditions.formationAbInitio) {
      fonctionsEligibles.add(FonctionAgent.controleurAireTraficStagiaire);
    }

    // 2. Contrôleur Aire de Trafic
    if (conditions.examenSecuriteExploitation && 
        conditions.ancienneteControleurStage >= 1) {
      fonctionsEligibles.add(FonctionAgent.controleurAireTrafic);
    }

    // 3. Assistant
    if (conditions.ancienneteControleurAireTrafic >= 5) {
      fonctionsEligibles.add(FonctionAgent.assistant);
    }

    // 4. Supervisor
    if (conditions.ancienneteAssistant >= 5 && 
        conditions.formationGestionEquipe) {
      fonctionsEligibles.add(FonctionAgent.supervisor);
    }

    // 5. Contrôleur Aire de Trafic Instructeur
    if (conditions.ancienneteSupervisor >= 3 && 
        conditions.formationDesFormateurs) {
      fonctionsEligibles.add(FonctionAgent.controleurAireTraficInstructeur);
    }

    // 6. Responsable Cellule d'Instruction
    if (conditions.ancienneteControleurInstructeur >= 3) {
      fonctionsEligibles.add(FonctionAgent.responsableCelluleInstruction);
    }

    // 7. Responsable de l'Unité GAT
    bool condition1 = conditions.ancienneteResponsableCellule >= 1 && 
                     conditions.certificatMedical && 
                     conditions.formationLeadership;
    bool condition2 = conditions.ancienneteControleurInstructeur >= 4;
    bool condition3 = conditions.ancienneteControleurAireTrafic >= 9;
    
    if (condition1 || condition2 || condition3) {
      fonctionsEligibles.add(FonctionAgent.responsableUniteGAT);
    }

    return fonctionsEligibles;
  }

  // Vérifier si une fonction spécifique est éligible
  static bool isFonctionEligible(AgentConditions conditions, FonctionAgent fonction) {
    return getFonctionsEligibles(conditions).contains(fonction);
  }

  // Obtenir la description des conditions pour une fonction
  static String getConditionsDescription(FonctionAgent fonction) {
    switch (fonction) {
      case FonctionAgent.controleurAireTraficStagiaire:
        return "• Formation Ab-Initio réussie";
      case FonctionAgent.controleurAireTrafic:
        return "• Examen sécurité d'exploitation réussi\n• 1 an d'ancienneté contrôleur stagiaire";
      case FonctionAgent.assistant:
        return "• 5 ans d'ancienneté contrôleur aire de trafic";
      case FonctionAgent.supervisor:
        return "• 5 ans d'ancienneté assistant\n• Formation gestion équipe réussie";
      case FonctionAgent.controleurAireTraficInstructeur:
        return "• 3 ans d'ancienneté supervisor\n• Formation des formateurs réussie";
      case FonctionAgent.responsableCelluleInstruction:
        return "• 3 ans d'ancienneté contrôleur instructeur";
      case FonctionAgent.responsableUniteGAT:
        return "• Option 1: 1 an responsable cellule + certificat médical + formation leadership\n• Option 2: 4 ans contrôleur instructeur\n• Option 3: 9 ans ancienneté contrôleur aire trafic";
    }
  }
}
