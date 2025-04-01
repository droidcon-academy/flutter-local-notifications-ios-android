import 'package:flutter/material.dart';
import 'package:timora/service/create-notification/create_notification_controller.dart';
import 'package:timora/view/create-notification/widgets/additional_options_section.dart';
import 'package:timora/view/create-notification/widgets/basic_info_section.dart';
import 'package:timora/view/create-notification/widgets/category_section.dart';
import 'package:timora/view/create-notification/widgets/experiments_section.dart';
import 'package:timora/view/create-notification/widgets/notification_type_section.dart';
import 'package:timora/view/create-notification/widgets/priority_section.dart';

class CreateNotificationPage extends StatefulWidget {
  const CreateNotificationPage({super.key});

  @override
  State<CreateNotificationPage> createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  late final CreateNotificationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CreateNotificationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // UI helper methods - moved from controller
  void _showValidationError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null && mounted) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        _controller.setScheduledDateTime(dateTime);
      }
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      _controller.setRecurringTime(time);
    }
  }

  // Schedule notification with UI feedback
  Future<void> _scheduleNotification() async {
    if (!_controller.formKey.currentState!.validate()) return;

    // Validate fields based on notification type
    final validationResult = _controller.validateNotificationFields();
    if (!validationResult.isValid) {
      _showValidationError(validationResult.errorMessage!);
      return;
    }

    // Get prepared notification and show it
    final builder = _controller.prepareNotification();
    await builder.show();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification scheduled successfully!')),
      );
    }
  }

  // Show progress notification with UI feedback
  Future<void> _showProgressNotification() async {
    // Show initial notification with 0% progress
    var builder = _controller.createProgressNotification(
      progress: 0,
      maxProgress: 100,
    );
    await builder.show();

    // Update progress every second
    for (int progress = 10; progress <= 100; progress += 10) {
      // Wait a second
      await Future.delayed(const Duration(seconds: 1));

      // Update the notification with new progress
      builder = _controller.createProgressNotification(
        progress: progress,
        maxProgress: 100,
      );
      await builder.show();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress notification completed')),
      );
    }
  }

  // Show group notification with UI feedback
  Future<void> _showGroupNotification() async {
    const String groupKey = 'com.timora.notification.experiments';
    final notifications = await _controller.createGroupNotificationBuilders();

    // Create the group
    await _controller.notificationManager.createGroupNotification(
      groupKey: groupKey,
      channelId: _controller.value.channelId,
      groupTitle: 'Message Group',
      groupSummary: '${notifications.length} new messages',
      notifications: notifications,
    );

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Group notification sent')));
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Notification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
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
        child: ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, formData, _) {
            return Form(
              key: _controller.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard('Basic Information', [
                      BasicInfoSection(controller: _controller),
                    ]),
                    _buildCard('Notification Type', [
                      NotificationTypeSection(
                        controller: _controller,
                        onDateTimePicked: _pickDate,
                        onTimePicked: _pickTime,
                      ),
                    ]),
                    _buildCard('Category', [
                      CategorySection(controller: _controller),
                    ]),
                    _buildCard('Priority', [
                      PrioritySection(controller: _controller),
                    ]),
                    _buildCard('Additional Options', [
                      AdditionalOptionsSection(controller: _controller),
                    ]),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.schedule),
                        label: const Text(
                          'SCHEDULE NOTIFICATION',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _scheduleNotification,
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
                    const SizedBox(height: 24),
                    _buildCard('Experiments', [
                      ExperimentsSection(
                        onProgressTest: _showProgressNotification,
                        onGroupTest: _showGroupNotification,
                      ),
                    ]),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
