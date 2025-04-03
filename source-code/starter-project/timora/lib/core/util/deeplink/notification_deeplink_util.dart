import 'package:timora/core/router/app_routes_enum.dart';

// TODO: This utility class handles deeplinks for notifications
// You'll use this to create deeplinks that can be included in notifications
// and to handle navigation when a user taps on a notification

/// Utility class for generating and parsing notification deeplinks
///
/// This class provides methods to create and parse deeplinks specifically for notifications.
/// It handles the format 'timora:/notification-details?id=123' where 123 is the notification ID.
///
/// Usage:
/// - Generate a deeplink: NotificationDeepLinkUtil.generateNotificationDetailsDeepLink(123)
/// - Extract ID from URI: NotificationDeepLinkUtil.extractNotificationId(uri)
class NotificationDeepLinkUtil {
  // Private constructor for utility class
  NotificationDeepLinkUtil._();

  /// The scheme used for deeplinks in the app
  static const String scheme = 'timora';

  /// Generates a deeplink for a notification details page
  ///
  /// Creates a properly formatted URI string that can be stored in a notification payload
  /// and later used to navigate to the notification details page.
  ///
  /// @param notificationId The ID of the notification to view
  /// @return A deeplink URI string in the format 'timora:/notification-details?id=123'
  static String generateNotificationDetailsDeepLink(int notificationId) {
    return '$scheme:${AppRoutes.notificationDetails.value}?id=$notificationId';
  }

  /// Extracts a notification ID from a deeplink URI
  ///
  /// Parses a URI and extracts the notification ID from the query parameters.
  /// Returns null if the URI is not for the notification details page or if the ID is invalid.
  ///
  /// @param uri The URI to parse
  /// @return The notification ID as an integer, or null if not found/invalid
  static int? extractNotificationId(Uri uri) {
    if (uri.path == AppRoutes.notificationDetails.value) {
      final idParam = uri.queryParameters['id'];
      if (idParam != null) {
        return int.tryParse(idParam);
      }
    }
    return null;
  }
}
