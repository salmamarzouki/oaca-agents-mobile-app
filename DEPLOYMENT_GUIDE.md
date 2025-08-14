# 🚀 Guide de Déploiement - OACA Agents

## 📱 Application prête pour le déploiement !

Votre application OACA Agents est maintenant compilée et prête à être déployée sur internet.

## 🌐 Options de déploiement GRATUITES

### 1. **Netlify** (Recommandé - Le plus simple)
1. Allez sur https://netlify.com
2. Créez un compte gratuit
3. Glissez-déposez le dossier `build/web` sur Netlify
4. Votre app sera disponible sur : `https://votre-app.netlify.app`

### 2. **Vercel** (Très rapide)
1. Allez sur https://vercel.com
2. Créez un compte gratuit
3. Connectez votre projet GitHub ou uploadez le dossier `build/web`
4. Votre app sera disponible sur : `https://votre-app.vercel.app`

### 3. **Firebase Hosting** (Google)
1. Allez sur https://console.firebase.google.com
2. Créez un nouveau projet
3. Activez Firebase Hosting
4. Uploadez le contenu de `build/web`
5. Votre app sera disponible sur : `https://votre-app.web.app`

### 4. **GitHub Pages** (Si vous avez GitHub)
1. Créez un repository GitHub
2. Uploadez le contenu de `build/web` dans la branche `gh-pages`
3. Activez GitHub Pages
4. Votre app sera disponible sur : `https://username.github.io/repository-name`

## 📂 Fichiers prêts pour le déploiement

- ✅ `build/web/` - Application compilée
- ✅ `netlify.toml` - Configuration Netlify
- ✅ `_redirects` - Redirections pour SPA

## 🔧 Configuration API

⚠️ **IMPORTANT** : Avant le déploiement, vous devez :

1. **Déployer votre API Django** sur :
   - Heroku (gratuit)
   - Railway (gratuit)
   - PythonAnywhere (gratuit)

2. **Modifier l'URL de l'API** dans le code Flutter :
   - Fichier : `lib/services/api_service.dart`
   - Ligne 7 : Changer `http://127.0.0.1:8000` vers votre URL API déployée

## 🎯 Résultat final

Une fois déployé, votre application sera accessible :
- 📱 Sur téléphone (Android/iOS)
- 💻 Sur ordinateur (Windows/Mac/Linux)
- 🌐 Depuis n'importe où dans le monde
- 🔗 Avec un lien permanent comme Facebook/Instagram

## 📞 Support

Si vous avez besoin d'aide pour le déploiement, je peux vous guider étape par étape !
