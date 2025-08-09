import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        // Navigation sera gérée par le main.dart
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo OACA Officiel
                        Container(
                          height: 100,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo stylisé OACA
                              Container(
                                height: 40,
                                width: 80,
                                child: CustomPaint(
                                  painter: OacaOfficialLogoPainter(),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Texte arabe
                              Text(
                                'ديوان الطيران المدني والمطارات',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFF2980B9),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2),
                              // Texte français
                              Text(
                                'OFFICE DE L\'AVIATION CIVILE',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: Color(0xFF3498DB),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'ET DES AÉROPORTS',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: Color(0xFF3498DB),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'OACA Agents',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1e3c72),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Gestion des Agents de Contrôle Aérien',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32),

                        // Champ Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez saisir votre email';
                            }
                            if (!value.contains('@')) {
                              return 'Veuillez saisir un email valide';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Champ Mot de passe
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),

                        // Message d'erreur
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            if (authProvider.errorMessage != null) {
                              return Container(
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error, color: Colors.red, size: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authProvider.errorMessage!,
                                        style: TextStyle(color: Colors.red[700]),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),

                        // Bouton de connexion
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: authProvider.isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1e3c72),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: authProvider.isLoading
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      )
                                    : Text(
                                        'Se connecter',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OacaOfficialLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Couleurs du logo OACA officiel
    final blueMain = Color(0xFF2980B9);
    final blueLight = Color(0xFF3498DB);
    final blueDark = Color(0xFF1F618D);

    // Dessiner les courbes stylisées du logo OACA
    paint.color = blueMain;
    paint.style = PaintingStyle.stroke;

    // Courbe principale (arc supérieur)
    final rect1 = Rect.fromLTWH(size.width * 0.1, size.height * 0.2, size.width * 0.4, size.height * 0.4);
    canvas.drawArc(rect1, 0, 3.14159, false, paint);

    // Courbe intérieure
    paint.color = blueLight;
    paint.strokeWidth = 1.5;
    final rect2 = Rect.fromLTWH(size.width * 0.15, size.height * 0.25, size.width * 0.3, size.height * 0.3);
    canvas.drawArc(rect2, 0, 1.5708, false, paint);

    // Courbe spirale
    paint.color = blueDark;
    paint.strokeWidth = 1.0;
    final rect3 = Rect.fromLTWH(size.width * 0.2, size.height * 0.3, size.width * 0.2, size.height * 0.2);
    canvas.drawArc(rect3, 1.5708, 3.14159, false, paint);

    // Lignes horizontales représentant l'aviation
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;
    paint.color = blueMain;

    // Ligne principale
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.3),
      paint,
    );

    // Lignes secondaires
    paint.strokeWidth = 1.5;
    paint.color = blueLight;
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.4),
      Offset(size.width * 0.85, size.height * 0.4),
      paint,
    );

    paint.strokeWidth = 1.0;
    paint.color = blueDark;
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
