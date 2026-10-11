# Setup Guide

## Quick Start Options

### Option 1: Try the Sample APK (Fastest - No Setup Required)

If you just want to try the app without setting up the development environment:

1. **Download the APK**
   - [Download from Google Drive](https://drive.google.com/file/d/1OhM73hseBc9ct6qu2h_jMRe2eJfPWHyx/view?usp=drive_link)
   - Save the APK as `Mahder.apk` on your computer

2. **Install on Android Device**
   ```bash
    # Using ADB (if device is connected)
   adb install Mahder.apk
   ```

   Or manually:
   - Transfer the downloaded APK to your Android device
   - Enable "Install from Unknown Sources" in device settings
   - Open the APK file and install

3. **Launch the app** and start exploring!

### Option 2: Build from Source (For Development)

## Quick Setup (5 minutes)

### Prerequisites

- Flutter SDK 3.5.0+
- Dart SDK 3.5.0+
- Android Studio or Xcode
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/iCog-Labs-Dev/hyperdata-mobile.git
   cd hyperdata-mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   ```

   Edit `.env` and add your configuration:
   ```env
   API_BASE_URL=your_api_base_url
   ONESIGNAL_APP_ID=your_onesignal_app_id
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Environment Configuration

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `API_BASE_URL` | Backend API URL | `http://api.example.com/api` |
| `ONESIGNAL_APP_ID` | OneSignal App ID for push notifications | `your-app-id-here` |

The app loads `.env` from the project root. The same file is bundled as a Flutter asset and read by the Android Gradle configuration for the OneSignal App ID. Keep real environment values out of version control. This project does not define `.env.dev`, `.env.staging`, or `.env.prod` switching commands; configure the root `.env` for the build you are making.

## Platform-Specific Setup

### Android

1. **Minimum SDK**: API 21 (Android 5.0)
2. **Target SDK**: Latest stable

No additional configuration needed.

### iOS

1. **Minimum Version**: iOS 12.0
2. **Xcode**: Latest stable version

Open `ios/Runner.xcworkspace` in Xcode to build for iOS. The checked-in `load_env.sh` file is not wired into the Xcode build phases; Flutter loads the root `.env` as an asset at runtime.

## Verification

### Check Setup

```bash
# Verify Flutter installation
flutter doctor

# Check dependencies
flutter pub get

# Run analyzer
flutter analyze

# Run tests
flutter test
```

### Common Issues

#### "Environment variable not found"
- Ensure `.env` file exists in project root
- Check variable names match exactly
- Restart the app after changing `.env`

#### "Flutter doctor shows issues"
- Follow Flutter doctor recommendations
- Install missing dependencies
- Update Flutter SDK if needed

#### "Build fails"
- Run `flutter clean`
- Delete `pubspec.lock`
- Run `flutter pub get` again
- Try `flutter run --verbose` for detailed logs

## Next Steps

- Read [ARCHITECTURE.md](../ARCHITECTURE.md) to understand the codebase
- Check [API_DOCUMENTATION.md](../API_DOCUMENTATION.md) for API details
- See [CONTRIBUTING.md](../CONTRIBUTING.md) to start contributing

## Support

- Check [README.md](../README.md) for general information
- Review [API_DOCUMENTATION.md](../API_DOCUMENTATION.md) for API issues
- Open an issue on GitHub for bugs
- Join discussions for questions

---

**Need help?** Open an issue or start a discussion on GitHub.
