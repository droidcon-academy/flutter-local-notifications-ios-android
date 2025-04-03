import 'package:flutter/material.dart';
import 'package:timora/core/router/app_router.dart';
import 'package:timora/core/router/app_routes_enum.dart';
import 'package:timora/core/theme/theme_provider.dart';
import 'package:timora/core/util/deeplink/deeplink_handler.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // TODO: Initialize notification manager
    // This is where you'll initialize the notification system
    // Uncomment the line below when you've implemented the notification manager
    // await NotificationManager().init();

    // Initialize deep link handler
    DeepLinkHandler.instance.init();

    runApp(const App());
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Failed to initialize app: $e')),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: AppRoutes.home.value,
      onGenerateRoute: AppRouter.onGenerateRoute,
      theme: ThemeProvider.getLightTheme(),
      darkTheme: ThemeProvider.getDarkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: 'Timora',
    );
  }
}
