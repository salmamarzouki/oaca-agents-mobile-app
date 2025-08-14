@echo off
color 0A
echo.
echo 🌍 OACA AGENTS - ACCÈS PUBLIC MONDIAL AUTOMATIQUE
echo ================================================
echo.
echo 🚀 Je vais tout configurer automatiquement pour vous !
echo.
echo 📋 ÉTAPES AUTOMATIQUES :
echo    1. ✅ Vérification de ngrok
echo    2. 🌐 Ouverture de la page d'inscription
echo    3. ⏳ Attente de votre token
echo    4. 🔧 Configuration automatique
echo    5. 🚀 Lancement du serveur public
echo.

REM Vérifier si ngrok existe
if not exist "ngrok.exe" (
    echo ❌ ngrok.exe non trouvé
    echo 📥 Téléchargement automatique...
    powershell -Command "Invoke-WebRequest -Uri 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip' -OutFile 'ngrok.zip'"
    powershell -Command "Expand-Archive -Path 'ngrok.zip' -DestinationPath '.' -Force"
    del ngrok.zip
    echo ✅ ngrok téléchargé !
)

echo.
echo 🌐 Ouverture de la page d'inscription ngrok...
start https://dashboard.ngrok.com/signup
echo.
echo 📝 INSTRUCTIONS :
echo    1. Créez un compte GRATUIT (utilisez votre email)
echo    2. Allez dans "Your Authtoken" : https://dashboard.ngrok.com/get-started/your-authtoken
echo    3. Copiez le token qui commence par "2..."
echo    4. Revenez ici et collez-le
echo.

set /p authtoken="🔑 Collez votre authtoken ngrok ici : "

if "%authtoken%"=="" (
    echo ❌ Aucun token fourni
    echo 💡 Relancez le script après avoir créé votre compte
    pause
    exit /b 1
)

echo.
echo 🔧 Configuration automatique de ngrok...
ngrok.exe config add-authtoken %authtoken%

if errorlevel 1 (
    echo ❌ Erreur de configuration du token
    echo 💡 Vérifiez que le token est correct
    pause
    exit /b 1
)

echo ✅ ngrok configuré avec succès!
echo.
echo 🚀 Démarrage du serveur local...

REM Tuer les anciens processus
taskkill /f /im python.exe 2>nul
taskkill /f /im ngrok.exe 2>nul

REM Démarrer le serveur local en arrière-plan
start /B python simple_public_server.py

REM Attendre que le serveur démarre
echo ⏳ Attente du démarrage du serveur...
timeout /t 5 /nobreak >nul

echo.
echo 🌍 Création du tunnel public...
echo ⚠️  Votre application sera accessible depuis N'IMPORTE OÙ dans le monde!
echo 📱 L'URL sera affichée ci-dessous...
echo.

REM Créer le tunnel public
ngrok.exe http 8080
