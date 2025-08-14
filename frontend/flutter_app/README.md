# Agents Mobile App

A Flutter mobile application for managing and viewing agent data from the Django backend.

## 📱 Features

- **Agent List**: Browse all agents with search and filtering
- **Agent Details**: View comprehensive agent information
- **Statistics**: Dashboard with key metrics
- **Search**: Real-time search across multiple fields
- **Filters**: Filter by affectation, source file, and status
- **Responsive Design**: Works on phones and tablets

## 🛠️ Setup

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code with Flutter extensions
- Running Django backend server

### Installation

1. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

2. **Configure API endpoint**:
   Edit `lib/services/api_service.dart` and update the `baseUrl`:
   - For Android emulator: `http://10.0.2.2:8000/api`
   - For iOS simulator: `http://127.0.0.1:8000/api`
   - For physical device: `http://YOUR_COMPUTER_IP:8000/api`

3. **Run the app**:
   ```bash
   flutter run
   ```

## 🏗️ Architecture

### State Management
- **Provider**: Used for state management
- **AgentProvider**: Manages agent data, loading states, and API calls

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/
│   └── agent.dart           # Agent data model
├── services/
│   ├── api_service.dart     # HTTP API calls
│   └── agent_provider.dart  # State management
├── screens/
│   ├── agents_list_screen.dart    # Main agent list
│   └── agent_detail_screen.dart   # Agent details
└── widgets/
    ├── agent_card.dart      # Agent list item
    ├── search_bar.dart      # Custom search widget
    └── stats_card.dart      # Statistics display
```

## 🎨 UI Components

### AgentCard
- Displays agent summary information
- Shows avatar, name, matricule, and affectation
- Status indicator with color coding
- Tap to navigate to details

### SearchBar
- Real-time search functionality
- Clear button when text is entered
- Customizable hint text

### StatsCard
- Shows total agents and affectations
- Breakdown by affectation (top 3)
- Color-coded statistics

## 🔧 Configuration

### API Configuration
Update the base URL in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://YOUR_SERVER:8000/api';
```

### Network Permissions
For Android, ensure network permissions are set in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## 🚀 Building

### Debug Build
```bash
flutter run
```

### Release Build
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## 📱 Platform Support

- ✅ Android 5.0+ (API level 21+)
- ✅ iOS 11.0+
- ✅ Responsive design for tablets

## 🐛 Troubleshooting

### Common Issues

1. **Network Error**: Check if Django server is running and accessible
2. **Build Errors**: Run `flutter clean` then `flutter pub get`
3. **API Connection**: Verify the correct IP address for your device type

### Debug Tips

1. **Enable network logging**:
   ```dart
   print('API Response: ${response.body}');
   ```

2. **Check device connectivity**:
   ```bash
   adb shell ping YOUR_SERVER_IP  # Android
   ```

3. **View logs**:
   ```bash
   flutter logs
   ```

## 🔮 Future Enhancements

- [ ] Offline data caching
- [ ] Push notifications
- [ ] Dark theme support
- [ ] Advanced filtering options
- [ ] Export functionality
- [ ] Biometric authentication
- [ ] Multi-language support

## 📄 Dependencies

- `flutter`: SDK
- `http`: HTTP client for API calls
- `provider`: State management
- `cupertino_icons`: iOS-style icons

## 🤝 Contributing

1. Follow Flutter style guide
2. Add tests for new features
3. Update documentation
4. Test on both Android and iOS

## 📞 Support

For issues related to the mobile app, please check:
1. Flutter doctor: `flutter doctor`
2. Device connectivity to backend
3. API endpoint configuration
