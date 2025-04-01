import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:timora/core/router/app_router.dart';

/// Handles deep link navigation within the app
class DeepLinkHandler {
  // Private constructor for singleton pattern
  DeepLinkHandler._();

  // Singleton instance using static field with factory constructor
  static final DeepLinkHandler instance = DeepLinkHandler._();

  // App links instance for handling deep links
  final AppLinks _appLinks = AppLinks();

  /// Initialize deep link handling - should be called on app startup
  void init() {
    _handleInitialLink();
    _listenForLinks();
  }

  /// Sets up a listener for incoming deep links while the app is running
  void _listenForLinks() {
    _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) {
        debugPrint('Error handling deep link: $err');
      },
    );
  }

  /// Handle initial deep link when app is launched from a link
  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Error handling initial deep link: $e');
    }
  }

  /// Process the deep link and navigate to appropriate route
  void _handleDeepLink(Uri uri) {
    debugPrint('Received deep link: $uri');

    final DeepLinkData linkData = _parseDeepLink(uri);

    // Use AppRouter's navigation method
    AppRouter.navigateTo(linkData.path, arguments: linkData.arguments);
  }

  /// Parse the URI into structured deep link data
  DeepLinkData _parseDeepLink(Uri uri) {
    // Default to '/' if path is empty
    final String path = uri.path.isEmpty ? '/' : uri.path;

    return DeepLinkData(path: path, arguments: uri.queryParameters);
  }
}

/// Data class to store parsed deep link information
class DeepLinkData {
  final String path;
  final Object? arguments;

  DeepLinkData({required this.path, this.arguments});
}
