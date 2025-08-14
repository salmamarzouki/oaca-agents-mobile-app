import 'package:flutter/material.dart';
import 'all_agents_page.dart';
import 'crud_page.dart';
import 'search_page.dart';
import 'agents_table_screen.dart';
import 'test_conditions_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OACA - Gestion des Agents',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF1e3c72),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
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
                
                SizedBox(height: 40),
                
                // Main Menu Cards
                Expanded(
                  child: Column(
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
                      
                      SizedBox(height: 20),
                      
                      // Card 2: Tableau des Agents
                      _buildMenuCard(
                        context: context,
                        icon: Icons.table_chart,
                        title: '📊 Tableau des Agents',
                        subtitle: 'Affichage en tableau avec\nfonctions CRUD',
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgentsTableScreen(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20),

                      // Card 3: CRUD
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
                      
                      SizedBox(height: 20),
                      
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

                      SizedBox(height: 20),

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
                ),
                
                // Footer
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
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
          padding: EdgeInsets.all(20),
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
                padding: EdgeInsets.all(15),
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
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
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
