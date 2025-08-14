# OACA - Gestion des Agents

Application de gestion des agents de l'Office de l'Aviation Civile et des Aéroports (OACA) de Tunisie.

## 🚀 Dernières Corrections (14 Août 2025)

### ✅ Correction des codes d'aéroports dans l'application mobile

**Problème résolu :** L'application mobile affichait des codes d'aéroports incorrects et un nombre d'agents erroné.

**Corrections apportées :**
- ✅ Mise à jour des codes d'aéroports :
  - `AIDJ` → `AIDZ` (Djerba-Zarzis)
  - `AIGF` → `AIGK` (Gafsa-Ksar)
  - `AIMT` → `AITC` (Tunis-Carthage)
  - `AIOZ` → `AITN` (Tozeur-Nefta)
  - `AISF` → `AIST` (Sfax-Thyna)
  - Ajout de `AITAD` (Tabarka-Ain Draham)
  - Ajout de `AIGM` (Gafsa-Metlaoui)

- ✅ Correction du nombre d'agents : 88 → 97 agents
- ✅ Reconstruction complète de l'application Flutter avec les bonnes données
- ✅ Synchronisation avec l'API Django qui fournit les données correctes

**Résultat :** L'application mobile affiche maintenant les mêmes données que l'application PC.

## 🏗️ Architecture

- **Backend**: Django REST API with PostgreSQL database
- **Frontend**: Flutter mobile application
- **Data Source**: Excel files containing agent information

## 📁 Project Structure

```
stage initiation/
├── agent/                          # Django backend project
│   ├── agent/                      # Django project settings
│   ├── agents/                     # Django app for agents
│   │   ├── models.py              # Agent model
│   │   ├── serializers.py         # DRF serializers
│   │   ├── views.py               # API views
│   │   ├── urls.py                # URL routing
│   │   └── management/commands/   # Data import commands
│   └── manage.py
├── agents_mobile_app/              # Flutter mobile app
│   ├── lib/
│   │   ├── models/                # Data models
│   │   ├── services/              # API services & providers
│   │   ├── screens/               # UI screens
│   │   └── widgets/               # Reusable widgets
│   └── pubspec.yaml
├── agents_frontend.html            # Demo web frontend
└── Excel files/                    # Source data files
```

## 🚀 Features

### Backend (Django)
- ✅ Agent model with comprehensive fields
- ✅ Excel data import from multiple files
- ✅ REST API endpoints for CRUD operations
- ✅ Search and filtering capabilities
- ✅ Statistics and analytics
- ✅ CORS support for mobile app

### Frontend (Flutter)
- ✅ Modern Material Design UI
- ✅ Agent list with search and filtering
- ✅ Detailed agent view
- ✅ Statistics dashboard
- ✅ Responsive design
- ✅ Error handling and loading states
- ✅ Codes d'aéroports corrects (CORRIGÉ ✅)

## Aéroports supportés

- **AITC** - Tunis-Carthage
- **AIDZ** - Djerba-Zarzis
- **AIGK** - Gafsa-Ksar
- **AIGM** - Gafsa-Metlaoui
- **AIST** - Sfax-Thyna
- **AITAD** - Tabarka-Ain Draham
- **AITN** - Tozeur-Nefta

## 📊 Data Sources

The system imports data from two Excel files:
1. `Liste des agents aux unités PPA&GAT&PT .xlsx`
2. `liste des agents 2022 naima du 6 décembre 2022 .xlsx`

### Agent Data Fields
- **Matricule**: Unique identifier
- **Name**: Full name, first name, last name
- **Affectation**: Work assignment/department
- **Period**: Work period information
- **Status**: Current status
- **Source File**: Origin Excel file

## 🛠️ Setup Instructions

### Prerequisites
- Python 3.8+
- Flutter 3.0+
- PostgreSQL (optional, SQLite used by default)

### Backend Setup

1. **Navigate to the Django project**:
   ```bash
   cd agent
   ```

2. **Install Python dependencies**:
   ```bash
   pip install django djangorestframework django-cors-headers psycopg2 pandas openpyxl
   ```

3. **Run migrations**:
   ```bash
   python manage.py migrate
   ```

4. **Import Excel data**:
   ```bash
   python manage.py import_agents
   ```

5. **Create superuser (optional)**:
   ```bash
   python manage.py createsuperuser
   ```

6. **Start the development server**:
   ```bash
   python manage.py runserver
   ```

### Frontend Setup

1. **Install Flutter**: Follow [Flutter installation guide](https://flutter.dev/docs/get-started/install)

2. **Navigate to Flutter project**:
   ```bash
   cd agents_mobile_app
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Database Configuration

By default, the project uses SQLite. To use PostgreSQL:

1. Install and setup PostgreSQL
2. Create database named `agents`
3. Update `agent/agent/settings.py`:
   ```python
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.postgresql',
           'NAME': 'agents',
           'USER': 'your_username',
           'PASSWORD': 'your_password',
           'HOST': 'localhost',
           'PORT': '5432',
       }
   }
   ```

### API Configuration

Update the API base URL in `agents_mobile_app/lib/services/api_service.dart`:
- For Android emulator: `http://10.0.2.2:8000/api`
- For iOS simulator: `http://127.0.0.1:8000/api`
- For physical device: `http://YOUR_COMPUTER_IP:8000/api`

## 📱 Mobile App Features

### Main Screen
- Agent list with search functionality
- Statistics cards showing total agents and affectations
- Filter chips for quick filtering
- Pull-to-refresh support

### Agent Detail Screen
- Complete agent information
- Professional card-style layout
- Source file information
- Creation and update timestamps

### Search & Filter
- Real-time search across multiple fields
- Filter by affectation
- Filter by source file
- Clear filters option

## 🌐 API Endpoints

- `GET /api/agents/` - List all agents
- `GET /api/agents/{id}/` - Get specific agent
- `GET /api/agents/search/?q={query}` - Search agents
- `GET /api/agents/stats/` - Get statistics
- `GET /api/agents-json/` - Simple JSON endpoint

## 🎨 Demo

A web-based demo is available in `agents_frontend.html` that showcases the UI design and functionality with mock data.

## 🐛 Troubleshooting

### Common Issues

1. **URL routing issues**: Clear Django cache and restart server
2. **CORS errors**: Ensure `django-cors-headers` is properly configured
3. **Flutter build errors**: Run `flutter clean` and `flutter pub get`
4. **Database connection**: Check PostgreSQL service and credentials

### Known Issues

- Django URL routing may have conflicts (use simple JSON endpoints as fallback)
- Excel file parsing may need adjustment for different file formats

## 📈 Future Enhancements

- [ ] User authentication and authorization
- [ ] Real-time data synchronization
- [ ] Export functionality
- [ ] Advanced filtering and sorting
- [ ] Data visualization charts
- [ ] Offline support for mobile app
- [ ] Push notifications
- [ ] Multi-language support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is for educational and demonstration purposes.
