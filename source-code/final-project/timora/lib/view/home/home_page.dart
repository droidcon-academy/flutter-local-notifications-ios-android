import 'package:flutter/material.dart';
import 'package:timora/core/view/widgets/confirmation_dialog.dart';
import 'package:timora/core/view/widgets/empty_state.dart';
import 'package:timora/core/view/widgets/timora_app_bar.dart';
import 'package:timora/core/router/app_routes_enum.dart';
import 'package:timora/service/notification-manager/notification_manager.dart';
import 'package:timora/model/notification_model.dart';
import 'package:timora/view/home/widgets/notification_card.dart';

/// Displays the main home screen of the application.
///
/// Shows a list of scheduled notifications/reminders and allows users to
/// create, edit, or delete them.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomePageContent();
  }
}

class _HomePageContent extends StatefulWidget {
  const _HomePageContent();

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  final NotificationManager _notificationManager = NotificationManager();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // --- Data handling methods ---

  /// Loads all pending notifications from the notification manager.
  ///
  /// Updates the UI state based on the loading status and results. Handles
  /// errors by showing an error message to the user.
  Future<void> _loadNotifications() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final notifications =
          await _notificationManager.getPendingNotifications();

      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Failed to load notifications: ${e.toString()}');
      }
    }
  }

  /// Refreshes the notification list when pull-to-refresh is triggered.
  ///
  /// Returns a future that completes when the refresh operation is done.
  Future<void> _handleRefresh() async {
    return _loadNotifications();
  }

  /// Deletes a notification with the given ID after confirmation.
  ///
  /// Shows a confirmation dialog before proceeding with deletion. If confirmed,
  /// cancels the notification and refreshes the notification list.
  ///
  /// The [notificationId] is the unique identifier of the notification to delete.
  Future<void> _deleteNotification(int notificationId) async {
    final confirmed = await _showDeleteConfirmation();

    if (confirmed != true) return;

    try {
      await _notificationManager.cancelNotification(notificationId);
      await _loadNotifications();
    } catch (e) {
      _showErrorSnackBar('Failed to delete notification: ${e.toString()}');
    }
  }

  // --- UI feedback methods ---

  /// Displays an error message to the user in a snackbar.
  ///
  /// The [message] is the error text to display.
  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  /// Displays a confirmation dialog for deleting a notification.
  ///
  /// Returns a [Future] that completes with true if the user confirms the deletion,
  /// or false/null otherwise.
  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => const ConfirmationDialog(
            title: 'Delete Reminder',
            content: 'Are you sure you want to delete this reminder?',
            confirmText: 'Delete',
            isDestructive: true,
          ),
    );
  }

  // --- Navigation methods ---

  /// Navigates to the create notification screen.
  ///
  /// Refreshes the notification list when returning from the creation screen.
  void _navigateToCreate() {
    Navigator.pushNamed(
      context,
      AppRoutes.createNotification.value,
    ).then((_) => _loadNotifications());
  }

  /// Navigates to the notification details screen for a specific notification.
  ///
  /// If the notification was updated (result is true), refreshes the notification list.
  ///
  /// The [notificationId] is the unique identifier of the notification to view or edit.
  Future<void> _navigateToDetails(int notificationId) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.notificationDetails.value,
      arguments: notificationId,
    );

    if (result == true) {
      await _loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TimoraAppBar(title: 'Timora'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreate,
        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
      ),
      body: _buildBody(),
    );
  }

  /// Builds the main body content based on the loading state.
  ///
  /// Returns a loading indicator when data is being loaded, or a
  /// refreshable notification list when data is available.
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: _NotificationListView(
        notifications: _notifications,
        onEdit: _navigateToDetails,
        onDelete: _deleteNotification,
      ),
    );
  }
}

/// Displays either the notification list or an empty state view.
///
/// Shows an empty state with guidance when no notifications exist.
/// Otherwise displays a scrollable list of notification cards.
class _NotificationListView extends StatelessWidget {
  /// The list of notification models to display.
  final List<NotificationModel> notifications;

  /// Callback invoked when the user wants to edit a notification.
  final ValueChanged<int> onEdit;

  /// Callback invoked when the user wants to delete a notification.
  final ValueChanged<int> onDelete;

  const _NotificationListView({
    required this.notifications,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const EmptyState(
        icon: Icons.notifications_off_outlined,
        title: 'No reminders scheduled',
        subtitle: 'Tap + to add a new reminder',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationCard(
          key: ValueKey(notification.id),
          model: notification,
          onEdit: () => onEdit(notification.id),
          onDelete: () => onDelete(notification.id),
        );
      },
    );
  }
}
