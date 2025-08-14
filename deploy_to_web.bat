@echo off
echo 🚀 Déploiement OACA Agents sur le Web
echo =====================================

echo 📦 Compilation de l'application...
flutter build web --release

echo ✅ Compilation terminée !
echo.
echo 📂 Fichiers prêts dans : build\web\
echo.
echo 🌐 Options de déploiement :
echo.
echo 1. NETLIFY (Recommandé)
echo    - Allez sur https://netlify.com
echo    - Glissez-déposez le dossier build\web
echo    - Votre app sera en ligne en 2 minutes !
echo.
echo 2. VERCEL
echo    - Allez sur https://vercel.com
echo    - Uploadez le dossier build\web
echo.
echo 3. FIREBASE
echo    - Allez sur https://console.firebase.google.com
echo    - Créez un projet et activez Hosting
echo.
echo 📱 Une fois déployé, votre app sera accessible partout !
echo.
pause
