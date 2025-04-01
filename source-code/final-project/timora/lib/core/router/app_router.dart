import 'package:flutter/material.dart';
import 'package:timora/core/router/app_routes_enum.dart';
import 'package:timora/view/create-notification/create_notification_page.dart';
import 'package:timora/view/home/home_page.dart';
import 'package:timora/view/settings/settings_page.dart';
import 'package:timora/view/notification-details/notification_details_page.dart';

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void navigateTo(String routeName, {Object? arguments}) {
    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushNamed(routeName, arguments: arguments);
    } else {
      debugPrint('Navigator state not available');
    }
  }

  static Route onGenerateRoute(RouteSettings routeSettings) {
    if (routeSettings.name == null) {
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const Scaffold(),
      );
    }

    final route = AppRoutes.fromName(routeSettings.name!);

    switch (route) {
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => const HomePage(),
        );
      case AppRoutes.createNotification:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => const CreateNotificationPage(),
        );
      case AppRoutes.notificationDetails:
        final notificationId = routeSettings.arguments as int;
        return MaterialPageRoute(
          settings: routeSettings,
          builder:
              (context) =>
                  NotificationDetailsPage(notificationId: notificationId),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => const SettingsPage(),
        );
    }
  }
}
