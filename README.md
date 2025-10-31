# Gharsethu - Smart Home Management App 🏠

> A comprehensive, full-stack mobile application designed to help families manage their home efficiently. Built with Flutter for cross-platform compatibility and a powerful Node.js backend for advanced features.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js)](https://nodejs.org)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🌟 Features

### Core Features
- **Grocery Management**: Track pantry items, create shopping lists, and monitor stock levels
- **Meal Planning**: AI-powered meal planning with cultural considerations
- **Chore Management**: Assign and track household tasks
- **Budget Tracking**: Monitor expenses and stay within budget
- **Festival Calendar**: Hindu calendar integration for upcoming festivals
- **Role-Based Access**: Admin and Member roles for family management

### Advanced Features
- **Firebase Authentication**: Secure login with email, Google, and phone
- **Real-Time Sync**: Cloud Firestore for instant updates
- **OCR Receipt Scanning**: Automatic expense tracking from receipts
- **AI Meal Suggestions**: Personalized meal plans based on preferences

## 🏗️ Architecture

### Frontend (Flutter)
- **Framework**: Flutter 3.x
- **State Management**: BLoC/Cubit pattern
- **Routing**: GoRouter for declarative navigation
- **DI**: get_it for dependency injection
- **Architecture**: Feature-driven, layered architecture

### Backend
- **Framework**: Node.js with Express.js
- **Database**: MongoDB + Cloud Firestore
- **Authentication**: Firebase Admin SDK
- **Storage**: Firebase Cloud Storage

## 📁 Project Structure

```
gharsethu/
├── lib/                          # Flutter app source
│   ├── main.dart                # App entry point
│   ├── core/                    # Core functionality
│   │   ├── api/                 # API clients
│   │   ├── config/              # Configuration
│   │   ├── constants/           # Constants & strings
│   │   ├── models/              # Data models
│   │   ├── services/            # Core services
│   │   └── utils/               # Utilities
│   ├── features/                # Feature modules
│   │   ├── auth/                # Authentication
│   │   ├── grocery_management/  # Grocery & pantry
│   │   ├── meal_planning/       # Meal planning
│   │   ├── chores/              # Task management
│   │   ├── budget/              # Financial tracking
│   │   └── festivals/           # Calendar & events
│   └── presentation/            # UI layer
│       ├── screens/             # Main screens
│       └── theme/               # App theme
├── server/                      # Node.js backend
│   ├── config/                  # Configuration
│   ├── controllers/             # Request handlers
│   ├── middleware/              # Middleware
│   ├── routes/                  # API routes
│   ├── services/                # Business logic
│   └── server.js               # Server entry
├── Documentation/
│   ├── README.md               # This file
│   ├── START_HERE.md           # Getting started guide
│   ├── FIRST_BUILD_GUIDE.md    # Step-by-step build
│   ├── SETUP.md                # Detailed setup
│   ├── ARCHITECTURE.md         # Architecture details
│   ├── BUILD_CHECKLIST.md      # Progress tracking
│   └── QUICKSTART.md           # Quick reference
└── Configuration/
    ├── pubspec.yaml            # Flutter dependencies
    ├── server/package.json     # Node.js dependencies
    └── .gitignore              # Git ignore rules
```

## 🚀 Getting Started

### Quick Start (5 minutes)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd gharsethu
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   cd server && npm install
   ```

3. **Configure Firebase**
   - Follow [FIRST_BUILD_GUIDE.md](FIRST_BUILD_GUIDE.md) for detailed Firebase setup
   - Or run: `flutterfire configure`

4. **Start the backend**
   ```bash
   cd server
   npm run dev
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Prerequisites
- Flutter SDK 3.0 or higher
- Node.js 18 or higher
- MongoDB 6.0 or higher
- Firebase project setup

For detailed setup instructions, see [SETUP.md](SETUP.md) or [FIRST_BUILD_GUIDE.md](FIRST_BUILD_GUIDE.md)

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [START_HERE.md](START_HERE.md) | Begin your journey here |
| [FIRST_BUILD_GUIDE.md](FIRST_BUILD_GUIDE.md) | Step-by-step build guide |
| [SETUP.md](SETUP.md) | Comprehensive setup instructions |
| [ARCHITECTURE.md](ARCHITECTURE.md) | System architecture deep dive |
| [BUILD_CHECKLIST.md](BUILD_CHECKLIST.md) | Track build progress |
| [QUICKSTART.md](QUICKSTART.md) | Quick reference guide |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contribution guidelines |

## 🛠️ Tech Stack

**Frontend:**
- Flutter 3.x with Dart
- BLoC/Cubit for state management
- GoRouter for navigation
- Firebase for backend services

**Backend:**
- Node.js with Express.js
- MongoDB for data persistence
- Firebase Admin SDK
- RESTful API design

**Infrastructure:**
- Firebase (Auth, Firestore, Storage)
- MongoDB Atlas or local MongoDB
- Cloud deployment ready

## 📱 API Endpoints

### Authentication
All endpoints require Firebase ID token in header: `Authorization: Bearer <token>`

### Meal Planning
- `POST /api/v1/mealplan/generate` - Generate AI meal plan

### Calendar
- `GET /api/v1/calendar/festivals?month=11&year=2025` - Get festivals

### Receipt Scanning
- `POST /api/v1/receipt/scan` - Scan receipt with OCR

## 🧪 Testing

```bash
# Run Flutter tests
flutter test

# Run backend tests
cd server
npm test
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Backend Deployment
Deploy to Google Cloud Run, Heroku, AWS, or Azure as needed.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Roadmap

- [ ] Push notifications
- [ ] Advanced AI meal suggestions
- [ ] Multi-language support
- [ ] Export reports (PDF, Excel)
- [ ] Voice commands
- [ ] Integration with grocery delivery apps
- [ ] Smart home device integration

## 👥 Team

Built with ❤️ for families

## 📞 Support

For issues and questions:
- Open an issue on GitHub
- Check the documentation in `Documentation/` folder

## 📦 Repository

**GitHub:** https://github.com/legend12309/home-management-app

## 🚀 Quick Start

1. Clone the repository
2. Follow [START_HERE.md](START_HERE.md)
3. Set up Firebase (see [FIRST_BUILD_GUIDE.md](FIRST_BUILD_GUIDE.md))
4. Run `flutter pub get` and `cd server && npm install`
5. Launch the app!

For detailed instructions, see [SETUP.md](SETUP.md) or [FIRST_BUILD_GUIDE.md](FIRST_BUILD_GUIDE.md)

---

**Made with Flutter & Firebase** 🚀

**Start building now: [START_HERE.md](START_HERE.md)**
