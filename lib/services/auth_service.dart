import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userDataKey = 'user_data';
  
  // Credentials par défaut (vous pouvez les modifier)
  static const Map<String, Map<String, String>> _validCredentials = {
    'admin@oaca.tn': {
      'password': 'admin123',
      'name': 'Administrateur OACA',
      'role': 'admin',
    },
    'supervisor@oaca.tn': {
      'password': 'super123',
      'name': 'Superviseur',
      'role': 'supervisor',
    },
    'user@oaca.tn': {
      'password': 'user123',
      'name': 'Utilisateur',
      'role': 'user',
    },
  };

  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Obtenir l'utilisateur actuel
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);
    
    if (userData != null) {
      // Ici vous pourriez décoder du JSON si nécessaire
      // Pour simplifier, on retourne un utilisateur par défaut
      return User(
        id: '1',
        email: 'admin@oaca.tn',
        name: 'Administrateur OACA',
        role: 'admin',
      );
    }
    
    return null;
  }

  // Connexion
  static Future<bool> login(String email, String password) async {
    // Vérifier les credentials
    if (_validCredentials.containsKey(email)) {
      final userCredentials = _validCredentials[email]!;
      if (userCredentials['password'] == password) {
        // Sauvegarder l'état de connexion
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_userDataKey, email);
        
        return true;
      }
    }
    
    return false;
  }

  // Déconnexion
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userDataKey);
  }

  // Obtenir les informations utilisateur par email
  static User? getUserByEmail(String email) {
    if (_validCredentials.containsKey(email)) {
      final userCredentials = _validCredentials[email]!;
      return User(
        id: email.hashCode.toString(),
        email: email,
        name: userCredentials['name']!,
        role: userCredentials['role']!,
      );
    }
    return null;
  }
}
