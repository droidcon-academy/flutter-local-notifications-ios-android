import Flutter
import UIKit

// TODO: Import the flutter_local_notifications package
// import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // TODO: Set up notification handling for iOS
    // 1. Register plugin for action isolate
    // 2. Set up notification delegate for iOS 10+
    // Example:
    // FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    //     GeneratedPluginRegistrant.register(with: registry)
    // }
    //
    // if #available(iOS 10.0, *) {
    //   UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    // }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
