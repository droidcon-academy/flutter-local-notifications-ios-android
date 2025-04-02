// Deeplink handling implementation
//
// Flow diagram:
//
// External Deeplinks:                 Notification Deeplinks:
// [Browser/Other App]                [Notification Tap]
//         |                                  |
//         v                                  v
// [app_links package]                [Extract deeplink from payload]
//         |                                  |
//         v                                  v
// [_handleDeepLink]                 [handleNotificationDeeplink]
//         |                                  |
//         |                                  |
//         v                                  v
//         +--------> [processDeepLink] <----+
//                           |
//                           v
//                    [_parseDeepLink]
//                           |
//                           v
//                    [AppRouter.navigateTo]

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:timora/core/router/app_router.dart';
import 'package:timora/core/router/app_routes_enum.dart';
import 'package:timora/core/util/notification_deeplink_util.dart';

/// Handles deep link navigation within the app
///
/// This handler supports two types of deeplinks with a centralized processing approach:
/// 1. External deeplinks - from browsers, other apps, etc. (using app_links package)
/// 2. Notification deeplinks - from tapping on notifications
///
/// Both types of deeplinks use the same processing logic, ensuring consistent behavior.
/// External deeplinks are handled automatically when the app is launched or receives a link.
/// Notification deeplinks are processed when handleNotificationDeeplink is called from the notification tap handler.
class DeepLinkHandler {
  // Private constructor for singleton pattern
  DeepLinkHandler._();

  // Singleton instance using static field with factory constructor
  static final DeepLinkHandler instance = DeepLinkHandler._();

  // App links instance for handling external deep links
  final AppLinks _appLinks = AppLinks();

  /// Initialize deep link handling - should be called on app startup
  ///
  /// This sets up listeners for external deeplinks (from browsers, other apps, etc.)
  /// Notification deeplinks don't need initialization as they're handled directly.
  void init() {
    _handleInitialLink();
    _listenForLinks();
  }

  /// Sets up a listener for incoming external deep links while the app is running
  ///
  /// This is only for links coming from outside the app (browsers, other apps, etc.)
  /// Notification deeplinks are handled separately.
  void _listenForLinks() {
    _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) {
        debugPrint('Error handling external deep link: $err');
      },
    );
  }

  /// Handle initial deep link when app is launched from an external link
  ///
  /// This is called when the app is launched from a link in a browser or another app.
  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('App launched from deeplink: $initialUri');
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Error handling initial deep link: $e');
    }
  }

  /// Process the deep link from external sources (browsers, other apps)
  ///
  /// This is an internal method called when a deeplink is received from app_links.
  void _handleDeepLink(Uri uri) {
    debugPrint('Processing external deeplink: $uri');
    // Use the shared processing logic
    processDeepLink(uri);
  }

  /// Handle a deeplink from a notification payload
  ///
  /// This is a public method that can be called directly when a notification is tapped.
  /// It takes a deeplink URI string from the notification payload and processes it.
  ///
  /// @param deeplinkUri The URI string from the notification payload
  void handleNotificationDeeplink(String? deeplinkUri) {
    if (deeplinkUri == null) return;

    try {
      final uri = Uri.parse(deeplinkUri);
      debugPrint('Processing notification deeplink: $uri');
      // Use the shared processing logic
      processDeepLink(uri);
    } catch (e) {
      debugPrint('Error parsing notification deeplink URI: $e');
      // Navigate to home as fallback
      AppRouter.navigateTo('/');
    }
  }

  /// Shared processing logic for all deeplinks
  ///
  /// This centralizes the deeplink processing logic for both external and notification deeplinks.
  /// It parses the URI, extracts the path and arguments, and navigates to the appropriate screen.
  ///
  /// @param uri The URI to process
  void processDeepLink(Uri uri) {
    try {
      final DeepLinkData linkData = _parseDeepLink(uri);
      debugPrint(
        'Navigating to: ${linkData.path} with arguments: ${linkData.arguments}',
      );

      // Use AppRouter's navigation method
      AppRouter.navigateTo(linkData.path, arguments: linkData.arguments);
    } catch (e) {
      debugPrint('Error processing deeplink: $e');
      // Navigate to home as fallback
      AppRouter.navigateTo('/');
    }
  }

  /// Parse the URI into structured deep link data
  ///
  /// This method extracts the path and arguments from a URI and handles special cases
  /// like notification details where we need to extract the ID as an integer.
  ///
  /// @param uri The URI to parse
  /// @return A DeepLinkData object with the path and arguments
  DeepLinkData _parseDeepLink(Uri uri) {
    // Default to '/' if path is empty
    final String path = uri.path.isEmpty ? '/' : uri.path;
    Object? arguments =
        uri.queryParameters.isNotEmpty ? uri.queryParameters : null;

    // Handle notification details deeplink
    if (path == AppRoutes.notificationDetails.value) {
      final notificationId = NotificationDeepLinkUtil.extractNotificationId(
        uri,
      );
      if (notificationId != null) {
        // Replace the arguments with just the ID as an integer
        arguments = notificationId;
      }
    }

    // Add special handling for other routes here if needed

    return DeepLinkData(path: path, arguments: arguments);
  }
}

/// Data class to store parsed deep link information
///
/// This simple class holds the path and arguments extracted from a deeplink URI.
/// It's used to pass this information to the AppRouter for navigation.
class DeepLinkData {
  /// The path to navigate to (e.g., '/notification-details')
  final String path;

  /// Arguments to pass to the route (can be a Map for query parameters or a specific value)
  final Object? arguments;

  DeepLinkData({required this.path, this.arguments});
}
