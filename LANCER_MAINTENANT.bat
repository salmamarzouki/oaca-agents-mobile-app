@echo off
title 🌍 OACA AGENTS - CONFIGURATION PUBLIQUE
color 0A
mode con: cols=80 lines=30

REM Changer vers le répertoire du script
cd /d "%~dp0"

echo.
echo ===============================================
echo 🛩️  OACA AGENTS - ACCÈS PUBLIC MONDIAL
echo ===============================================
echo.
echo 🎯 Votre token ngrok est prêt !
echo.
echo Token à utiliser : 31HL4t6s9uFLnyfCQFEY7YCqqw9_2QX5cRP2CjTKSp38cDeWl
echo.
echo 🔧 Configuration automatique...
echo.

REM Configuration directe avec le token
ngrok.exe config add-authtoken 31HL4t6s9uFLnyfCQFEY7YCqqw9_2QX5cRP2CjTKSp38cDeWl

if errorlevel 1 (
    echo ❌ Erreur de configuration
    pause
    exit /b 1
)

echo ✅ ngrok configuré avec succès !
echo.
echo 🚀 Démarrage du serveur local...

REM Arrêter les anciens processus
taskkill /f /im python.exe 2>nul
taskkill /f /im ngrok.exe 2>nul

REM Démarrer le serveur
start /B python simple_public_server.py

echo ⏳ Attente du démarrage (2 secondes)...
timeout /t 2 /nobreak >nul

echo.
echo 🌍 CRÉATION DU TUNNEL PUBLIC...
echo.
echo ⚠️  Votre application sera accessible depuis N'IMPORTE OÙ !
echo 🔐 Identifiants : admin@oaca.tn / admin123
echo.
echo 🎉 LANCEMENT EN COURS...
echo.

REM Lancer ngrok
ngrok.exe http 8080
