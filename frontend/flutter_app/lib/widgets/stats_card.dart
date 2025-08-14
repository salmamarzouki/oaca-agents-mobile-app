import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const StatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final totalAgents = stats['total_agents'] ?? 0;
    final byAffectation = stats['by_affectation'] as Map<String, dynamic>? ?? {};
    final bySource = stats['by_source_file'] as Map<String, dynamic>? ?? {};

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics,
                color: Color(0xFF1e3c72),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Statistiques Détaillées',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1e3c72),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Stats Row
          Row(
            children: [
              Expanded(
                child: _buildQuickStat(
                  context,
                  'Total',
                  totalAgents.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildQuickStat(
                  context,
                  'Affectations',
                  byAffectation.length.toString(),
                  Icons.work,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildQuickStat(
                  context,
                  'Sources',
                  bySource.length.toString(),
                  Icons.source,
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Compact Breakdown
          if (byAffectation.isNotEmpty) ...[
            _buildCompactSection(
              context,
              'Top Affectations',
              byAffectation.entries.take(3).map((e) =>
                MapEntry(e.key == 'null' ? 'Non spécifié' : e.key, e.value)
              ).toList(),
            ),
          ],

          if (bySource.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildCompactSection(
              context,
              'Sources de Données',
              bySource.entries.take(2).map((e) =>
                MapEntry(_getSourceFileDisplayName(e.key), e.value)
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSection(
    BuildContext context,
    String title,
    List<MapEntry<String, dynamic>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1e3c72),
          ),
        ),
        const SizedBox(height: 4),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.key,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.value.toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }



  String _getSourceFileDisplayName(String sourceFile) {
    if (sourceFile.isEmpty) return 'Unknown';

    // Extract meaningful names from source file paths
    if (sourceFile.toLowerCase().contains('ppa') &&
        sourceFile.toLowerCase().contains('gat')) {
      return 'PPA & GAT & PT';
    }
    if (sourceFile.toLowerCase().contains('naima')) {
      return 'Naima 2022';
    }

    // For other files, try to extract filename without extension
    final fileName = sourceFile.split('/').last.split('\\').last;
    if (fileName.contains('.')) {
      return fileName.substring(0, fileName.lastIndexOf('.'));
    }

    return fileName.isNotEmpty ? fileName : 'Other';
  }
}
