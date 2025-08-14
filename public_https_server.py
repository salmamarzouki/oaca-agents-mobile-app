#!/usr/bin/env python3
"""
🌐 Serveur HTTPS Public pour OACA Agents
Accessible depuis N'IMPORTE QUEL APPAREIL dans le monde
"""

import http.server
import socketserver
import subprocess
import threading
import time
import os
import sys
import webbrowser
from pathlib import Path

# Configuration
LOCAL_PORT = 8080
DIRECTORY = "build/web"

class OACAHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Handler HTTP personnalisé pour OACA Agents"""
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    
    def end_headers(self):
        # Ajouter des en-têtes CORS pour permettre l'accès depuis n'importe où
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        super().end_headers()
    
    def log_message(self, format, *args):
        """Log personnalisé avec timestamp"""
        import datetime
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] {format % args}")

def check_ngrok():
    """Vérifier si ngrok est installé"""
    try:
        result = subprocess.run(['ngrok', 'version'], 
                              capture_output=True, text=True, timeout=5)
        return result.returncode == 0
    except:
        return False

def install_ngrok():
    """Installer ngrok automatiquement"""
    print("📥 Installation de ngrok...")
    
    try:
        # Télécharger ngrok
        import urllib.request
        import zipfile
        
        url = "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip"
        print("⬇️  Téléchargement...")
        urllib.request.urlretrieve(url, "ngrok.zip")
        
        # Extraire
        print("📦 Extraction...")
        with zipfile.ZipFile("ngrok.zip", 'r') as zip_ref:
            zip_ref.extractall(".")
        
        os.remove("ngrok.zip")
        print("✅ ngrok installé avec succès!")
        return True
        
    except Exception as e:
        print(f"❌ Erreur lors de l'installation: {e}")
        print("💡 Téléchargez manuellement depuis: https://ngrok.com/download")
        return False

def start_local_server():
    """Démarrer le serveur local"""
    print(f"🚀 Démarrage du serveur local sur le port {LOCAL_PORT}...")
    
    with socketserver.TCPServer(("", LOCAL_PORT), OACAHTTPRequestHandler) as httpd:
        print(f"✅ Serveur local démarré: http://localhost:{LOCAL_PORT}")
        httpd.serve_forever()

def start_ngrok():
    """Démarrer ngrok pour exposer le serveur"""
    time.sleep(2)  # Attendre que le serveur local démarre
    
    print("🌐 Création du tunnel HTTPS public...")
    
    try:
        # Démarrer ngrok
        if os.path.exists("ngrok.exe"):
            cmd = ["./ngrok.exe", "http", str(LOCAL_PORT)]
        else:
            cmd = ["ngrok", "http", str(LOCAL_PORT)]
            
        process = subprocess.Popen(cmd)
        
        # Attendre un peu pour que ngrok démarre
        time.sleep(3)
        
        # Essayer de récupérer l'URL publique
        try:
            import requests
            response = requests.get("http://localhost:4040/api/tunnels")
            data = response.json()
            
            if data.get("tunnels"):
                public_url = data["tunnels"][0]["public_url"]
                print(f"\n🎉 APPLICATION ACCESSIBLE PUBLIQUEMENT!")
                print(f"🔗 URL PUBLIQUE: {public_url}")
                print(f"📱 Partagez cette URL avec N'IMPORTE QUI dans le monde!")
                print(f"🌍 Accessible depuis mobile, tablette, ordinateur...")
                
                # Ouvrir automatiquement dans le navigateur
                webbrowser.open(public_url)
                
        except:
            print("\n🌐 Tunnel ngrok créé!")
            print("📋 Consultez http://localhost:4040 pour voir l'URL publique")
        
        return process
        
    except Exception as e:
        print(f"❌ Erreur ngrok: {e}")
        return None

def main():
    """Fonction principale"""
    print("🛩️  OACA AGENTS - SERVEUR HTTPS PUBLIC")
    print("=" * 50)
    print("🌍 Application accessible depuis N'IMPORTE QUEL APPAREIL dans le monde!")
    print()
    
    # Vérifier que le répertoire build/web existe
    if not os.path.exists(DIRECTORY):
        print(f"❌ Erreur: Le répertoire {DIRECTORY} n'existe pas")
        print("💡 Construisez d'abord l'application avec: flutter build web")
        return
    
    # Vérifier/installer ngrok
    if not check_ngrok():
        print("⚠️  ngrok non trouvé")
        if not install_ngrok():
            return
    
    print("✅ ngrok prêt!")
    print()
    
    try:
        # Démarrer ngrok dans un thread séparé
        ngrok_thread = threading.Thread(target=start_ngrok)
        ngrok_thread.daemon = True
        ngrok_thread.start()
        
        # Démarrer le serveur local (bloquant)
        start_local_server()
        
    except KeyboardInterrupt:
        print("\n🛑 Serveur arrêté par l'utilisateur")
    except Exception as e:
        print(f"\n❌ Erreur: {e}")

if __name__ == "__main__":
    main()
