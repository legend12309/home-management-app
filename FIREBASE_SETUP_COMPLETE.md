# 🔥 Firebase Setup Instructions

## Current Status
Your Flutter app and backend are ready. Now we need to connect them to Firebase.

---

## 🎯 Step 1: Create Firebase Project

1. **Go to Firebase Console**
   → https://console.firebase.google.com

2. **Click "Add project"**
   - Project name: `gharsethu` (or your choice)
   - Click "Continue"
   - Disable Google Analytics (optional)
   - Click "Create project"

3. **Wait for project creation** (1-2 minutes)

---

## 🔐 Step 2: Enable Authentication

1. In Firebase Console, click **"Authentication"**
2. Click **"Get started"**
3. Click **"Sign-in method"** tab
4. Enable these providers:
   - ✅ **Email/Password** → Enable → Save
   - ✅ **Google** (optional) → Enable → Save

---

## 💾 Step 3: Create Firestore Database

1. Click **"Firestore Database"** in left menu
2. Click **"Create database"**
3. Choose **"Start in production mode"** (more secure)
4. Click "Next"
5. Select **location** (closest to you)
6. Click "Enable"

**Important:** After creating, go to "Rules" tab and paste this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Family data - members can read, admin can write
    match /families/{familyId} {
      allow read: if request.auth != null && 
                     request.auth.uid in resource.data.members || 
                     request.auth.uid == resource.data.adminId;
      allow create, update: if request.auth != null && 
                              request.auth.uid == resource.data.adminId;
    }
    
    // Grocery items
    match /groceryItems/{itemId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Shopping lists
    match /shoppingLists/{listId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Chores
    match /chores/{choreId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Budgets and expenses
    match /budgets/{budgetId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /expenses/{expenseId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Meal plans
    match /mealPlans/{planId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Festivals
    match /festivals/{festivalId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

7. Click "Publish"

---

## 📦 Step 4: Enable Cloud Storage

1. Click **"Storage"** in left menu
2. Click **"Get started"**
3. Choose **"Start in production mode"**
4. Click "Next"
5. Select same location as Firestore
6. Click "Done"

**Security Rules** (in Storage → Rules tab):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

7. Click "Publish"

---

## 📱 Step 5: Add Android App

1. In Firebase Console, click **project settings** (gear icon)
2. Scroll to "Your apps"
3. Click **Android** icon
4. Fill in:
   - Android package name: `com.gharsethu.app`
   - App nickname: `Gharsethu Android` (optional)
5. Click "Register app"
6. **Download** `google-services.json`
7. **Save this file!** We'll need it

---

## 🍎 Step 6: Add iOS App (if needed)

1. Still in project settings
2. Click **iOS** icon
3. Fill in:
   - iOS bundle ID: `com.gharsethu.app`
   - App nickname: `Gharsethu iOS` (optional)
4. Click "Register app"
5. **Download** `GoogleService-Info.plist`
6. **Save this file!** We'll need it

---

## 🔑 Step 7: Get Service Account Key (Backend)

1. Still in project settings
2. Click **"Service accounts"** tab
3. Click **"Generate new private key"**
4. Click **"Generate key"** in popup
5. JSON file downloads automatically
6. **Save this file as:** `serviceAccountKey.json`
7. **IMPORTANT:** Keep this file SECRET! Never share it publicly!

---

## 📝 Step 8: Configure Flutter App

### Option A: Using FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your app
flutterfire configure
```

Follow prompts:
- Select your Firebase project
- Select platforms (Android, iOS)
- Files will be auto-generated!

### Option B: Manual Configuration

1. Open `lib/core/services/firebase_options.dart`
2. Replace `YOUR_*_HERE` with values from Firebase Console
3. You'll find these in Project Settings → General tab

---

## 🚀 Step 9: Configure Backend

1. Copy `serviceAccountKey.json` to `server/config/` folder
2. Replace the `.example` file
3. Your backend is now configured!

---

## ✅ Verification Checklist

After completing all steps, verify:

- [ ] Firebase project created
- [ ] Authentication enabled (Email/Password)
- [ ] Firestore database created with security rules
- [ ] Storage enabled with security rules
- [ ] Android app registered
- [ ] iOS app registered (if needed)
- [ ] Service account key downloaded
- [ ] Flutter app configured
- [ ] Backend configured

---

## 🎯 Next Step

After Firebase is set up, proceed to **Backend Deployment** section!

---

**Need Help?** Read FIRST_BUILD_GUIDE.md for detailed instructions!

