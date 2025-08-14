#!/usr/bin/env python3
"""
🌐 Serveur HTTPS Public Simple pour OACA Agents
Alternative sans inscription - Accessible depuis n'importe où
"""

import http.server
import socketserver
import threading
import time
import os
import socket
import webbrowser
from datetime import datetime

# Configuration
PORT = 8080
DIRECTORY = "build/web"

class OACAHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Handler HTTP personnalisé pour OACA Agents"""
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    
    def end_headers(self):
        # Ajouter des en-têtes CORS et de sécurité
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()
    
    def log_message(self, format, *args):
        """Log personnalisé avec timestamp et IP"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        client_ip = self.client_address[0]
        print(f"[{timestamp}] 📱 {client_ip} - {format % args}")

def get_local_ip():
    """Obtenir l'adresse IP locale"""
    try:
        # Créer une socket pour obtenir l'IP locale
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        return local_ip
    except:
        return "127.0.0.1"

def get_public_ip():
    """Obtenir l'adresse IP publique"""
    try:
        import urllib.request
        response = urllib.request.urlopen('https://api.ipify.org', timeout=5)
        return response.read().decode('utf-8')
    except:
        return "Non disponible"

def generate_qr_code(url):
    """Générer un QR code pour l'URL"""
    try:
        import qrcode
        from io import BytesIO
        import base64
        
        qr = qrcode.QRCode(version=1, box_size=10, border=5)
        qr.add_data(url)
        qr.make(fit=True)
        
        img = qr.make_image(fill_color="black", back_color="white")
        buffer = BytesIO()
        img.save(buffer, format='PNG')
        img_str = base64.b64encode(buffer.getvalue()).decode()
        
        return f"data:image/png;base64,{img_str}"
    except ImportError:
        return None

def create_info_page(local_ip, public_ip):
    """Créer une page d'information avec les URLs d'accès"""
    qr_data = generate_qr_code(f"http://{local_ip}:{PORT}")
    qr_html = f'<img src="{qr_data}" alt="QR Code" style="max-width: 200px;">' if qr_data else ""
    
    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>OACA Agents - Informations d'accès</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {{ font-family: Arial, sans-serif; margin: 40px; background: linear-gradient(135deg, #1e3c72, #2a5298); color: white; }}
            .container {{ max-width: 800px; margin: 0 auto; background: rgba(255,255,255,0.1); padding: 30px; border-radius: 15px; }}
            h1 {{ text-align: center; color: #fff; }}
            .info-box {{ background: rgba(255,255,255,0.2); padding: 20px; margin: 20px 0; border-radius: 10px; }}
            .url {{ font-size: 18px; font-weight: bold; color: #ffeb3b; word-break: break-all; }}
            .qr-code {{ text-align: center; margin: 20px 0; }}
            .warning {{ background: rgba(255,193,7,0.2); border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; }}
            .success {{ background: rgba(76,175,80,0.2); border-left: 4px solid #4caf50; padding: 15px; margin: 20px 0; }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🛩️ OACA Agents - Serveur Actif</h1>
            
            <div class="success">
                <h3>✅ Application démarrée avec succès!</h3>
                <p>L'application OACA Agents est maintenant accessible.</p>
            </div>
            
            <div class="info-box">
                <h3>🏠 Accès Local</h3>
                <p>Depuis votre ordinateur :</p>
                <div class="url">http://localhost:{PORT}</div>
            </div>
            
            <div class="info-box">
                <h3>📱 Accès Réseau Local</h3>
                <p>Depuis d'autres appareils sur votre réseau WiFi :</p>
                <div class="url">http://{local_ip}:{PORT}</div>
                {qr_html}
                <p><small>Scannez le QR code avec votre téléphone</small></p>
            </div>
            
            <div class="info-box">
                <h3>🌍 Votre IP Publique</h3>
                <p>IP publique de votre connexion : <strong>{public_ip}</strong></p>
            </div>
            
            <div class="warning">
                <h3>⚠️ Accès depuis Internet</h3>
                <p>Pour un accès depuis Internet, vous devez :</p>
                <ul>
                    <li>Configurer le port forwarding sur votre routeur (port {PORT})</li>
                    <li>Ou utiliser un service comme ngrok (gratuit avec inscription)</li>
                    <li>Ou déployer sur un service cloud</li>
                </ul>
            </div>
            
            <div class="info-box">
                <h3>🔐 Identifiants de connexion</h3>
                <p><strong>Administrateur :</strong></p>
                <p>Email: admin@oaca.tn</p>
                <p>Mot de passe: admin123</p>
            </div>
            
            <div style="text-align: center; margin-top: 30px;">
                <a href="/" style="background: #4caf50; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-size: 18px;">
                    🚀 Accéder à l'Application
                </a>
            </div>
        </div>
    </body>
    </html>
    """
    
    # Sauvegarder la page d'info
    with open(os.path.join(DIRECTORY, "info.html"), "w", encoding="utf-8") as f:
        f.write(html)

def main():
    """Fonction principale"""
    print("🛩️  OACA AGENTS - SERVEUR PUBLIC SIMPLE")
    print("=" * 50)
    
    # Vérifier que le répertoire build/web existe
    if not os.path.exists(DIRECTORY):
        print(f"❌ Erreur: Le répertoire {DIRECTORY} n'existe pas")
        print("💡 Construisez d'abord l'application avec: flutter build web")
        return
    
    # Obtenir les adresses IP
    local_ip = get_local_ip()
    public_ip = get_public_ip()
    
    # Créer la page d'information
    create_info_page(local_ip, public_ip)
    
    print(f"🌐 Adresse IP locale: {local_ip}")
    print(f"🌍 Adresse IP publique: {public_ip}")
    print()
    
    # Démarrer le serveur
    try:
        with socketserver.TCPServer(("0.0.0.0", PORT), OACAHTTPRequestHandler) as httpd:
            print(f"🚀 Serveur démarré sur le port {PORT}")
            print()
            print("📱 ACCÈS À L'APPLICATION :")
            print(f"   🏠 Local: http://localhost:{PORT}")
            print(f"   📱 Réseau: http://{local_ip}:{PORT}")
            print(f"   ℹ️  Infos: http://localhost:{PORT}/info.html")
            print()
            print("🔐 IDENTIFIANTS :")
            print("   Email: admin@oaca.tn")
            print("   Mot de passe: admin123")
            print()
            print("⚠️  Pour un accès Internet, configurez le port forwarding ou utilisez ngrok")
            print("🛑 Appuyez sur Ctrl+C pour arrêter")
            print()
            
            # Ouvrir automatiquement dans le navigateur
            webbrowser.open(f"http://localhost:{PORT}/info.html")
            
            httpd.serve_forever()
            
    except KeyboardInterrupt:
        print("\n🛑 Serveur arrêté par l'utilisateur")
    except Exception as e:
        print(f"\n❌ Erreur: {e}")

if __name__ == "__main__":
    main()
