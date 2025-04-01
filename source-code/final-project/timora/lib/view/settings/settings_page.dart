import 'package:flutter/material.dart';
import 'package:timora/core/view/widgets/timora_app_bar.dart';
import 'package:timora/service/notification-manager/notification_manager.dart';

/// A simple settings page that displays and manages notification permissions.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _notificationManager = NotificationManager();
  bool _isPermissionGranted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  /// Checks the current notification permission status
  Future<void> _checkPermission() async {
    setState(() => _isLoading = true);

    try {
      final granted = await _notificationManager.requestPermissions();
      if (!mounted) return;

      setState(() {
        _isPermissionGranted = granted;
        _isLoading = false;
      });

      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification permission denied')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check permissions: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const TimoraAppBar(title: 'Notification Settings', actions: []),
    body:
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: const Text(
                    'Notification Permission',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _isPermissionGranted
                        ? 'Permission granted'
                        : 'Permission required for notifications',
                    style: TextStyle(
                      color:
                          _isPermissionGranted
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                    ),
                  ),
                  trailing: Icon(
                    _isPermissionGranted ? Icons.check_circle : Icons.warning,
                    color:
                        _isPermissionGranted
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                  ),
                  onTap: _isPermissionGranted ? null : _checkPermission,
                ),
              ),
            ),
  );
}
