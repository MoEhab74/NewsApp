# Firebase Setup Guide for NewsCloud

## 🔥 Firebase Configuration Required

To use the authentication features, you need to set up Firebase for your project:

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `newscloud-app`
4. Follow the setup wizard

### 2. Enable Authentication
1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Go to **Sign-in method** tab
4. Enable **Email/Password** provider

### 3. Setup Firestore Database
1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select your preferred location

### 4. Add Firebase to Flutter App

#### For Android:
1. Click **Add app** → **Android**
2. Package name: `com.example.news_app` (or your package name)
3. Download `google-services.json`
4. Place it in: `android/app/`
5. Add to `android/build.gradle.kts`:
```kotlin
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```
6. Add to `android/app/build.gradle.kts`:
```kotlin
plugins {
    id 'com.google.gms.google-services'
}
```

#### For iOS:
1. Click **Add app** → **iOS**
2. Bundle ID: `com.example.newsApp` (or your bundle ID)
3. Download `GoogleService-Info.plist`
4. Add it to `ios/Runner/` in Xcode

#### For Web:
1. Click **Add app** → **Web**
2. App name: `NewsCloud Web`
3. Copy the config and create `web/firebase_config.js`

### 5. Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own documents
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 6. Test the Setup
Run the app and try:
1. Creating a new account
2. Logging in
3. Logging out
4. Password reset

## 📱 Features Implemented

✅ **Complete Authentication Flow**
- Login with email/password
- Sign up with email/password  
- Password reset via email
- Automatic login state persistence

✅ **User Data Management**
- UserModel with favorites and saved articles
- Firestore integration for data persistence
- Real-time auth state tracking

✅ **UI Components**
- Beautiful login/signup screens
- Loading states and error handling
- Navigation between auth screens

✅ **Security Features**
- Input validation
- Firebase Auth error handling
- Secure password handling

✅ **App Integration**
- Theme-aware auth screens
- Logout functionality in drawer
- User info display

## 🎯 Next Steps
After Firebase setup, you can:
1. Test user registration and login
2. Add favorite/save article functionality
3. Implement user profile screens
4. Add social authentication (Google, Facebook)
5. Add email verification flow

## 🛠️ Troubleshooting
- Make sure Firebase SDK versions are compatible
- Check internet connectivity for Firebase operations
- Verify Firebase project configuration
- Check console for detailed error messages