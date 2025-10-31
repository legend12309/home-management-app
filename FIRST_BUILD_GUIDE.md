# First Build Guide - Let's Build Gharsethu! 🚀

## Welcome! 

You now have a complete, professional full-stack application architecture. Let's walk through getting it running on your machine.

## 🎯 What We're Building

A comprehensive home management app with:
- ✅ Flutter frontend (cross-platform mobile)
- ✅ Node.js backend API
- ✅ Firebase authentication & real-time database
- ✅ 6 major feature modules
- ✅ Production-ready architecture

## 📋 Prerequisites (5 minutes)

Before we start, make sure you have:

1. **Flutter** installed (`flutter --version`)
   - Download: https://flutter.dev/docs/get-started/install
   
2. **Node.js** installed (`node --version`)
   - Download: https://nodejs.org/ (v18+)
   
3. **Git** installed
   - Download: https://git-scm.com/downloads

4. **A Code Editor**
   - VS Code (recommended)
   - Android Studio
   - IntelliJ IDEA

## 🚀 Step-by-Step Build Process

### Step 1: Set Up Your Firebase Project (10 minutes)

**Why?** Firebase handles authentication, real-time database, and file storage.

1. **Create Firebase Project**
   - Go to: https://console.firebase.google.com
   - Click "Add project"
   - Name it: "Gharsethu" (or any name you like)
   - Click through the wizard (no changes needed for most options)

2. **Add Your Apps**
   
   For Android:
   - Click "Add app" → Android icon
   - Android package name: `com.gharsethu.app`
   - Download `google-services.json`
   - Save it for later (we'll place it in the right location)
   
   For iOS:
   - Click "Add app" → iOS icon
   - iOS bundle ID: `com.gharsethu.app`
   - Download `GoogleService-Info.plist`
   - Save it for later

3. **Enable Authentication**
   - In Firebase Console → Authentication → Get Started
   - Enable "Email/Password" sign-in method
   - (Optional) Enable "Google" sign-in

4. **Create Firestore Database**
   - Firestore Database → Create Database
   - Start in "Test mode" (we'll secure it later)
   - Choose a location close to you

5. **Enable Cloud Storage**
   - Storage → Get Started
   - Start in test mode
   - Same location as Firestore

6. **Get Service Account Key** (for backend)
   - Settings → Service Accounts
   - Click "Generate new private key"
   - Download the JSON file
   - Rename to `serviceAccountKey.json`
   - Save it for later

### Step 2: Configure Flutter App (5 minutes)

1. **Update Firebase Configuration**

   You have two options:

   **Option A: Use FlutterFire CLI (Recommended)**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure
   ```
   Follow the prompts to select your project and platforms.

   **Option B: Manual Configuration**
   - Open `lib/core/services/firebase_options.dart`
   - Replace all `YOUR_*_HERE` placeholders with your Firebase values
   - You can find these in Firebase Console → Project Settings

2. **Place Google Services Files**

   For Android:
   - Place `google-services.json` in `android/app/` directory
   
   For iOS:
   - Place `GoogleService-Info.plist` in `ios/Runner/` directory

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

### Step 3: Set Up Backend (5 minutes)

1. **Install Dependencies**
   ```bash
   cd server
   npm install
   ```

2. **Configure Environment**
   ```bash
   # Copy the example file
   cp .env.example .env
   
   # Edit .env with your details
   # You can use the default MongoDB URI for local development
   ```

3. **Add Service Account Key**
   - Place `serviceAccountKey.json` in `server/config/` directory
   - (We downloaded this in Step 1)

4. **Start MongoDB** (if using local)
   
   macOS:
   ```bash
   brew services start mongodb-community
   ```
   
   Or use MongoDB Atlas (cloud) for free: https://www.mongodb.com/cloud/atlas

5. **Start Backend Server**
   ```bash
   npm run dev
   ```
   
   You should see: "Gharsethu API Server is running on port 5000"

6. **Test Backend**
   ```bash
   curl http://localhost:5000/health
   ```
   
   Should return: `{"status":"OK","message":"Gharsethu API is running"}`

### Step 4: Run the App! (2 minutes)

1. **Open Terminal/Command Prompt**

2. **Navigate to Project Root**
   ```bash
   cd aapli-ghar  # or wherever your project is
   ```

3. **Run Flutter App**
   
   On Android:
   ```bash
   flutter run
   ```
   
   On iOS:
   ```bash
   flutter run -d ios
   ```

   The app should launch on your emulator or device!

### Step 5: Test the App (5 minutes)

1. **Sign Up**
   - Click "Sign Up" on the login screen
   - Enter your name, email, and password
   - Create account

2. **Create or Join Family**
   - Choose "Create Family" if you're the first user
   - Or choose "Join Family" if someone shared an invite code
   - You'll be redirected to the home screen!

3. **Explore Features**
   - Click through the different feature cards
   - Each feature has a beautiful UI ready to be connected to real data

## 🎉 Congratulations!

You now have a fully functional application running! 

## 🔧 What's Next?

### Immediate Next Steps:

1. **Connect Real Data**
   - Grocery lists → Firestore
   - Meal plans → Firebase Storage + API
   - Chores → Firestore with real-time updates

2. **Add More Features**
   - Receipt scanning
   - Push notifications
   - Multi-language support

3. **Polish the UI**
   - Add animations
   - Improve error handling
   - Add loading states

4. **Deploy**
   - Android: Google Play Store
   - iOS: App Store
   - Backend: Google Cloud Run / Heroku / AWS

## 🐛 Troubleshooting

**"Firebase App not initialized"**
```bash
flutter clean
flutter pub get
flutterfire configure
flutter run
```

**"Cannot connect to backend"**
- Check backend is running on port 5000
- For Android emulator: use `http://10.0.2.2:5000`
- For iOS simulator: use `http://localhost:5000`
- For physical device: use your computer's IP address

**"Package conflicts"**
```bash
flutter clean
flutter pub get
cd server
rm -rf node_modules package-lock.json
npm install
```

**"MongoDB connection failed"**
- Start MongoDB locally, OR
- Use MongoDB Atlas (free cloud option)
- Update `.env` with correct connection string

## 📚 Additional Resources

- **Full Setup**: `SETUP.md`
- **Architecture**: `ARCHITECTURE.md`
- **Contributing**: `CONTRIBUTING.md`
- **Quick Reference**: `QUICKSTART.md`

## 💡 Tips

1. **Take Your Time** - Each step matters
2. **Test Frequently** - Run after each change
3. **Read Errors** - They usually tell you exactly what's wrong
4. **Commit Often** - Save your progress with Git
5. **Ask Questions** - Open GitHub issues for help

## 🎓 Learning Path

1. ✅ Understand the architecture (`ARCHITECTURE.md`)
2. ✅ Get it running (this guide)
3. ✅ Read the code to understand patterns
4. ✅ Start adding your own features
5. ✅ Deploy and share with others!

## 🤝 Need Help?

- **Documentation**: Check `README.md`, `ARCHITECTURE.md`, `SETUP.md`
- **Issues**: Open a GitHub issue
- **Community**: Join our Discord/forum

---

**You've got this! Let's build something amazing together! 🚀**

Happy coding! 🎉

