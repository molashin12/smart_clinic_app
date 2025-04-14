# Android Deployment Guide for Smart Clinic Management App

This guide provides instructions for deploying the Smart Clinic Management App to the Google Play Store.

## Prerequisites

- Google Play Developer account ($25 one-time fee)
- Keystore file for signing the app
- Flutter SDK installed and configured

## Step 1: Update Android Package Name

The package name has been set to `com.drmolashin.smartclinic` as requested. This is configured in the following files:

- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/debug/AndroidManifest.xml`
- `android/app/src/profile/AndroidManifest.xml`

## Step 2: Generate a Keystore File

If you don't already have a keystore file for signing your app, you can generate one using the following command:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

You'll be prompted to create a password and provide some information. Remember to keep this keystore file and password secure.

## Step 3: Configure Signing in Gradle

1. Create a file named `key.properties` in the `android/` folder with the following content:

```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<path to the keystore file, e.g., /path/to/upload-keystore.jks>
```

2. The `android/app/build.gradle` file has already been configured to use this key.properties file for signing.

## Step 4: Update App Information

1. Update the app version in `pubspec.yaml`:

```yaml
version: 1.0.0+1  # Format is version_name+version_code
```

2. Update app icons:
   - Replace the icons in `android/app/src/main/res/mipmap-*` folders with your custom icons
   - You can use tools like [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) to generate icons

3. Update app name:
   - The app name is set in `android/app/src/main/AndroidManifest.xml`
   - It can also be set in `android/app/src/main/res/values/strings.xml`

## Step 5: Build the Release APK/App Bundle

### Option 1: Build an APK

```bash
flutter build apk --release
```

The APK will be created at `build/app/outputs/flutter-apk/app-release.apk`

### Option 2: Build an App Bundle (Recommended for Play Store)

```bash
flutter build appbundle
```

The App Bundle will be created at `build/app/outputs/bundle/release/app-release.aab`

## Step 6: Test the Release Build

Before uploading to the Play Store, test the release build on a real device:

```bash
flutter install
```

## Step 7: Prepare Store Listing

Prepare the following assets for your Google Play Store listing:

1. **Screenshots**: At least 2 screenshots for each device type (phone, tablet, etc.)
2. **Feature Graphic**: 1024 x 500 px image
3. **App Icon**: 512 x 512 px image
4. **Privacy Policy URL**: Required for apps that request sensitive permissions
5. **App Description**: Full description and short description
6. **Release Notes**: What's new in this version

## Step 8: Upload to Google Play Console

1. Sign in to the [Google Play Console](https://play.google.com/console)
2. Create a new app
3. Fill in the store listing details
4. Upload your App Bundle or APK
5. Set up pricing and distribution
6. Submit for review

## Additional Considerations

### Firebase Configuration

Make sure to add your `google-services.json` file to the `android/app/` directory. This file can be downloaded from your Firebase project console.

### App Permissions

Review the permissions in `android/app/src/main/AndroidManifest.xml` to ensure they match what your app needs:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### App Signing by Google Play

Consider using App Signing by Google Play for enhanced security. When you upload your first App Bundle, you'll be prompted to enroll in this program.

### In-App Purchases (if applicable)

If you plan to implement the freemium model with in-app purchases, you'll need to configure products in the Google Play Console and integrate the Google Play Billing library.

### App Bundle Exploration

You can inspect your App Bundle using the [bundletool](https://developer.android.com/studio/command-line/bundletool):

```bash
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=build/app/outputs/bundle/release/app-release.apks
```

## Troubleshooting

- If you encounter signing issues, verify your key.properties file and keystore path
- For build failures, check the Flutter doctor output: `flutter doctor -v`
- For Google Play rejections, carefully read the rejection reason and address the specific concerns
