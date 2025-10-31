# Build Checklist - Aapli Ghar

Follow this checklist to get the app fully operational.

## ✅ Phase 1: Foundation Setup

### Firebase Setup
- [ ] Create Firebase project at https://console.firebase.google.com
- [ ] Add Android app to Firebase project
- [ ] Add iOS app to Firebase project
- [ ] Download `google-services.json` (Android)
- [ ] Download `GoogleService-Info.plist` (iOS)
- [ ] Place files in respective directories

### Firebase Configuration
- [ ] Enable Email/Password authentication
- [ ] Enable Google Sign-In
- [ ] Create Firestore database
- [ ] Set Firestore security rules
- [ ] Enable Cloud Storage
- [ ] Set Storage security rules
- [ ] Generate Service Account Key
- [ ] Download `serviceAccountKey.json` to `server/config/`

### Flutter Configuration
- [ ] Run `flutterfire configure` OR manually configure
- [ ] Update `lib/core/services/firebase_options.dart` with real values
- [ ] Place `google-services.json` in `android/app/`
- [ ] Place `GoogleService-Info.plist` in `ios/Runner/`
- [ ] Update `pubspec.yaml` if needed

## ✅ Phase 2: Backend Setup

### Environment Configuration
- [ ] Create `server/.env` from `.env.example`
- [ ] Set `MONGODB_URI` (local or MongoDB Atlas)
- [ ] Add any API keys needed
- [ ] Verify `serviceAccountKey.json` is in place

### Dependencies
- [ ] Run `cd server && npm install`
- [ ] Start MongoDB (if local)
- [ ] Test MongoDB connection
- [ ] Start backend: `npm run dev`
- [ ] Verify health endpoint: http://localhost:5000/health

### API Testing
- [ ] Test with Postman/cURL
- [ ] Verify Firebase token authentication
- [ ] Test all endpoints

## ✅ Phase 3: App Integration

### Flutter Build
- [ ] Run `flutter pub get`
- [ ] Run `flutter doctor` to check setup
- [ ] Build for Android: `flutter build apk --debug`
- [ ] Build for iOS: `flutter build ios --debug`

### Connectivity
- [ ] Update `lib/core/api/api_client.dart` baseUrl
- [ ] Test backend connection from app
- [ ] Verify Firebase connection from app

### First Run
- [ ] Launch app on emulator/device
- [ ] Test sign-up flow
- [ ] Verify Firestore data creation
- [ ] Test sign-in flow
- [ ] Create/join family

## ✅ Phase 4: Feature Implementation

### Grocery Management
- [ ] Implement grocery list CRUD operations
- [ ] Connect to Firestore
- [ ] Add pantry tracking
- [ ] Implement stock status updates
- [ ] Add shopping list sync

### Meal Planning
- [ ] Implement recipe storage in Firestore
- [ ] Connect AI API (when ready)
- [ ] Add meal plan generation
- [ ] Implement calendar view

### Chores
- [ ] Implement chore CRUD operations
- [ ] Add assignment logic
- [ ] Create status workflow
- [ ] Add notifications (optional)

### Budget
- [ ] Implement expense tracking
- [ ] Connect receipt scanning
- [ ] Add budget calculations
- [ ] Create analytics views

### Festivals
- [ ] Integrate calendar API
- [ ] Fetch festival data
- [ ] Display in UI
- [ ] Add notifications

## ✅ Phase 5: Testing & Polish

### Functional Testing
- [ ] Test all user flows
- [ ] Verify multi-user scenarios
- [ ] Test role-based permissions
- [ ] Check offline behavior

### UI/UX
- [ ] Test on different screen sizes
- [ ] Verify dark theme
- [ ] Check loading states
- [ ] Test error handling
- [ ] Verify navigation flows

### Performance
- [ ] Profile app performance
- [ ] Optimize images
- [ ] Check memory leaks
- [ ] Test database queries

### Security
- [ ] Review Firestore rules
- [ ] Test authentication edge cases
- [ ] Verify token refresh
- [ ] Check data validation

## ✅ Phase 6: Deployment Ready

### Code Quality
- [ ] Fix all linter warnings
- [ ] Write unit tests
- [ ] Add integration tests
- [ ] Code review

### Production Builds
- [ ] Generate release keystore (Android)
- [ ] Configure App Store Connect (iOS)
- [ ] Build release APK
- [ ] Build release IPA

### Deployment
- [ ] Deploy backend to cloud
- [ ] Configure production environment
- [ ] Set up monitoring
- [ ] Configure CI/CD

### Documentation
- [ ] Update user documentation
- [ ] Create video tutorials
- [ ] Write deployment guide
- [ ] Document API endpoints

## 🚀 Quick Start Commands

```bash
# 1. Firebase Setup
flutterfire configure

# 2. Backend
cd server
npm install
cp .env.example .env
# Edit .env
npm run dev

# 3. Frontend
cd ..
flutter pub get
flutter run

# 4. Test Build
flutter build apk --debug
```

## 📝 Notes

- Mark items as you complete them
- Take your time with each phase
- Test thoroughly before moving to next phase
- Keep documentation updated
- Commit frequently with descriptive messages

**Ready to build? Let's start! 🎉**

