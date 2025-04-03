# Timora - Flutter Local Notifications Starter Project

This is a starter project for the "Mastering Flutter Local Notifications" codelab. In this codelab, you'll learn how to implement various types of local notifications in a Flutter app, including instant, scheduled, and periodic notifications.

## Project Structure

This starter project includes a complete UI and basic app structure. Your task will be to implement the notification functionality throughout the codelab. The project contains TODOs throughout the codebase to guide you on what needs to be implemented.

### Key Files to Modify

1. **lib/main.dart**
   - Initialize the notification manager
   - Set up the app to handle notifications

2. **lib/service/notification-manager/notification_manager.dart**
   - This is the main class for managing notifications
   - Implement methods for showing different types of notifications
   - Set up notification channels and permissions

3. **lib/service/notification-manager/notification_builder.dart**
   - A builder class that provides a fluent API for configuring notifications
   - Implement methods for building different types of notifications

4. **lib/view/create-notification/create_notification_page.dart**
   - Implement the UI logic for creating notifications
   - Connect the UI to the notification manager

5. **lib/view/home/home_page.dart**
   - Implement loading and managing notifications
   - Handle notification deletion

6. **lib/view/notification-details/notification_details_page.dart**
   - Implement loading notification details
   - Handle updating and deleting notifications

7. **android/app/src/main/AndroidManifest.xml**
   - Add required permissions and receivers for Android notifications

8. **ios/Runner/AppDelegate.swift**
   - Configure iOS-specific notification settings

9. **ios/Runner/Info.plist**
   - Add required permission strings for iOS notifications

## Getting Started

1. Make sure you have Flutter installed and set up on your machine
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Follow the codelab instructions to implement the notification features

## TODOs in the Codebase

The project contains numerous TODOs to guide your implementation. Here are the main categories:

### Initialization and Setup
- Initialize the notification manager in main.dart
- Set up time zones for scheduled notifications
- Configure notification channels for Android
- Request notification permissions

### Basic Notifications
- Implement instant notifications
- Configure notification details (importance, priority, etc.)
- Handle notification taps and actions

### Advanced Notifications
- Implement scheduled notifications with time zone awareness
- Create periodic notifications that repeat at fixed intervals
- Build progress notifications with updating progress bars
- Create grouped notifications for related content

### Platform-Specific Configuration
- Configure Android notification channels and permissions
- Set up iOS notification categories and actions
- Handle platform-specific notification behaviors

## Features to Implement

- Basic notification initialization and permission handling
- Instant notifications with various customization options
- Scheduled notifications with time zone awareness
- Periodic notifications that repeat at fixed intervals
- Progress notifications with updating progress bars
- Grouped notifications for related content
- Notification actions and interaction handling
- Platform-specific configurations for Android and iOS

## Resources

- [Flutter Local Notifications Plugin](https://pub.dev/packages/flutter_local_notifications)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Android Notification Documentation](https://developer.android.com/develop/ui/views/notifications)
- [iOS Notification Documentation](https://developer.apple.com/documentation/usernotifications)
- [Don't Kill My App](https://dontkillmyapp.com/) - For handling device-specific notification issues
