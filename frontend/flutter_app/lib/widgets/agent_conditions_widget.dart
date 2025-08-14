import 'package:flutter/material.dart';
import '../models/agent_conditions.dart';

class AgentConditionsWidget extends StatefulWidget {
  final AgentConditions conditions;
  final Function(AgentConditions) onConditionsChanged;
  final Function(FonctionAgent?) onFonctionSelected;

  const AgentConditionsWidget({
    super.key,
    required this.conditions,
    required this.onConditionsChanged,
    required this.onFonctionSelected,
  });

  @override
  State<AgentConditionsWidget> createState() => _AgentConditionsWidgetState();
}

class _AgentConditionsWidgetState extends State<AgentConditionsWidget> {
  late AgentConditions _conditions;
  FonctionAgent? _selectedFonction;

  @override
  void initState() {
    super.initState();
    _conditions = widget.conditions;
    _updateEligibleFunctions();
  }

  void _updateConditions(AgentConditions newConditions) {
    setState(() {
      _conditions = newConditions;
    });
    widget.onConditionsChanged(newConditions);
    _updateEligibleFunctions();
  }

  void _updateEligibleFunctions() {
    final eligibleFunctions = AgentConditionsLogic.getFonctionsEligibles(_conditions);
    
    // Si la fonction sélectionnée n'est plus éligible, la désélectionner
    if (_selectedFonction != null && !eligibleFunctions.contains(_selectedFonction)) {
      _selectedFonction = null;
      widget.onFonctionSelected(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eligibleFunctions = AgentConditionsLogic.getFonctionsEligibles(_conditions);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Formations (compacte)
          _buildCompactSection('📚 Formations', [
            _buildCompactCheckbox('Ab-Initio', _conditions.formationAbInitio,
                (value) => _updateConditions(_conditions.copyWith(formationAbInitio: value))),
            _buildCompactCheckbox('Gestion Équipe', _conditions.formationGestionEquipe,
                (value) => _updateConditions(_conditions.copyWith(formationGestionEquipe: value))),
            _buildCompactCheckbox('Des Formateurs', _conditions.formationDesFormateurs,
                (value) => _updateConditions(_conditions.copyWith(formationDesFormateurs: value))),
            _buildCompactCheckbox('Leadership', _conditions.formationLeadership,
                (value) => _updateConditions(_conditions.copyWith(formationLeadership: value))),
          ]),

          SizedBox(height: 15),

          // Section Examens et Certificats
          _buildCompactSection('📝 Examens & Certificats', [
            _buildCompactCheckbox('Sécurité Exploitation', _conditions.examenSecuriteExploitation,
                (value) => _updateConditions(_conditions.copyWith(examenSecuriteExploitation: value))),
            _buildCompactCheckbox('Certificat Médical', _conditions.certificatMedical,
                (value) => _updateConditions(_conditions.copyWith(certificatMedical: value))),
          ]),

          SizedBox(height: 15),

          // Section Ancienneté (compacte)
          _buildSectionTitle('⏰ Ancienneté (années)'),
          Row(
            children: [
              Expanded(child: _buildCompactAncienneteField('Stagiaire', _conditions.ancienneteControleurStage,
                  (value) => _updateConditions(_conditions.copyWith(ancienneteControleurStage: value)))),
              SizedBox(width: 8),
              Expanded(child: _buildCompactAncienneteField('Contrôleur', _conditions.ancienneteControleurAireTrafic,
                  (value) => _updateConditions(_conditions.copyWith(ancienneteControleurAireTrafic: value)))),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildCompactAncienneteField('Assistant', _conditions.ancienneteAssistant,
                  (value) => _updateConditions(_conditions.copyWith(ancienneteAssistant: value)))),
              SizedBox(width: 8),
              Expanded(child: _buildCompactAncienneteField('Supervisor', _conditions.ancienneteSupervisor,
                  (value) => _updateConditions(_conditions.copyWith(ancienneteSupervisor: value)))),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildCompactAncienneteField('Instructeur', _conditions.ancienneteControleurInstructeur,
                  (value) => _updateConditions(_conditions.copyWith(ancienneteControleurInstructeur: value)))),
              SizedBox(width: 8),
              Expanded(child: _buildCompactAncienneteField('Resp. Cellule', _conditions.ancienneteResponsableCellule,
                  (value) => _updateConditions(_conditions.copyWith(ancienneteResponsableCellule: value)))),
            ],
          ),

          SizedBox(height: 20),

          // Section Fonctions Éligibles (compacte)
          _buildSectionTitle('🎯 Fonctions Éligibles'),
          if (eligibleFunctions.isEmpty)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Aucune fonction éligible',
                      style: TextStyle(color: Colors.orange[800], fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          else
            ...eligibleFunctions.map((fonction) => _buildCompactFonctionOption(fonction)),

          if (eligibleFunctions.isNotEmpty && _selectedFonction != null) ...[
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sélectionné: ${_selectedFonction!.displayName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1e3c72),
        ),
      ),
    );
  }

  Widget _buildCompactSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: children,
        ),
      ],
    );
  }

  Widget _buildCompactCheckbox(String title, bool value, Function(bool) onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: value ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? Colors.green : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              size: 16,
              color: value ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: value ? Colors.green[800] : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactAncienneteField(String title, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        SizedBox(height: 2),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 12),
          decoration: InputDecoration(
            suffixText: 'ans',
            suffixStyle: TextStyle(fontSize: 10),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            isDense: true,
          ),
          onChanged: (newValue) {
            final intValue = int.tryParse(newValue) ?? 0;
            onChanged(intValue);
          },
        ),
      ],
    );
  }

  Widget _buildCompactFonctionOption(FonctionAgent fonction) {
    final isSelected = _selectedFonction == fonction;

    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFonction = isSelected ? null : fonction;
          });
          widget.onFonctionSelected(_selectedFonction);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? Colors.green : Colors.grey,
                size: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  fonction.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.green[800] : Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
