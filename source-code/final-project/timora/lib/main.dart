import 'package:flutter/material.dart';
import 'package:timora/service/notification_manager.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationManager().init();

    runApp(const MaterialApp(home: Scaffold()));
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

// void main() async {
//   try {
//     WidgetsFlutterBinding.ensureInitialized();
//     await NotificationManager().init();

//     runApp(const App());
//   } catch (e) {
//     runApp(
//       MaterialApp(
//         home: Scaffold(
//           body: Center(child: Text('Failed to initialize app: $e')),
//         ),
//       ),
//     );
//   }
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: AppRoutes.home.value,
//       onGenerateRoute: AppRouter.onGenerateRoute,
//     );
//   }
// }
