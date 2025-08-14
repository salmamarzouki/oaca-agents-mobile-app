@echo off
echo.
echo 🛩️  OACA AGENTS - LANCEMENT PUBLIC
echo ================================
echo 🌍 Application accessible depuis N'IMPORTE QUEL APPAREIL dans le monde!
echo.

REM Vérifier si Flutter est installé
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter non trouvé
    echo 💡 Installez Flutter depuis: https://flutter.dev
    pause
    exit /b 1
)

echo ✅ Flutter trouvé!
echo.

REM Construire l'application pour le web
echo 🔨 Construction de l'application...
echo ⏳ Cela peut prendre quelques minutes...
flutter build web --web-renderer html --release

if errorlevel 1 (
    echo ❌ Erreur lors de la construction
    pause
    exit /b 1
)

echo ✅ Application construite avec succès!
echo.

REM Lancer le serveur public
echo 🚀 Lancement du serveur HTTPS public...
python public_https_server.py

pause
