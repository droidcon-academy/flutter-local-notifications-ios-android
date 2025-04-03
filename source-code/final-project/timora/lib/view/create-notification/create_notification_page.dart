import 'package:flutter/material.dart';
import 'package:timora/core/view/widgets/widgets.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Theme.of(context).colorScheme.error,
        margin: const EdgeInsets.all(16),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ModernAppBar(title: 'Create Notification'),
      body: GradientBackground(
        child: ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, formData, _) {
            return Form(
              key: _controller.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard('Basic Information', [
                      BasicInfoSection(controller: _controller),
                    ], icon: Icons.edit_note),
                    _buildCard('Notification Type', [
                      NotificationTypeSection(
                        controller: _controller,
                        onDateTimePicked: _pickDate,
                        onTimePicked: _pickTime,
                      ),
                    ], icon: Icons.notifications_active),
                    _buildCard('Category', [
                      CategorySection(controller: _controller),
                    ], icon: Icons.category),
                    _buildCard('Priority', [
                      PrioritySection(controller: _controller),
                    ], icon: Icons.priority_high),
                    _buildCard('Additional Options', [
                      AdditionalOptionsSection(controller: _controller),
                    ], icon: Icons.settings),
                    const SizedBox(height: 16),
                    StyledButton(
                      label: 'Schedule Notification',
                      icon: Icons.schedule,
                      onPressed: _scheduleNotification,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 24),
                    _buildCard('Experiments', [
                      ExperimentsSection(
                        onProgressTest: _showProgressNotification,
                        onGroupTest: _showGroupNotification,
                      ),
                    ], icon: Icons.science),
                    const SizedBox(height: 16),
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
