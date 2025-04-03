import 'package:flutter/material.dart';
import 'package:timora/core/view/widgets/widgets.dart';
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

  Widget _buildCard(String title, List<Widget> children, {IconData? icon}) {
    return ModernCard(
      title: title,
      icon: icon ?? Icons.info_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
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
      return Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ModernAppBar(
        title: 'Notification Details',
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error,
              size: 24,
            ),
            tooltip: 'Delete notification',
            onPressed: () async {
              await _notificationManager.cancelNotification(_notification!.id);
              if (context.mounted) Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard('Basic Information', [
                  StyledTextField(
                    controller: _titleController,
                    label: 'Title',
                    prefixIcon: Icons.title,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 20),
                  StyledTextField(
                    controller: _bodyController,
                    label: 'Message',
                    prefixIcon: Icons.message,
                    multiline: true,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Please enter a message' : null,
                  ),
                ], icon: Icons.edit_note),
                if (_notification!.type == NotificationType.scheduled)
                  _buildCard('Schedule', [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.15,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: Tooltip(
                          message: 'Change the scheduled date and time',
                          child: InkWell(
                            onTap: _pickDateTime,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _scheduledDateTime != null
                                        ? theme.colorScheme.primary.withValues(
                                          alpha: 0.05,
                                        )
                                        : theme
                                            .colorScheme
                                            .surfaceContainerLowest,
                                    _scheduledDateTime != null
                                        ? theme.colorScheme.primary.withValues(
                                          alpha: 0.1,
                                        )
                                        : theme
                                            .colorScheme
                                            .surfaceContainerLowest,
                                  ],
                                ),
                                border: Border.all(
                                  color:
                                      _scheduledDateTime != null
                                          ? theme.colorScheme.primary
                                              .withValues(alpha: 0.3)
                                          : theme.colorScheme.outlineVariant
                                              .withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          _scheduledDateTime != null
                                              ? theme.colorScheme.primary
                                                  .withValues(alpha: 0.1)
                                              : theme
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color:
                                          _scheduledDateTime != null
                                              ? theme.colorScheme.primary
                                              : theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _scheduledDateTime == null
                                              ? 'Select Date & Time'
                                              : 'Scheduled Date & Time',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color:
                                                _scheduledDateTime != null
                                                    ? theme.colorScheme.primary
                                                    : theme
                                                        .colorScheme
                                                        .onSurface,
                                          ),
                                        ),
                                        if (_scheduledDateTime != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            _formattedScheduledTime,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: theme.colorScheme.primary
                                                  .withValues(alpha: 0.8),
                                            ),
                                          ),
                                        ] else ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            'Tap to choose when to send the notification',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color:
                                        _scheduledDateTime != null
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurfaceVariant
                                                .withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ], icon: Icons.schedule),
                const SizedBox(height: 8),
                StyledButton(
                  label: 'Save Changes',
                  icon: Icons.save,
                  onPressed: _updateNotification,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                StyledButton(
                  label: 'Delete Notification',
                  icon: Icons.delete_outline,
                  onPressed: () async {
                    await _notificationManager.cancelNotification(
                      _notification!.id,
                    );
                    if (context.mounted) Navigator.pop(context, true);
                  },
                  type: StyledButtonType.danger,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
