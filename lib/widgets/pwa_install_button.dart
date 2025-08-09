import 'package:flutter/material.dart';
import 'dart:html' as html;

class PWAInstallButton extends StatefulWidget {
  const PWAInstallButton({super.key});

  @override
  State<PWAInstallButton> createState() => _PWAInstallButtonState();
}

class _PWAInstallButtonState extends State<PWAInstallButton> {
  bool _canInstall = false;
  bool _isInstalled = false;

  @override
  void initState() {
    super.initState();
    _checkInstallability();
  }

  void _checkInstallability() {
    // Vérifier si l'application peut être installée
    try {
      // Vérifier si l'app est déjà installée
      final isStandalone = html.window.matchMedia('(display-mode: standalone)').matches;
      final isInWebAppiOS = html.window.navigator.userAgent.contains('Mobile') && 
                           html.window.navigator.userAgent.contains('Safari') &&
                           !html.window.navigator.userAgent.contains('Chrome');
      
      setState(() {
        _isInstalled = isStandalone || isInWebAppiOS;
        _canInstall = !_isInstalled;
      });

      // Écouter l'événement beforeinstallprompt
      html.window.addEventListener('beforeinstallprompt', (event) {
        event.preventDefault();
        setState(() {
          _canInstall = true;
        });
      });

    } catch (e) {
      print('Erreur lors de la vérification de l\'installabilité: $e');
    }
  }

  void _showInstallInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.install_mobile, color: Color(0xFF1e3c72)),
              SizedBox(width: 10),
              Text('Installer OACA Agents'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pour installer cette application sur votre appareil :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              
              // Instructions pour Chrome/Edge
              _buildInstructionStep(
                '💻 Sur PC (Chrome/Edge)',
                [
                  '1. Cliquez sur l\'icône d\'installation dans la barre d\'adresse',
                  '2. Ou Menu → Installer OACA Agents',
                  '3. Confirmez l\'installation'
                ],
              ),
              
              SizedBox(height: 15),
              
              // Instructions pour mobile
              _buildInstructionStep(
                '📱 Sur Mobile',
                [
                  'Android: Menu → Ajouter à l\'écran d\'accueil',
                  'iPhone: Partager → Sur l\'écran d\'accueil'
                ],
              ),
              
              SizedBox(height: 15),
              
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Une fois installée, l\'app fonctionnera comme une application native !',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _triggerInstall();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1e3c72),
                foregroundColor: Colors.white,
              ),
              child: Text('Installer maintenant'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstructionStep(String title, List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1e3c72),
          ),
        ),
        SizedBox(height: 5),
        ...steps.map((step) => Padding(
          padding: EdgeInsets.only(left: 10, bottom: 2),
          child: Text(
            step,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        )).toList(),
      ],
    );
  }

  void _triggerInstall() {
    try {
      // Déclencher l'installation PWA
      html.window.dispatchEvent(html.CustomEvent('install-prompt'));
    } catch (e) {
      print('Erreur lors du déclenchement de l\'installation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInstalled) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 16),
            SizedBox(width: 4),
            Text(
              'Installée',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (!_canInstall) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton.icon(
        onPressed: _showInstallInstructions,
        icon: Icon(Icons.install_mobile, size: 18),
        label: Text(
          'Installer',
          style: TextStyle(fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1e3c72),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
