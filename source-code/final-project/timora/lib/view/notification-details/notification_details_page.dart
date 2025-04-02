import 'package:flutter/material.dart';
import 'package:timora/core/view/widgets/timora_app_bar.dart';
import 'package:timora/service/notification-manager/notification_manager.dart';
import 'package:timora/model/notification_model.dart';

class NotificationDetailsPage extends StatefulWidget {
  final int notificationId;

  const NotificationDetailsPage({super.key, required this.notificationId});

  @override
  State<NotificationDetailsPage> createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  DateTime? _scheduledDateTime;
  NotificationModel? _notification;
  final NotificationManager _notificationManager = NotificationManager();

  @override
  void initState() {
    super.initState();
    _loadNotificationDetails();
  }

  Future<void> _loadNotificationDetails() async {
    final notifications = await _notificationManager.getPendingNotifications();
    final notification = notifications.firstWhere(
      (n) => n.id == widget.notificationId,
      orElse:
          () => NotificationModel(
            id: widget.notificationId,
            title: '',
            body: '',
            channelId: 'default',
            type: NotificationType.instant,
          ),
    );

    setState(() {
      _notification = notification;
      _titleController.text = notification.title;
      _bodyController.text = notification.body;
      _scheduledDateTime = notification.scheduledTime;
    });
  }

  Future<void> _updateNotification() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedNotification = _notification!.copyWith(
      title: _titleController.text,
      body: _bodyController.text,
      scheduledTime: _scheduledDateTime,
    );

    await _notificationManager.cancelNotification(_notification!.id);

    updatedNotification.type == NotificationType.scheduled &&
            updatedNotification.scheduledTime != null
        ? await _notificationManager.scheduleNotification(
          model: updatedNotification,
        )
        : await _notificationManager.showInstantNotification(
          model: updatedNotification,
        );

    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _scheduledDateTime ?? DateTime.now(),
        ),
      );

      if (time != null) {
        setState(() {
          _scheduledDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.brown),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  String get _formattedScheduledTime {
    if (_scheduledDateTime == null) return 'Select Date & Time';

    final date = _scheduledDateTime!;
    return 'Scheduled: ${date.day}/${date.month}/${date.year} at '
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_notification == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: TimoraAppBar(
        title: 'Notification Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _notificationManager.cancelNotification(_notification!.id);
              if (context.mounted) Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: .9),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard('Basic Information', [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bodyController,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      prefixIcon: const Icon(Icons.message),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Please enter a message' : null,
                  ),
                ]),
                if (_notification!.type == NotificationType.scheduled)
                  _buildCard('Schedule', [
                    Tooltip(
                      message: 'Change the scheduled date and time',
                      child: ElevatedButton.icon(
                        onPressed: _pickDateTime,
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_formattedScheduledTime),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ]),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'SAVE CHANGES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _updateNotification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text(
                      'DELETE NOTIFICATION',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      await _notificationManager.cancelNotification(
                        _notification!.id,
                      );
                      if (context.mounted) Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
