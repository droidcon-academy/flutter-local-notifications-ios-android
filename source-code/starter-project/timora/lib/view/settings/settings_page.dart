import 'package:flutter/material.dart';
import 'package:timora/core/view/widgets/widgets.dart';
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ModernAppBar(title: 'Notification Settings'),
      body: GradientBackground(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20.0, 120.0, 20.0, 20.0),
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _isPermissionGranted ? null : _checkPermission,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                theme.colorScheme.surface,
                                theme.colorScheme.surface.withValues(
                                  alpha: 0.95,
                                ),
                              ],
                            ),
                            border: Border.all(
                              color:
                                  _isPermissionGranted
                                      ? theme.colorScheme.primary.withValues(
                                        alpha: 0.3,
                                      )
                                      : theme.colorScheme.error.withValues(
                                        alpha: 0.3,
                                      ),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          _isPermissionGranted
                                              ? theme.colorScheme.primary
                                                  .withValues(alpha: 0.1)
                                              : theme.colorScheme.error
                                                  .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _isPermissionGranted
                                          ? Icons.notifications_active
                                          : Icons.notifications_off,
                                      color:
                                          _isPermissionGranted
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.error,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notification Permission',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.onSurface,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _isPermissionGranted
                                              ? 'Permission granted'
                                              : 'Permission required for notifications',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                _isPermissionGranted
                                                    ? theme.colorScheme.primary
                                                        .withValues(alpha: 0.8)
                                                    : theme.colorScheme.error
                                                        .withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          _isPermissionGranted
                                              ? theme.colorScheme.primary
                                                  .withValues(alpha: 0.1)
                                              : theme.colorScheme.error
                                                  .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _isPermissionGranted
                                          ? Icons.check_circle
                                          : Icons.warning,
                                      color:
                                          _isPermissionGranted
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.error,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                              if (!_isPermissionGranted) ...[
                                const SizedBox(height: 16),
                                StyledButton(
                                  label: 'Request Permission',
                                  icon: Icons.app_settings_alt,
                                  onPressed: _checkPermission,
                                  width: double.infinity,
                                  height: 48,
                                  borderRadius: 12,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
