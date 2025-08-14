import 'package:flutter/material.dart';
import '../models/agent_conditions.dart';

class AgentFonctionDisplay extends StatelessWidget {
  final AgentConditions? conditions;
  final FonctionAgent? currentFonction;

  const AgentFonctionDisplay({
    super.key,
    this.conditions,
    this.currentFonction,
  });

  @override
  Widget build(BuildContext context) {
    if (conditions == null) {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            Text(
              'Conditions non définies',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final eligibleFunctions = AgentConditionsLogic.getFonctionsEligibles(conditions!);
    
    if (eligibleFunctions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, size: 16, color: Colors.orange),
            SizedBox(width: 4),
            Text(
              'Aucune fonction éligible',
              style: TextStyle(fontSize: 12, color: Colors.orange[800]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (currentFonction != null) ...[
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Fonction: ${currentFonction!.displayName}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
        ],
        
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    'Fonctions éligibles (${eligibleFunctions.length}):',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 2,
                children: eligibleFunctions.map((fonction) => 
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Text(
                      fonction.displayName,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget pour afficher les conditions d'un agent de manière compacte
class AgentConditionsDisplay extends StatelessWidget {
  final AgentConditions conditions;

  const AgentConditionsDisplay({
    super.key,
    required this.conditions,
  });

  @override
  Widget build(BuildContext context) {
    List<String> activeConditions = [];
    
    // Formations
    if (conditions.formationAbInitio) activeConditions.add('Ab-Initio');
    if (conditions.formationGestionEquipe) activeConditions.add('Gestion Équipe');
    if (conditions.formationDesFormateurs) activeConditions.add('Formateurs');
    if (conditions.formationLeadership) activeConditions.add('Leadership');
    
    // Examens et certificats
    if (conditions.examenSecuriteExploitation) activeConditions.add('Sécurité Exploitation');
    if (conditions.certificatMedical) activeConditions.add('Certificat Médical');
    
    // Ancienneté
    if (conditions.ancienneteControleurStage > 0) activeConditions.add('${conditions.ancienneteControleurStage}a Stagiaire');
    if (conditions.ancienneteControleurAireTrafic > 0) activeConditions.add('${conditions.ancienneteControleurAireTrafic}a Contrôleur');
    if (conditions.ancienneteAssistant > 0) activeConditions.add('${conditions.ancienneteAssistant}a Assistant');
    if (conditions.ancienneteSupervisor > 0) activeConditions.add('${conditions.ancienneteSupervisor}a Supervisor');
    if (conditions.ancienneteControleurInstructeur > 0) activeConditions.add('${conditions.ancienneteControleurInstructeur}a Instructeur');
    if (conditions.ancienneteResponsableCellule > 0) activeConditions.add('${conditions.ancienneteResponsableCellule}a Resp. Cellule');

    if (activeConditions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Aucune condition définie',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified, size: 16, color: Colors.purple),
              SizedBox(width: 4),
              Text(
                'Conditions remplies:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 2,
            children: activeConditions.map((condition) => 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.purple.withOpacity(0.2)),
                ),
                child: Text(
                  condition,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.purple[700],
                  ),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
