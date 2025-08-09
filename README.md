# 🛩️ OACA Agents - Application Mobile

## 📋 Description

Application mobile de gestion des agents de contrôle aérien pour l'**Office de l'Aviation Civile et des Aéroports (OACA)** - Tunisie.

### ديوان الطيران المدني والمطارات - تونس
**تطبيق إدارة وكلاء مراقبة الحركة الجوية**

---

## ✨ Fonctionnalités

- 🔐 **Authentification sécurisée**
- 👥 **Gestion des agents** de contrôle aérien
- 📊 **Affichage par rôles** (Superviseur, Responsable, etc.)
- 🏢 **Organisation par sections** (PPA, GAT, Passerelle)
- 🔍 **Recherche avancée** en temps réel
- 📱 **PWA installable** sur mobile et desktop
- 🌐 **Interface bilingue** (Arabe/Français)

---

## 🛠️ Technologies

- **Frontend :** Flutter Web
- **Backend :** Django REST API
- **Base de données :** PostgreSQL
- **Authentification :** JWT
- **PWA :** Service Workers
- **Design :** Material Design

---

## 🚀 Installation

### Prérequis
- Flutter SDK (>=3.0.0)
- Python 3.8+
- PostgreSQL

### Frontend (Flutter)
```bash
cd agents_mobile_app
flutter pub get
flutter build web --web-renderer html
```

### Lancement local
```bash
python -m http.server 8080 --directory build/web
```

---

## 🌐 Déploiement

### Production
- **Frontend :** Netlify, Firebase Hosting, GitHub Pages
- **Backend :** Heroku, DigitalOcean, AWS

---

## 📱 Utilisation

1. **Connexion** avec identifiants OACA
2. **Navigation** par sections d'aéroport
3. **Gestion CRUD** des agents
4. **Recherche et filtrage** avancés
5. **Installation PWA** pour accès hors ligne

---

## 🎨 Design

- **Logo officiel OACA** intégré
- **Couleurs institutionnelles** bleues
- **Interface responsive** mobile-first
- **Favicon personnalisé** OACA
- **Texte bilingue** conforme aux standards

---

## 📄 Licence

Développé pour l'Office de l'Aviation Civile et des Aéroports (OACA) - Tunisie

---

## 👨‍💻 Développement

**Projet de stage** - Gestion des agents de contrôle aérien
**Institution :** OACA - Office de l'Aviation Civile et des Aéroports
**Pays :** Tunisie 🇹🇳
