import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> agent;

  const AgentDetailsScreen({
    super.key,
    required this.agent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${agent['nom'] ?? ''} ${agent['prenom'] ?? ''}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareAgent(context),
          ),
        ],
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
        child: Column(
          children: [
            // En-tête avec avatar
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: CircleAvatar(
                      backgroundColor: _getAvatarColor(agent['nom'] ?? ''),
                      radius: 45,
                      child: Text(
                        _getInitials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${agent['nom'] ?? ''} ${agent['prenom'] ?? ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (agent['fonction'] != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        agent['fonction'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Contenu des détails
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Informations Personnelles'),
                      _buildInfoCard([
                        _buildInfoRow('Nom complet', agent['nom_complet'] ?? agent['full_name']),
                        _buildInfoRow('Matricule', agent['matricule']),
                        _buildInfoRow('Date de naissance', _formatDate(agent['date_naissance'])),
                        _buildInfoRow('Âge', agent['age']?.toString()),
                      ]),
                      
                      const SizedBox(height: 25),
                      _buildSectionTitle('Affectation Professionnelle'),
                      _buildInfoCard([
                        _buildInfoRow('Fonction', agent['fonction']),
                        _buildInfoRow('Affectation', agent['affectation']),
                        _buildInfoRow('Unité', agent['unite']),
                        _buildInfoRow('Service', agent['service']),
                      ]),

                      if (_hasFormationInfo())
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25),
                            _buildSectionTitle('Formation(s)'),
                            _buildFormationCard(),
                          ],
                        ),

                      if (_hasContactInfo())
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25),
                            _buildSectionTitle('Contact'),
                            _buildInfoCard([
                              _buildInfoRow('Téléphone', agent['telephone']),
                              _buildInfoRow('Email', agent['email']),
                              _buildInfoRow('Adresse', agent['adresse']),
                            ]),
                          ],
                        ),

                      const SizedBox(height: 25),
                      _buildSectionTitle('Informations Système'),
                      _buildInfoCard([
                        _buildInfoRow('ID', agent['id']?.toString()),
                        _buildInfoRow('Dernière mise à jour', _formatDate(agent['updated_at'])),
                        _buildInfoRow('Date création', _formatDate(agent['created_at'])),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1565C0),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _copyToClipboard(value.toString()),
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Icon(
            Icons.copy,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  String _getInitials() {
    final nom = agent['nom']?.toString() ?? '';
    final prenom = agent['prenom']?.toString() ?? '';
    
    String initials = '';
    if (nom.isNotEmpty) initials += nom[0].toUpperCase();
    if (prenom.isNotEmpty) initials += prenom[0].toUpperCase();
    
    return initials.isEmpty ? '?' : initials;
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.orange[700]!,
      Colors.purple[700]!,
      Colors.red[700]!,
      Colors.teal[700]!,
      Colors.indigo[700]!,
      Colors.pink[700]!,
    ];
    
    final index = name.hashCode % colors.length;
    return colors[index.abs()];
  }

  String? _formatDate(dynamic date) {
    if (date == null) return null;
    
    try {
      final dateStr = date.toString();
      if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        if (parts.length >= 3) {
          return '${parts[2]}/${parts[1]}/${parts[0]}';
        }
      }
      return dateStr;
    } catch (e) {
      return date.toString();
    }
  }

  Widget _buildFormationCard() {
    List<Widget> formationWidgets = [];

    // Traiter les formations multiples (séparées par |)
    if (agent['formation'] != null && agent['formation'].toString().isNotEmpty) {
      String formationsText = agent['formation'].toString();

      // Nettoyer et séparer les formations
      List<String> formations = formationsText
          .split('|')
          .map((f) => f.trim())
          .where((f) => f.isNotEmpty && f != 'N/A')
          .toList();

      for (int i = 0; i < formations.length; i++) {
        String formation = formations[i];

        formationWidgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.blue[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue[300]!, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[600]!, Colors.blue[800]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formation,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (agent['periode'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green[300]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${agent['periode']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.school,
                  color: Colors.blue[600],
                  size: 24,
                ),
              ],
            ),
          ),
        );
      }
    }

    // Ajouter d'autres informations de formation
    List<Widget> otherFormationInfo = [];
    if (agent['date_formation'] != null) {
      otherFormationInfo.add(_buildInfoRow('Date formation', _formatDate(agent['date_formation'])));
    }
    if (agent['lieu_formation'] != null) {
      otherFormationInfo.add(_buildInfoRow('Lieu formation', agent['lieu_formation']));
    }
    if (agent['duree_formation'] != null) {
      otherFormationInfo.add(_buildInfoRow('Durée formation', agent['duree_formation']));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (formationWidgets.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.blue[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Formations reçues (${formationWidgets.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ...formationWidgets,
                ],
              ),
            ),
          ],
          if (otherFormationInfo.isNotEmpty) ...[
            if (formationWidgets.isNotEmpty)
              Divider(color: Colors.grey[300], height: 1),
            Column(children: otherFormationInfo),
          ],
          if (formationWidgets.isEmpty && otherFormationInfo.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Aucune information de formation disponible',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _hasFormationInfo() {
    return agent['formation'] != null ||
           agent['date_formation'] != null ||
           agent['lieu_formation'] != null ||
           agent['duree_formation'] != null;
  }

  bool _hasContactInfo() {
    return agent['telephone'] != null ||
           agent['email'] != null ||
           agent['adresse'] != null;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void _shareAgent(BuildContext context) {
    final agentInfo = '''
Nom: ${agent['nom'] ?? ''} ${agent['prenom'] ?? ''}
Matricule: ${agent['matricule'] ?? ''}
Fonction: ${agent['fonction'] ?? ''}
Affectation: ${agent['affectation'] ?? ''}
''';
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Informations copiées'),
        backgroundColor: Colors.green,
      ),
    );
    
    Clipboard.setData(ClipboardData(text: agentInfo));
  }
}
