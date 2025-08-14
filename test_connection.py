#!/usr/bin/env python3
"""
Script de test pour vérifier la connexion à l'API Django
"""
import requests
import json

def test_api_connection():
    """Test de connexion à l'API"""
    
    urls_to_test = [
        'http://127.0.0.1:8000/mobile-api/agents/',
        'http://localhost:8000/mobile-api/agents/',
        'http://10.0.2.2:8000/mobile-api/agents/',
    ]
    
    print("Test de connexion à l'API Django")
    print("=" * 40)
    
    for url in urls_to_test:
        print(f"\nTest de: {url}")
        try:
            response = requests.get(url, timeout=5)
            print(f"Status: {response.status_code}")
            
            if response.status_code == 200:
                data = response.json()
                agent_count = data.get('count', 0)
                print(f"✅ Succès! {agent_count} agents trouvés")
                
                # Afficher quelques exemples d'affectations pour debug
                agents = data.get('agents', [])
                if agents:
                    print("\nExemples d'affectations:")
                    for i, agent in enumerate(agents[:5]):
                        affectation = agent.get('affectation', 'N/A')
                        print(f"  {i+1}. {affectation}")
                
                return True
            else:
                print(f"❌ Erreur HTTP: {response.status_code}")
                
        except requests.exceptions.ConnectionError:
            print("❌ Erreur de connexion - Serveur non accessible")
        except requests.exceptions.Timeout:
            print("❌ Timeout - Serveur trop lent")
        except Exception as e:
            print(f"❌ Erreur: {e}")
    
    print("\n❌ Aucune URL ne fonctionne!")
    print("\nVérifiez que:")
    print("1. Le serveur Django est démarré (python manage.py runserver)")
    print("2. Le serveur écoute sur le port 8000")
    print("3. L'endpoint /mobile-api/agents/ existe")
    
    return False

def check_django_server():
    """Vérifier si le serveur Django est accessible"""
    print("\nVérification du serveur Django...")
    
    try:
        response = requests.get('http://127.0.0.1:8000/', timeout=5)
        print(f"✅ Serveur Django accessible (Status: {response.status_code})")
        return True
    except:
        print("❌ Serveur Django non accessible")
        return False

if __name__ == '__main__':
    # Test de base du serveur
    server_ok = check_django_server()
    
    if server_ok:
        # Test de l'API
        api_ok = test_api_connection()
        
        if api_ok:
            print("\n🎉 Tout fonctionne correctement!")
            print("Vous pouvez maintenant utiliser l'application Flutter.")
        else:
            print("\n⚠️  Le serveur fonctionne mais l'API a des problèmes.")
    else:
        print("\n⚠️  Démarrez d'abord le serveur Django:")
        print("cd backend/django_api")
        print("python manage.py runserver")
