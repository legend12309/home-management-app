# Quick Start Guide - Aapli Ghar

Get the Aapli Ghar app running on your machine in 10 minutes!

## Prerequisites Checklist

- [ ] Flutter SDK installed (`flutter --version`)
- [ ] Node.js installed (`node --version`)
- [ ] Git installed (`git --version`)
- [ ] Firebase account created
- [ ] MongoDB installed (optional for local)

## Quick Setup (5 Steps)

### Step 1: Clone & Install Dependencies

```bash
# Clone the repository
git clone <your-repo-url>
cd aapli-ghar

# Install Flutter dependencies
flutter pub get

# Install backend dependencies
cd server
npm install
cd ..
```

### Step 2: Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. Enable Authentication (Email/Password)
4. Create Firestore database (test mode)
5. Download `serviceAccountKey.json` → place in `server/config/`
6. Run `flutterfire configure` or manually configure `firebase_options.dart`

### Step 3: Environment Setup

```bash
# Backend
cd server
cp .env.example .env
# Edit .env with your MongoDB URI (use default for local)

cd ..
```

### Step 4: Start Services

**Terminal 1 - Backend:**
```bash
cd server
npm run dev
```

**Terminal 2 - Flutter App:**
```bash
flutter run
```

### Step 5: Test the App

1. Open the app on your device/emulator
2. Click "Sign Up"
3. Create an account
4. Create or join a family
5. Explore features!

## Common Issues & Quick Fixes

### Issue: "Firebase App not initialized"
```bash
flutterfire configure
flutter pub get
flutter run
```

### Issue: "Cannot connect to backend"
- Check backend is running on port 5000
- For Android emulator: use `10.0.2.2:5000`
- For iOS simulator: use `localhost:5000`
- For physical device: use your computer's IP

### Issue: "MongoDB connection failed"
```bash
# Start MongoDB
brew services start mongodb-community  # macOS
sudo systemctl start mongod            # Linux
net start MongoDB                      # Windows
```

### Issue: "Package conflicts"
```bash
flutter clean
flutter pub get
cd server
rm -rf node_modules package-lock.json
npm install
```

## What's Next?

Once the app is running:

1. ✅ Read [SETUP.md](SETUP.md) for detailed configuration
2. ✅ Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand the structure
3. ✅ Read [README.md](README.md) for feature overview
4. ✅ Start developing features!

## Need Help?

- 📖 Full setup: [SETUP.md](SETUP.md)
- 🏗️ Architecture: [ARCHITECTURE.md](ARCHITECTURE.md)
- 💡 Contributing: [CONTRIBUTING.md](CONTRIBUTING.md)
- 🐛 Issues: Open a GitHub issue

**Happy Coding! 🚀**

