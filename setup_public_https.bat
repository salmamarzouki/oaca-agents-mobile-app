@echo off
echo.
echo 🌐 CONFIGURATION SERVEUR HTTPS PUBLIC - OACA AGENTS
echo ===================================================
echo.
echo 📱 Cette application sera accessible depuis N'IMPORTE QUEL APPAREIL dans le monde !
echo.

REM Vérifier si ngrok existe
if exist "ngrok.exe" (
    echo ✅ ngrok trouvé !
    goto :start_server
)

echo 📥 Téléchargement de ngrok...
echo.
echo 💡 Ngrok permet d'exposer votre application sur Internet avec HTTPS automatique
echo.

REM Télécharger ngrok pour Windows
powershell -Command "& {Invoke-WebRequest -Uri 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip' -OutFile 'ngrok.zip'}"

if exist "ngrok.zip" (
    echo ✅ Téléchargement terminé !
    echo 📦 Extraction...
    powershell -Command "& {Expand-Archive -Path 'ngrok.zip' -DestinationPath '.' -Force}"
    del ngrok.zip
    echo ✅ ngrok installé !
) else (
    echo ❌ Erreur de téléchargement
    echo 💡 Téléchargez manuellement depuis: https://ngrok.com/download
    pause
    exit /b 1
)

:start_server
echo.
echo 🚀 DÉMARRAGE DU SERVEUR PUBLIC...
echo.

REM Démarrer le serveur local d'abord
echo 📂 Démarrage du serveur local...
start /B python -m http.server 8080

REM Attendre que le serveur démarre
timeout /t 3 /nobreak >nul

echo 🌐 Création du tunnel HTTPS public...
echo.
echo ⚠️  IMPORTANT: 
echo    - L'URL générée sera accessible depuis N'IMPORTE QUEL APPAREIL
echo    - Partagez cette URL avec qui vous voulez
echo    - L'URL change à chaque redémarrage (version gratuite)
echo.

REM Démarrer ngrok
ngrok.exe http 8080

echo.
echo 🛑 Serveur arrêté
pause
