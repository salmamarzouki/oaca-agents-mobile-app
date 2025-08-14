import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/agent_provider.dart';
import '../widgets/agent_card.dart';
import '../widgets/search_bar.dart';

import 'agent_detail_screen.dart';

class AgentsListScreen extends StatefulWidget {
  @override
  State<AgentsListScreen> createState() => _AgentsListScreenState();
}

class _AgentsListScreenState extends State<AgentsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Chargement immédiat avec données mock puis API en arrière-plan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadAgentsWithFallback();
      }
    });
  }

  Future<void> _loadAgentsWithFallback() async {
    final provider = Provider.of<AgentProvider>(context, listen: false);
    try {
      await provider.loadAgentsWithFallback();
    } catch (e) {
      // Si le chargement échoue, on continue avec les données mock
      debugPrint('Chargement initial échoué, utilisation des données mock: $e');
    }
  }

  @override
/// Disposes the `_searchController` and calls the superclass's `dispose` method.
/// This ensures that all resources are released properly when the widget is removed from the widget tree.
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'ديوان الطيران المدني و المطارات',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              'OACA - Gestion des Agents',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1e3c72),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<AgentProvider>(
            builder: (context, agentProvider, child) {
              return IconButton(
                icon: agentProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh),
                onPressed: agentProvider.isLoading
                    ? null
                    : () => agentProvider.loadAgents(forceRefresh: true),
                tooltip: 'Actualiser',
              );
            },
          ),
        ],
      ),
      body: Consumer<AgentProvider>(
        builder: (context, agentProvider, child) {
          if (agentProvider.isLoading && agentProvider.agents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1e3c72)),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Chargement des agents depuis les fichiers Excel...',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Liste des agents aux unités PPA&GAT&PT',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => _loadAgentsWithFallback(),
                    child: const Text('Utiliser les données de démonstration'),
                  ),
                ],
              ),
            );
          }

          if (agentProvider.error != null && agentProvider.agents.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Erreur de chargement',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      agentProvider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => agentProvider.loadAgents(forceRefresh: true),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Stats Summary Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      icon: Icons.people,
                      label: 'Agents',
                      value: '${agentProvider.agents.length}',
                    ),
                    _buildStatItem(
                      icon: Icons.work,
                      label: 'Affectations',
                      value: '${agentProvider.uniqueAffectations.length}',
                    ),
                    _buildStatItem(
                      icon: Icons.filter_list,
                      label: 'Filtrés',
                      value: '${agentProvider.filteredAgents.length}',
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AgentSearchBar(
                  controller: _searchController,
                  onSearch: (query) {
                    agentProvider.searchAgents(query);
                  },
                  onClear: () {
                    _searchController.clear();
                    agentProvider.clearFilters();
                  },
                ),
              ),

              // Filter Chips
              if (agentProvider.uniqueAffectations.isNotEmpty)
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip(
                        'Tous',
                        () => agentProvider.clearFilters(),
                        isSelected: agentProvider.filteredAgents.length == agentProvider.agents.length,
                      ),
                      const SizedBox(width: 8),
                      ...agentProvider.uniqueAffectations.map(
                        (affectation) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _buildFilterChip(
                            affectation,
                            () => agentProvider.filterByAffectation(affectation),
                            isSelected: agentProvider.selectedAffectation == affectation,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Agents List
              Expanded(
                child: agentProvider.filteredAgents.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucun agent trouvé',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: agentProvider.filteredAgents.length,
                        cacheExtent: 1000,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final agent = agentProvider.filteredAgents[index];
                          return AgentCard(
                            key: ValueKey(agent.id),
                            agent: agent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AgentDetailScreen(agent: agent),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String label,
    VoidCallback onTap, {
    bool isSelected = false,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey[200],
      selectedColor: const Color(0xFF1e3c72).withOpacity(0.2),
      checkmarkColor: const Color(0xFF1e3c72),
    );
  }
}
