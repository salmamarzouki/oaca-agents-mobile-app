@echo off
color 0A
title OACA Agents - Accès Public Mondial

echo.
echo 🛩️  OACA AGENTS - ACCÈS PUBLIC MONDIAL
echo =====================================
echo.
echo 🎯 OBJECTIF : Rendre votre application accessible depuis n'importe où dans le monde
echo.
echo 🚀 PROCESSUS AUTOMATIQUE EN 3 ÉTAPES :
echo.
echo    📋 ÉTAPE 1 : Création compte ngrok (GRATUIT)
echo    🔧 ÉTAPE 2 : Configuration automatique  
echo    🌍 ÉTAPE 3 : Lancement public
echo.

pause

echo.
echo 📋 ÉTAPE 1/3 : CRÉATION COMPTE NGROK
echo ===================================
echo.
echo 🌐 Ouverture de la page d'inscription...
start https://dashboard.ngrok.com/signup

echo.
echo 📝 INSTRUCTIONS SIMPLES :
echo.
echo    1. ✅ Créez un compte GRATUIT avec votre email
echo    2. ✅ Confirmez votre email si demandé
echo    3. ✅ Connectez-vous à votre compte
echo    4. ✅ Revenez ici et appuyez sur ENTRÉE
echo.

pause

echo.
echo 🔑 RÉCUPÉRATION DU TOKEN...
echo.
echo 🌐 Ouverture de la page du token...
start https://dashboard.ngrok.com/get-started/your-authtoken

echo.
echo 📋 COPIEZ VOTRE TOKEN :
echo.
echo    1. ✅ Sur la page qui s'ouvre, vous verrez votre "authtoken"
echo    2. ✅ Il commence par "2..." et fait environ 50 caractères
echo    3. ✅ Copiez-le ENTIÈREMENT (Ctrl+A puis Ctrl+C)
echo    4. ✅ Revenez ici et collez-le ci-dessous
echo.

set /p authtoken="🔑 Collez votre authtoken ici : "

if "%authtoken%"=="" (
    echo.
    echo ❌ Aucun token fourni !
    echo 💡 Relancez le script après avoir copié votre token
    pause
    exit /b 1
)

echo.
echo 🔧 ÉTAPE 2/3 : CONFIGURATION AUTOMATIQUE
echo =======================================
echo.
echo ⚙️  Configuration de ngrok...

ngrok.exe config add-authtoken %authtoken%

if errorlevel 1 (
    echo ❌ Erreur de configuration
    echo 💡 Vérifiez que le token est correct et complet
    pause
    exit /b 1
)

echo ✅ Configuration réussie !

echo.
echo 🚀 ÉTAPE 3/3 : LANCEMENT PUBLIC
echo ==============================
echo.
echo 🔄 Arrêt des anciens processus...
taskkill /f /im python.exe 2>nul
taskkill /f /im ngrok.exe 2>nul

echo 🚀 Démarrage du serveur local...
start /B python simple_public_server.py

echo ⏳ Attente du démarrage (5 secondes)...
timeout /t 5 /nobreak >nul

echo.
echo 🌍 CRÉATION DU TUNNEL PUBLIC...
echo.
echo ⚠️  IMPORTANT : Votre application sera accessible depuis N'IMPORTE OÙ !
echo 📱 L'URL publique sera affichée ci-dessous...
echo 🔐 Identifiants : admin@oaca.tn / admin123
echo.
echo 🎉 VOTRE APPLICATION EST MAINTENANT PUBLIQUE !
echo.

REM Lancer ngrok et garder la fenêtre ouverte
ngrok.exe http 8080
