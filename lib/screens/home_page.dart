import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/agent_provider.dart';
import '../widgets/pwa_install_button.dart';
import 'all_agents_page.dart';
import 'crud_page.dart';
import 'search_page.dart';
import 'test_conditions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();

    // Charger les agents au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AgentProvider>(context, listen: false).loadAgents();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OACA - Gestion des Agents',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1e3c72),
        centerTitle: true,
        actions: [
          // Bouton d'installation PWA
          const PWAInstallButton(),
          // Bouton de déconnexion
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              // La navigation sera gérée automatiquement par AuthWrapper
            },
            tooltip: 'Se déconnecter',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Accueil'),
            Tab(icon: Icon(Icons.people), text: 'Agents'),
            Tab(icon: Icon(Icons.edit), text: 'CRUD'),
            Tab(icon: Icon(Icons.search), text: 'Recherche'),
          ],
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.animateTo(index);
        },
        children: [
          // Page 1: Accueil
          _buildHomePage(),
          // Page 2: Agents
          const AllAgentsPage(),
          // Page 3: CRUD
          const CrudPage(),
          // Page 4: Recherche
          const SearchPage(),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1e3c72),
            Color(0xFF2a5298),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      children: [
                        Text(
                          'ديوان الطيران المدني والمطارات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'OFFICE DE L\'AVIATION CIVILE ET DES AÉROPORTS',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Text(
                          '🎯 Objectif : Gérer et afficher les agents affectés aux aéroports',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Main Menu Cards
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Card 1: Tous les agents
                      _buildMenuCard(
                        context: context,
                        icon: Icons.people,
                        title: '🧑‍✈️ Tous les agents',
                        subtitle: 'Liste alphabétique des aéroports\net agents affectés',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllAgentsPage(),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Card 2: CRUD
                      _buildMenuCard(
                        context: context,
                        icon: Icons.build,
                        title: '🛠️ CRUD',
                        subtitle: 'Ajouter, Modifier, Supprimer\ndes agents',
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CrudPage(),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Card 3: Rechercher
                      _buildMenuCard(
                        context: context,
                        icon: Icons.search,
                        title: '🔍 Rechercher',
                        subtitle: 'Recherche par nom, prénom,\nfonction ou aéroport',
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Card 4: Démo Conditions
                      _buildMenuCard(
                        context: context,
                        icon: Icons.science,
                        title: '🎯 Conditions Agent',
                        subtitle: 'Tester les conditions et\nfonctions éligibles',
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestConditionsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Footer
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Données importées depuis fichiers Excel',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
