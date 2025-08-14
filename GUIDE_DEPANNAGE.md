# Guide de Dépannage - Erreur de Connexion

## Problème Rencontré
L'application Flutter affiche l'erreur : `ClientException: failed to fetch, uri=http://10.0.2.2:8000/mobile-api/agents/`

## Solutions à Essayer

### 1. Vérifier que le Serveur Django est Démarré

**Étape 1 : Démarrer le serveur Django**
```bash
cd backend/django_api
python manage.py runserver
```

**Vérification :** Vous devriez voir :
```
Starting development server at http://127.0.0.1:8000/
```

### 2. Tester l'API Manuellement

**Dans votre navigateur, allez à :**
- `http://127.0.0.1:8000/mobile-api/agents/`
- `http://localhost:8000/mobile-api/agents/`

**Vous devriez voir une réponse JSON comme :**
```json
{
  "count": 0,
  "agents": []
}
```

### 3. Problèmes de Réseau selon l'Appareil

#### Pour Émulateur Android :
- URL correcte : `http://10.0.2.2:8000/mobile-api/agents/`
- L'émulateur Android utilise `10.0.2.2` pour accéder à `localhost` de l'ordinateur hôte

#### Pour Simulateur iOS :
- URL correcte : `http://127.0.0.1:8000/mobile-api/agents/`

#### Pour Appareil Physique :
- Trouvez l'adresse IP de votre ordinateur : `ipconfig` (Windows) ou `ifconfig` (Mac/Linux)
- URL : `http://[VOTRE_IP]:8000/mobile-api/agents/`
- Exemple : `http://192.168.1.100:8000/mobile-api/agents/`

### 4. Modifications Apportées au Code

J'ai amélioré le code Flutter pour essayer plusieurs URLs automatiquement :

```dart
List<String> urls = [
  'http://10.0.2.2:8000/mobile-api/agents/',      // Émulateur Android
  'http://127.0.0.1:8000/mobile-api/agents/',     // Simulateur iOS
  'http://localhost:8000/mobile-api/agents/',     // Fallback
];
```

### 5. Vérifications Supplémentaires

#### A. Vérifier les Migrations Django
```bash
cd backend/django_api
python manage.py makemigrations
python manage.py migrate
```

#### B. Vérifier les URLs Django
Dans `backend/django_api/agent/urls.py`, assurez-vous d'avoir :
```python
urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('agents.urls')),
]
```

#### C. Vérifier CORS (Cross-Origin Resource Sharing)
Dans `backend/django_api/agent/settings.py`, vérifiez :
```python
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://10.0.2.2:8000",
]

CORS_ALLOW_ALL_ORIGINS = True  # Pour le développement seulement
```

### 6. Test Manuel de l'API

**Créez un fichier test simple :**
```python
import requests

try:
    response = requests.get('http://127.0.0.1:8000/mobile-api/agents/')
    print(f"Status: {response.status_code}")
    print(f"Data: {response.json()}")
except Exception as e:
    print(f"Erreur: {e}")
```

### 7. Logs de Debug

**Dans l'application Flutter, vérifiez les logs :**
- Ouvrez la console de debug Flutter
- Recherchez les messages `print()` que j'ai ajoutés :
  - `Tentative de connexion à: [URL]`
  - `Connexion réussie avec: [URL]`
  - `Échec avec [URL]: [erreur]`

### 8. Solutions Alternatives

#### Option A : Utiliser un Serveur de Test
Si le problème persiste, créez des données de test locales :

```dart
// Dans loadAirports(), ajoutez en fallback :
if (response == null) {
  // Données de test
  setState(() {
    airports = ['Tunis-Carthage', 'Monastir', 'Djerba', 'Sfax'];
    airportCounts = {'Tunis-Carthage': 10, 'Monastir': 5, 'Djerba': 8, 'Sfax': 3};
    isLoading = false;
  });
  return;
}
```

#### Option B : Changer le Port Django
Si le port 8000 est occupé :
```bash
python manage.py runserver 8080
```
Puis modifiez les URLs dans Flutter.

### 9. Checklist de Dépannage

- [ ] Serveur Django démarré et accessible
- [ ] URL testée dans le navigateur
- [ ] Migrations Django appliquées
- [ ] CORS configuré correctement
- [ ] Bon type d'appareil/émulateur utilisé
- [ ] Firewall/antivirus ne bloque pas le port 8000
- [ ] Logs Flutter vérifiés

### 10. Commandes de Diagnostic

**Vérifier si le port 8000 est utilisé :**
```bash
# Windows
netstat -an | findstr :8000

# Mac/Linux
lsof -i :8000
```

**Tester la connectivité réseau :**
```bash
# Ping de l'émulateur vers l'hôte
ping 10.0.2.2
```

## Contact et Support

Si le problème persiste après avoir essayé ces solutions :

1. Vérifiez les logs complets de Django et Flutter
2. Testez avec un navigateur web d'abord
3. Essayez avec un appareil physique si l'émulateur ne fonctionne pas
4. Vérifiez la configuration réseau de votre système

L'application a été modifiée pour être plus robuste et essayer plusieurs URLs automatiquement, donc elle devrait fonctionner une fois que le serveur Django est correctement configuré et accessible.
