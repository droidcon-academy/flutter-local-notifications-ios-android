# Timora - Flutter Local Notifications Starter Project

This is a starter project for the "Mastering Flutter Local Notifications" codelab. In this codelab, you'll learn how to implement various types of local notifications in a Flutter app, including instant, scheduled, and periodic notifications.

## Project Structure

This starter project includes a complete UI and basic app structure. Your task will be to implement the notification functionality throughout the codelab.

### Key Files to Modify

1. **lib/service/notification-manager/notification_manager.dart**
   - This is the main class for managing notifications
   - You'll implement methods for showing different types of notifications

2. **lib/service/notification-manager/notification_builder.dart**
   - A builder class that provides a fluent API for configuring notifications
   - You'll enhance this class to support various notification features

3. **android/app/src/main/AndroidManifest.xml**
   - You'll add required permissions and receivers for Android notifications

4. **ios/Runner/AppDelegate.swift**
   - You'll configure iOS-specific notification settings

5. **ios/Runner/Info.plist**
   - You'll add required permission strings for iOS notifications

## Getting Started

1. Make sure you have Flutter installed and set up on your machine
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Follow the codelab instructions to implement the notification features

## Features to Implement

- Basic notification initialization and permission handling
- Instant notifications with various customization options
- Scheduled notifications with time zone awareness
- Periodic notifications that repeat at fixed intervals
- Notification actions and interaction handling
- Platform-specific configurations for Android and iOS

## Resources

- [Flutter Local Notifications Plugin](https://pub.dev/packages/flutter_local_notifications)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Android Notification Documentation](https://developer.android.com/develop/ui/views/notifications)
- [iOS Notification Documentation](https://developer.apple.com/documentation/usernotifications)
- [Don't Kill My App](https://dontkillmyapp.com/) - For handling device-specific notification issues
