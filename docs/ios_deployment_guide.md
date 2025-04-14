# iOS Deployment Guide for Smart Clinic Management App

This guide provides instructions for deploying the Smart Clinic Management App to the Apple App Store once you have an Apple Developer account.

## Prerequisites

- Apple Developer account ($99/year)
- Mac computer with Xcode installed
- Flutter SDK installed and configured
- Physical iOS device for testing (optional but recommended)

## Step 1: Configure iOS Bundle Identifier

The bundle identifier should be set to match your Android package name for consistency. In this case, we'll use `com.drmolashin.smartclinic`.

1. Open the file `ios/Runner/Info.plist` and update the bundle identifier:

```xml
<key>CFBundleIdentifier</key>
<string>com.drmolashin.smartclinic</string>
```

2. Also update it in `ios/Runner.xcodeproj/project.pbxproj` by searching for `PRODUCT_BUNDLE_IDENTIFIER` and updating all occurrences.

## Step 2: Set Up Signing in Xcode

Once you have an Apple Developer account:

1. Open the iOS project in Xcode:
   ```bash
   cd ios
   open Runner.xcworkspace
   ```

2. In Xcode, select the "Runner" project in the left sidebar
3. Select the "Runner" target
4. Go to the "Signing & Capabilities" tab
5. Check "Automatically manage signing"
6. Select your Team (Apple Developer account)

## Step 3: Update App Information

1. Update the app version in `pubspec.yaml`:
   ```yaml
   version: 1.0.0+1  # Format is version_name+version_code
   ```

2. Update app icons:
   - Replace the icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset`
   - You can use tools like [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) to generate icons

3. Update app name:
   - The app name is set in `ios/Runner/Info.plist` under `CFBundleName` and `CFBundleDisplayName`

## Step 4: Configure Firebase for iOS

1. Download the `GoogleService-Info.plist` file from your Firebase project
2. Add it to the iOS project using Xcode (right-click on Runner folder, select "Add Files to 'Runner'...")
3. Make sure to select "Copy items if needed" and add to the main target

## Step 5: Build and Test the iOS App

1. Connect an iOS device or use a simulator
2. Build and run the app in debug mode first:
   ```bash
   flutter run -d ios
   ```

3. Then build the release version:
   ```bash
   flutter build ios --release
   ```

## Step 6: Archive and Upload to App Store Connect

1. In Xcode, select "Product" > "Archive"
2. Once the archive is created, the Xcode Organizer will open
3. Click "Distribute App"
4. Select "App Store Connect" and follow the prompts
5. Choose to upload the app to App Store Connect
6. Complete the upload process

## Step 7: Configure App Store Connect

1. Sign in to [App Store Connect](https://appstoreconnect.apple.com/)
2. Create a new app if this is the first version
3. Fill in all required metadata:
   - Screenshots (at least one for each device type)
   - App description
   - Keywords
   - Support URL
   - Privacy Policy URL
   - App Review Information
   - Version information

4. Set up pricing and availability
5. Submit for review

## Additional Considerations

### App Store Review Guidelines

Review the [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) to ensure your app complies with Apple's policies. Healthcare apps often receive additional scrutiny.

### Privacy Policy

A privacy policy is required for all apps on the App Store. Make sure yours addresses:
- What data you collect
- How you use the data
- How users can request data deletion
- Compliance with healthcare regulations (HIPAA, GDPR, etc.)

### App Tracking Transparency

If your app tracks users across apps and websites, you need to implement App Tracking Transparency and request permission:

```swift
// Add to your Info.plist
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized services to you.</string>
```

### In-App Purchases (if applicable)

If you plan to implement the freemium model with in-app purchases, you'll need to configure products in App Store Connect and integrate the StoreKit framework.

### TestFlight

Consider using TestFlight for beta testing before submitting to the App Store:
1. Upload your build to App Store Connect
2. Enable it for TestFlight testing
3. Add internal and external testers
4. Gather feedback before the official release

## Troubleshooting

- If you encounter signing issues, verify your Apple Developer account status and provisioning profiles
- For build failures, check the Flutter doctor output: `flutter doctor -v`
- For App Store rejections, carefully read the rejection reason and address the specific concerns
- If your app uses encryption, you may need to provide documentation for export compliance
