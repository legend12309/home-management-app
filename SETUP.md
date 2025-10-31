# Setup Guide - Aapli Ghar

Complete step-by-step setup instructions to get the Aapli Ghar app running on your development machine.

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
1. **Flutter SDK** (v3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter --version`

2. **Node.js** (v18 or higher)
   - Download from: https://nodejs.org/
   - Verify installation: `node --version`

3. **MongoDB** (v6.0 or higher) - Optional if using remote DB
   - Download from: https://www.mongodb.com/try/download/community

4. **Git**
   - Download from: https://git-scm.com/downloads

5. **IDE** (Choose one)
   - Visual Studio Code (Recommended)
   - Android Studio
   - IntelliJ IDEA

### Development Tools
- **Firebase CLI**: `npm install -g firebase-tools`
- **FlutterFire CLI**: `dart pub global activate flutterfire_cli`

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Enter project name: "Aapli Ghar"
4. Continue through the setup wizard

### 2. Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Enable the following sign-in methods:
   - ✅ Email/Password
   - ✅ Google
   - ✅ Phone (optional)

### 3. Create Firestore Database

1. Go to **Firestore Database**
2. Click **Create database**
3. Start in **test mode** (update security rules later)
4. Choose a location closest to your users

### 4. Enable Cloud Storage

1. Go to **Storage**
2. Click **Get started**
3. Start in test mode
4. Choose same location as Firestore

### 5. Generate Service Account Key

1. Go to Project Settings → Service Accounts
2. Click **Generate new private key**
3. Download the JSON file
4. Rename to `serviceAccountKey.json`
5. Place in `server/config/` directory

### 6. Configure Firestore Rules

Go to Firestore Database → Rules and update:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Family members can read/write family data
    match /families/{familyId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Recipes are readable by family members
    match /recipes/{recipeId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

### 7. Configure Storage Rules

Go to Storage → Rules and update:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Flutter App Setup

### 1. Clone Repository

```bash
git clone <your-repository-url>
cd aapli-ghar
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase for Flutter

Run FlutterFire CLI:

```bash
flutterfire configure
```

Follow the prompts:
- Select your Firebase project
- Select platforms (Android, iOS, Web)
- This generates `firebase_options.dart`

Alternatively, manually create `lib/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS not supported');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows not supported');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux not supported');
      default:
        throw UnsupportedError('Unknown platform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: 'com.example.aapliGhar',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );
}
```

### 4. Configure Firebase Options

Update `lib/core/services/firebase_options.dart` with your Firebase credentials from Firebase Console.

### 5. Update API Base URL

In `lib/core/api/api_client.dart`, update the baseUrl:

```dart
baseUrl: Platform.isAndroid 
    ? 'http://10.0.2.2:5000/api/v1'  // Android emulator
    : 'http://localhost:5000/api/v1'  // iOS simulator
```

For physical devices, use your local IP address:

```dart
baseUrl: 'http://192.168.1.XXX:5000/api/v1'
```

### 6. Run the App

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## Backend Setup

### 1. Navigate to Server Directory

```bash
cd server
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Configure Environment Variables

```bash
# Copy example file
cp .env.example .env

# Edit .env file
nano .env  # or use your preferred editor
```

Update the following in `.env`:

```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/aapli-ghar
HINDU_CALENDAR_API_KEY=your-api-key
GOOGLE_VISION_API_KEY=your-api-key
OPENAI_API_KEY=your-api-key
```

### 4. Configure Firebase Admin

Ensure `config/serviceAccountKey.json` is in place (from Firebase setup step 5).

### 5. Start MongoDB (if using local)

```bash
# macOS
brew services start mongodb-community

# Linux
sudo systemctl start mongod

# Windows
net start MongoDB
```

### 6. Run the Backend Server

```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

The API should now be running at `http://localhost:5000`

### 7. Test the API

```bash
# Health check
curl http://localhost:5000/health

# Expected response:
# {"status":"OK","message":"Aapli Ghar API is running"}
```

## Testing the Integration

### 1. Start Both Services

Terminal 1 - Backend:
```bash
cd server
npm run dev
```

Terminal 2 - Flutter App:
```bash
cd .
flutter run
```

### 2. Test Authentication Flow

1. Open the app
2. Click "Sign Up"
3. Create an account
4. Select "Create Family" or "Join Family"
5. Verify data appears in Firebase Console

### 3. Test API Integration

Test receipt scanning:
```bash
curl -X POST http://localhost:5000/api/v1/receipt/scan \
  -H "Authorization: Bearer YOUR_FIREBASE_TOKEN" \
  -F "image=@/path/to/receipt.jpg"
```

## Troubleshooting

### Firebase Connection Issues

**Error**: "Firebase App is not initialized"
- Ensure `firebase_options.dart` is properly configured
- Run `flutterfire configure` again

**Error**: "Firebase Auth failed"
- Check authentication methods are enabled in Firebase Console
- Verify SHA-1 fingerprint for Android

### Backend Connection Issues

**Error**: "Connection refused"
- Verify backend is running on correct port
- Check firewall settings
- Use correct IP address for physical devices

**Error**: "MongoDB connection failed"
- Ensure MongoDB is running
- Check connection string in `.env`
- Verify network connectivity

### Flutter Build Issues

**Error**: "Package not found"
```bash
flutter clean
flutter pub get
```

**Error**: "Gradle build failed"
- Update Gradle version
- Check Android SDK installation

## Next Steps

1. **Configure iOS Signing** (if developing for iOS)
   - Open `ios/Runner.xcworkspace` in Xcode
   - Set up signing certificates

2. **Set Up Android Keystore** (for release builds)
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

3. **Enable Push Notifications**
   - Configure FCM in Firebase Console
   - Add push notification permissions

4. **Set Up CI/CD**
   - Configure GitHub Actions
   - Set up automated testing
   - Configure automatic deployments

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

## Support

If you encounter any issues during setup:

1. Check the [GitHub Issues](your-repo/issues)
2. Review the troubleshooting section above
3. Contact the development team

---

**Happy Coding! 🚀**

