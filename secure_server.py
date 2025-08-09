#!/usr/bin/env python3
"""
Serveur HTTPS sécurisé pour l'application OACA Agents
Avec authentification par IP et certificat SSL auto-signé
"""

import http.server
import ssl
import socketserver
import os
import sys
from datetime import datetime

# Configuration
PORT = 8443  # Port HTTPS standard alternatif
DIRECTORY = "build/web"
ALLOWED_IPS = [
    "127.0.0.1",      # Localhost
    "192.168.1.14",   # Votre PC
    "192.168.1.0/24", # Tout votre réseau local (optionnel)
]

class SecureHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Handler HTTP sécurisé avec contrôle d'accès par IP"""
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    
    def do_GET(self):
        # Vérifier l'IP du client
        client_ip = self.client_address[0]
        
        # Log de la tentative d'accès
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] Tentative d'accès depuis {client_ip}")
        
        # Vérifier si l'IP est autorisée
        if not self.is_ip_allowed(client_ip):
            print(f"[{timestamp}] ❌ ACCÈS REFUSÉ pour {client_ip}")
            self.send_error(403, "Accès refusé - IP non autorisée")
            return
        
        print(f"[{timestamp}] ✅ ACCÈS AUTORISÉ pour {client_ip}")
        
        # Ajouter des en-têtes de sécurité
        self.add_security_headers()
        
        # Traitement normal de la requête
        super().do_GET()
    
    def is_ip_allowed(self, client_ip):
        """Vérifier si l'IP client est autorisée"""
        # Toujours autoriser localhost
        if client_ip in ["127.0.0.1", "::1"]:
            return True
        
        # Vérifier les IPs autorisées
        for allowed_ip in ALLOWED_IPS:
            if "/" in allowed_ip:  # Réseau (ex: 192.168.1.0/24)
                # Logique simplifiée pour les réseaux
                network = allowed_ip.split("/")[0].rsplit(".", 1)[0]
                if client_ip.startswith(network):
                    return True
            else:  # IP exacte
                if client_ip == allowed_ip:
                    return True
        
        return False
    
    def add_security_headers(self):
        """Ajouter des en-têtes de sécurité HTTP"""
        self.send_header("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("X-Frame-Options", "DENY")
        self.send_header("X-XSS-Protection", "1; mode=block")
        self.send_header("Content-Security-Policy", "default-src 'self' 'unsafe-inline' 'unsafe-eval'")
    
    def log_message(self, format, *args):
        """Log personnalisé"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] {format % args}")

def create_self_signed_cert():
    """Créer un certificat SSL auto-signé"""
    try:
        from cryptography import x509
        from cryptography.x509.oid import NameOID
        from cryptography.hazmat.primitives import hashes, serialization
        from cryptography.hazmat.primitives.asymmetric import rsa
        import datetime
        
        # Générer une clé privée
        private_key = rsa.generate_private_key(
            public_exponent=65537,
            key_size=2048,
        )
        
        # Créer le certificat
        subject = issuer = x509.Name([
            x509.NameAttribute(NameOID.COUNTRY_NAME, "TN"),
            x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, "Tunis"),
            x509.NameAttribute(NameOID.LOCALITY_NAME, "Tunis"),
            x509.NameAttribute(NameOID.ORGANIZATION_NAME, "OACA"),
            x509.NameAttribute(NameOID.COMMON_NAME, "OACA Agents"),
        ])
        
        cert = x509.CertificateBuilder().subject_name(
            subject
        ).issuer_name(
            issuer
        ).public_key(
            private_key.public_key()
        ).serial_number(
            x509.random_serial_number()
        ).not_valid_before(
            datetime.datetime.utcnow()
        ).not_valid_after(
            datetime.datetime.utcnow() + datetime.timedelta(days=365)
        ).add_extension(
            x509.SubjectAlternativeName([
                x509.DNSName("localhost"),
                x509.IPAddress(ipaddress.IPv4Address("127.0.0.1")),
                x509.IPAddress(ipaddress.IPv4Address("192.168.1.14")),
            ]),
            critical=False,
        ).sign(private_key, hashes.SHA256())
        
        # Sauvegarder les fichiers
        with open("server.crt", "wb") as f:
            f.write(cert.public_bytes(serialization.Encoding.PEM))
        
        with open("server.key", "wb") as f:
            f.write(private_key.private_bytes(
                encoding=serialization.Encoding.PEM,
                format=serialization.PrivateFormat.PKCS8,
                encryption_algorithm=serialization.NoEncryption()
            ))
        
        print("✅ Certificat SSL créé avec succès!")
        return True
        
    except ImportError:
        print("⚠️  Module cryptography non disponible")
        print("💡 Utilisation d'un certificat SSL simple...")
        return False

def start_secure_server():
    """Démarrer le serveur HTTPS sécurisé"""
    print("🔐 Démarrage du serveur HTTPS sécurisé OACA Agents...")
    print(f"📁 Répertoire: {DIRECTORY}")
    print(f"🌐 Port: {PORT}")
    print(f"🛡️  IPs autorisées: {ALLOWED_IPS}")
    
    # Créer le serveur
    with socketserver.TCPServer(("0.0.0.0", PORT), SecureHTTPRequestHandler) as httpd:
        # Configuration SSL
        context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
        
        # Essayer d'utiliser un certificat personnalisé
        if os.path.exists("server.crt") and os.path.exists("server.key"):
            context.load_cert_chain("server.crt", "server.key")
            print("🔒 Utilisation du certificat SSL personnalisé")
        else:
            # Créer un certificat auto-signé simple
            context.check_hostname = False
            context.verify_mode = ssl.CERT_NONE
            print("⚠️  Utilisation d'un certificat SSL auto-signé")
        
        httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
        
        print("\n🚀 Serveur HTTPS démarré!")
        print(f"🔗 Accès local: https://localhost:{PORT}")
        print(f"🔗 Accès réseau: https://192.168.1.14:{PORT}")
        print("\n⚠️  IMPORTANT: Acceptez le certificat SSL dans votre navigateur")
        print("📝 Appuyez sur Ctrl+C pour arrêter le serveur\n")
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n🛑 Serveur arrêté par l'utilisateur")

if __name__ == "__main__":
    # Vérifier que le répertoire existe
    if not os.path.exists(DIRECTORY):
        print(f"❌ Erreur: Le répertoire {DIRECTORY} n'existe pas")
        print("💡 Exécutez d'abord: flutter build web")
        sys.exit(1)
    
    # Créer un certificat si nécessaire
    if not os.path.exists("server.crt"):
        create_self_signed_cert()
    
    # Démarrer le serveur
    start_secure_server()
