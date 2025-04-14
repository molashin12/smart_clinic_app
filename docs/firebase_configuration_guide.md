# Firebase Configuration Guide for Smart Clinic Management App

This guide provides instructions for connecting your Smart Clinic Management App to your existing Firebase project.

## Prerequisites

- Existing Firebase project
- Flutter SDK installed and configured
- Firebase CLI installed (optional, but recommended)

## Step 1: Add Your App to Firebase Project

### For Android:

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your existing project
3. Click on the Android icon (+ Add app) to add a new Android app
4. Enter the package name: `com.drmolashin.smartclinic`
5. Enter app nickname (optional): "Smart Clinic Management"
6. Enter SHA-1 signing certificate (optional but recommended for Google Sign-In)
7. Click "Register app"
8. Download the `google-services.json` file
9. Place the file in the `android/app/` directory of your Flutter project

### For iOS:

1. In the Firebase Console, select your project
2. Click on the iOS icon (+ Add app) to add a new iOS app
3. Enter the bundle ID: `com.drmolashin.smartclinic`
4. Enter app nickname (optional): "Smart Clinic Management"
5. Enter App Store ID (optional)
6. Click "Register app"
7. Download the `GoogleService-Info.plist` file
8. Place the file in the `ios/Runner/` directory of your Flutter project using Xcode

### For Web (if needed):

1. In the Firebase Console, select your project
2. Click on the Web icon (+ Add app) to add a new Web app
3. Enter app nickname: "Smart Clinic Management Web"
4. Register the app
5. Copy the Firebase configuration object
6. Create a file at `web/firebase-config.js` with this configuration

## Step 2: Configure Firebase Services

### Authentication:

1. In the Firebase Console, go to "Authentication"
2. Click "Get started"
3. Enable the sign-in methods you want to use:
   - Email/Password (required for your app)
   - Google Sign-in (optional)
   - Phone authentication (optional)

4. Configure each provider:
   - For Email/Password: Enable "Email/Password" and optionally "Email link"
   - For Google Sign-in: Configure OAuth consent screen if needed
   - For Phone: Add test phone numbers for development

### Firestore Database:

1. Go to "Firestore Database"
2. Click "Create database"
3. Choose start mode (recommend "Start in production mode")
4. Select a location closest to your users
5. Set up security rules (initial rules are provided below)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Common functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    function hasRole(role) {
      return isSignedIn() && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == role;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && request.auth.uid == userId;
      allow update: if isOwner(userId) || hasRole('admin');
      allow delete: if hasRole('admin');
    }
    
    // Clinics collection
    match /clinics/{clinicId} {
      allow read: if isSignedIn() && (
        resource.data.ownerId == request.auth.uid || 
        resource.data.clinicAccess[request.auth.uid] != null
      );
      allow create: if isSignedIn();
      allow update: if isSignedIn() && (
        resource.data.ownerId == request.auth.uid || 
        resource.data.clinicAccess[request.auth.uid] == 'admin'
      );
      allow delete: if isSignedIn() && resource.data.ownerId == request.auth.uid;
    }
    
    // Patients collection
    match /patients/{patientId} {
      allow read: if isSignedIn() && (
        hasRole('doctor') || hasRole('nurse') || hasRole('receptionist')
      );
      allow create: if isSignedIn() && (
        hasRole('doctor') || hasRole('receptionist')
      );
      allow update: if isSignedIn() && (
        hasRole('doctor') || hasRole('nurse') || hasRole('receptionist')
      );
      allow delete: if isSignedIn() && hasRole('doctor');
      
      // Patient attachments subcollection
      match /attachments/{attachmentId} {
        allow read: if isSignedIn() && (
          hasRole('doctor') || hasRole('nurse')
        );
        allow write: if isSignedIn() && (
          hasRole('doctor') || hasRole('nurse')
        );
      }
    }
    
    // Appointments collection
    match /appointments/{appointmentId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && (
        hasRole('doctor') || hasRole('receptionist')
      );
      allow update: if isSignedIn() && (
        hasRole('doctor') || hasRole('nurse') || hasRole('receptionist')
      );
      allow delete: if isSignedIn() && (
        hasRole('doctor') || hasRole('receptionist')
      );
    }
    
    // Prescriptions collection
    match /prescriptions/{prescriptionId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && hasRole('doctor');
      allow update: if isSignedIn() && (
        hasRole('doctor') || hasRole('pharmacist')
      );
      allow delete: if isSignedIn() && hasRole('doctor');
    }
  }
}
```

### Firebase Storage:

1. Go to "Storage"
2. Click "Get started"
3. Choose security rules (recommend "Start in production mode")
4. Select a location closest to your users
5. Set up security rules:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    function isSignedIn() {
      return request.auth != null;
    }
    
    function hasRole(role) {
      return isSignedIn() && firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.role == role;
    }
    
    // Clinic logos
    match /clinics/{clinicId}/logo {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && (
        firestore.get(/databases/(default)/documents/clinics/$(clinicId)).data.ownerId == request.auth.uid
      );
    }
    
    // Patient profile photos
    match /patients/{patientId}/profile {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && (
        hasRole('doctor') || hasRole('receptionist')
      );
    }
    
    // Patient attachments
    match /patients/{patientId}/attachments/{attachmentId} {
      allow read: if isSignedIn() && (
        hasRole('doctor') || hasRole('nurse')
      );
      allow write: if isSignedIn() && (
        hasRole('doctor') || hasRole('nurse')
      );
    }
    
    // Prescription documents
    match /prescriptions/{prescriptionId}/{fileName} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && hasRole('doctor');
    }
  }
}
```

### Firebase Functions (Optional):

If you want to implement server-side functionality like appointment reminders:

1. Go to "Functions"
2. Click "Get started"
3. Set up billing account if prompted (Functions require Blaze plan)
4. Install Firebase CLI locally:
   ```bash
   npm install -g firebase-tools
   ```
5. Initialize Firebase Functions:
   ```bash
   firebase login
   firebase init functions
   ```

## Step 3: Update Flutter App Configuration

The app is already configured to use Firebase, but you need to ensure the correct dependencies are in your `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.15.0
  firebase_auth: ^4.7.2
  cloud_firestore: ^4.8.4
  firebase_storage: ^11.2.5
  firebase_messaging: ^14.6.5  # For push notifications
  firebase_analytics: ^10.4.4  # For app analytics
```

## Step 4: Initialize Firebase in Your App

The app's `main.dart` file should already contain Firebase initialization code:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

## Step 5: Test Firebase Connection

1. Run the app in debug mode:
   ```bash
   flutter run
   ```

2. Try to sign in or create an account
3. Check the Firebase Console to see if the user appears in Authentication

## Step 6: Set Up Firebase Indexes

For complex queries, you may need to set up Firestore indexes:

1. When you run a query that requires an index, Firestore will show an error with a link
2. Click the link to create the required index
3. Alternatively, create a `firestore.indexes.json` file:

```json
{
  "indexes": [
    {
      "collectionGroup": "appointments",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "clinicId", "order": "ASCENDING" },
        { "fieldPath": "startTime", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "appointments",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "doctorId", "order": "ASCENDING" },
        { "fieldPath": "startTime", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "appointments",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "patientId", "order": "ASCENDING" },
        { "fieldPath": "startTime", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "prescriptions",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "patientId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "issueDate", "order": "DESCENDING" }
      ]
    }
  ]
}
```

4. Deploy indexes using Firebase CLI:
   ```bash
   firebase deploy --only firestore:indexes
   ```

## Step 7: Configure Firebase Analytics (Optional)

1. Analytics is automatically enabled when you add the Firebase Analytics package
2. Custom events can be logged using:
   ```dart
   FirebaseAnalytics.instance.logEvent(
     name: 'appointment_booked',
     parameters: {
       'clinic_id': clinicId,
       'doctor_id': doctorId,
     },
   );
   ```

## Step 8: Set Up Firebase Crashlytics (Optional)

1. Add the dependency to `pubspec.yaml`:
   ```yaml
   dependencies:
     firebase_crashlytics: ^3.3.4
   ```

2. Initialize Crashlytics in `main.dart`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     
     // Pass all uncaught errors to Crashlytics
     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
     
     runApp(const MyApp());
   }
   ```

## Troubleshooting

- **Authentication Issues**: Check Firebase Authentication console for error logs
- **Firestore Access Denied**: Review security rules and ensure user roles are set correctly
- **Missing google-services.json**: Verify the file is in the correct location and matches your package name
- **Firebase Initialization Failed**: Check that your Firebase project is properly configured and the app is registered

## Security Best Practices

1. **Never hardcode API keys** in your app code
2. Implement proper **user authentication** and **authorization**
3. Use **security rules** to protect your data
4. Validate all data on the server side
5. Implement **proper error handling** to avoid exposing sensitive information
6. Use **Firebase App Check** to prevent abuse of your backend resources

## Performance Considerations

1. Use **offline persistence** for Firestore (already implemented in the app)
2. Implement **pagination** for large data sets
3. Use **Firebase Performance Monitoring** to track app performance
4. Optimize image uploads by resizing before uploading to Firebase Storage
