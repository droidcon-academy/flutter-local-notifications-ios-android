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

    // TODO: Implement notification creation and display
    // 1. Create a notification builder using the form data
    // 2. Show the notification using the builder
    // 3. Handle any errors that might occur during notification creation
    // 4. Provide feedback to the user about the notification status

    // TODO: Uncomment and implement the following code
    // final builder = _controller.prepareNotification();
    // await builder.show();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification scheduled successfully!')),
      );
    }
  }

  // Show progress notification with UI feedback
  Future<void> _showProgressNotification() async {
    // TODO: Implement progress notification
    // 1. Create an initial notification with 0% progress
    // 2. Show the notification
    // 3. Update the progress periodically
    // 4. Create and show updated notifications with new progress values
    // 5. Provide feedback when the progress is complete

    // TODO: Uncomment and implement the following code
    // Show initial notification with 0% progress
    // var builder = _controller.createProgressNotification(
    //   progress: 0,
    //   maxProgress: 100,
    // );
    // await builder.show();

    // Update progress every second
    for (int progress = 10; progress <= 100; progress += 10) {
      // Wait a second
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Uncomment and implement the following code
      // Update the notification with new progress
      // builder = _controller.createProgressNotification(
      //   progress: progress,
      //   maxProgress: 100,
      // );
      // await builder.show();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress notification completed')),
      );
    }
  }

  // Show group notification with UI feedback
  Future<void> _showGroupNotification() async {
    // TODO: Implement group notification
    // 1. Define a group key for the notification group
    // 2. Create multiple notification builders for the group
    // 3. Create a group notification with a summary
    // 4. Provide feedback when the group notification is sent

    // TODO: Uncomment and implement the following code
    // const String groupKey = 'com.timora.notification.experiments';
    // final notifications = await _controller.createGroupNotificationBuilders();

    // Create the group
    // await _controller.notificationManager.createGroupNotification(
    //   groupKey: groupKey,
    //   channelId: _controller.value.channelId,
    //   groupTitle: 'Message Group',
    //   groupSummary: '${notifications.length} new messages',
    //   notifications: notifications,
    // );

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
                padding: const EdgeInsets.fromLTRB(20.0, 120.0, 20.0, 20.0),
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
