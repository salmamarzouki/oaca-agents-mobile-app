import 'package:flutter/material.dart';
import '../models/agent.dart';

class AgentCard extends StatelessWidget {
  final Agent agent;
  final VoidCallback onTap;

  const AgentCard({
    super.key,
    required this.agent,
    required this.onTap,
  });

  // Optimisation : mémoriser les initiales pour éviter le recalcul
  static final Map<String, String> _initialsCache = <String, String>{};

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    _getInitials(agent.fullName),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Agent Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Matricule
                    Text(
                      agent.fullName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Matricule
                    Text(
                      'Matricule: ${agent.matricule}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Affectation
                    if (agent.affectation != null && agent.affectation!.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              agent.affectation!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    
                    // Status
                    if (agent.status != null && agent.status!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(agent.status!).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(agent.status!).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            agent.status!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(agent.status!),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Arrow Icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String fullName) {
    // Utiliser le cache pour éviter les recalculs
    if (_initialsCache.containsKey(fullName)) {
      return _initialsCache[fullName]!;
    }

    String initials;
    if (fullName.isEmpty) {
      initials = agent.matricule.isNotEmpty ? agent.matricule[0] : 'A';
    } else {
      final names = fullName.trim().split(' ');
      if (names.length == 1) {
        initials = names[0][0].toUpperCase();
      } else {
        initials = '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
      }
    }

    _initialsCache[fullName] = initials;
    return initials;
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
}
