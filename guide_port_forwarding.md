# 🌍 Guide Port Forwarding - Accès Public OACA Agents

## 🎯 Objectif
Rendre votre application accessible depuis n'importe où dans le monde via votre IP publique : **197.238.204.56**

## 📋 Étapes de Configuration

### 1. 🔧 Accès à votre routeur
- Ouvrez un navigateur
- Allez à : `http://192.168.1.1` ou `http://192.168.0.1`
- Connectez-vous avec vos identifiants admin

### 2. 🔍 Trouver la section Port Forwarding
Cherchez une section nommée :
- "Port Forwarding"
- "Virtual Server"
- "NAT"
- "Applications & Gaming"

### 3. ⚙️ Configuration requise
Créez une nouvelle règle avec :
- **Nom :** OACA_Agents
- **Port externe :** 8080
- **IP interne :** 192.168.1.14
- **Port interne :** 8080
- **Protocole :** TCP
- **État :** Activé

### 4. 🌐 Test d'accès public
Après configuration, votre application sera accessible via :
**http://197.238.204.56:8080**

## ⚠️ Considérations de sécurité

### 🔒 Recommandations importantes :
1. **Changez les identifiants par défaut**
2. **Utilisez HTTPS si possible**
3. **Limitez l'accès par IP si nécessaire**
4. **Surveillez les logs d'accès**

### 🛡️ Alternative sécurisée : VPN
Pour un accès sécurisé, considérez configurer un VPN au lieu du port forwarding direct.

## 🚀 Avantages vs Inconvénients

### ✅ Avantages :
- Accès permanent
- Pas de dépendance à des services tiers
- Contrôle total

### ⚠️ Inconvénients :
- Exposition directe sur Internet
- Risques de sécurité
- Configuration routeur requise

## 🆘 Support
Si vous avez des difficultés :
1. Consultez le manuel de votre routeur
2. Contactez votre FAI
3. Utilisez ngrok comme alternative
