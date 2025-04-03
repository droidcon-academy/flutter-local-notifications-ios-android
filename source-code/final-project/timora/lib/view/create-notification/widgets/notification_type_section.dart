import 'package:flutter/material.dart';
import 'package:timora/core/view/widgets/widgets.dart';
import 'package:timora/service/create-notification/create_notification_controller.dart';

class NotificationTypeSection extends StatelessWidget {
  final CreateNotificationController controller;
  final VoidCallback onDateTimePicked;
  final VoidCallback onTimePicked;

  const NotificationTypeSection({
    super.key,
    required this.controller,
    required this.onDateTimePicked,
    required this.onTimePicked,
  });

  Widget _buildNotificationTypeSelector(BuildContext context) {
    final mainTypes = ['Instant', 'Scheduled', 'Periodic'];

    return ChipSelector(
      options: mainTypes,
      selectedOption: controller.value.notificationType,
      onSelected: controller.updateNotificationType,
    );
  }

  Widget _buildPeriodicSubtypeSelector(BuildContext context) {
    if (controller.value.notificationType != 'Periodic') {
      return const SizedBox.shrink();
    }

    final periodicSubtypes = ['Daily', 'Weekly', 'Hourly', 'Every Minute'];
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.repeat,
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Repeat Frequency',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ChipSelector(
          options: periodicSubtypes,
          selectedOption: controller.value.periodicSubtype,
          onSelected: controller.updatePeriodicSubtype,
        ),
      ],
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    final formData = controller.value;

    // For scheduled notifications
    if (formData.notificationType == 'Scheduled') {
      final dateTime = formData.scheduledDateTime;
      String? subtitle;

      if (dateTime != null) {
        subtitle =
            '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      }

      return DateTimeSelector(
        selectedTitle: 'Scheduled Date & Time',
        unselectedTitle: 'Select Date & Time',
        selectedSubtitle: subtitle,
        unselectedSubtitle: 'Tap to choose when to send the notification',
        icon: Icons.calendar_today,
        tooltip: 'Select a date and time for the notification',
        onTap: onDateTimePicked,
        hasValue: dateTime != null,
      );
    }

    // For periodic notifications that need time selection (Daily/Weekly/Hourly)
    if (formData.notificationType == 'Periodic' &&
        (formData.periodicSubtype == 'Daily' ||
            formData.periodicSubtype == 'Weekly' ||
            formData.periodicSubtype == 'Hourly')) {
      String buttonTitle;
      String unselectedSubtitle;
      String? selectedSubtitle;

      // Different label text based on the notification subtype
      if (formData.periodicSubtype == 'Daily') {
        buttonTitle = 'Daily Time';
        unselectedSubtitle = 'Select time of day';
        if (formData.recurringTime != null) {
          selectedSubtitle =
              'At ${formData.recurringTime!.format(context)} every day';
        }
      } else if (formData.periodicSubtype == 'Weekly') {
        buttonTitle = 'Weekly Time';
        unselectedSubtitle = 'Select time of day';
        if (formData.recurringTime != null) {
          selectedSubtitle =
              'At ${formData.recurringTime!.format(context)} weekly';
        }
      } else {
        buttonTitle = 'Start Time';
        unselectedSubtitle = 'Select start time (optional)';
        if (formData.recurringTime != null) {
          selectedSubtitle =
              'Starting at ${formData.recurringTime!.format(context)}';
        }
      }

      return DateTimeSelector(
        selectedTitle: buttonTitle,
        unselectedTitle: buttonTitle,
        selectedSubtitle: selectedSubtitle,
        unselectedSubtitle: unselectedSubtitle,
        icon: Icons.access_time,
        tooltip: 'Select a time for the recurring notification',
        onTap: onTimePicked,
        hasValue: formData.recurringTime != null,
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNotificationTypeSelector(context),
        _buildPeriodicSubtypeSelector(context),
        const SizedBox(height: 16),
        _buildTimeSelector(context),
        if (controller.value.notificationType == 'Periodic' &&
            controller.value.periodicSubtype == 'Weekly')
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: StyledDropdown<int>(
              label: 'Day of Week',
              prefixIcon: Icons.view_week,
              value: controller.value.dayOfWeek,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Monday')),
                DropdownMenuItem(value: 2, child: Text('Tuesday')),
                DropdownMenuItem(value: 3, child: Text('Wednesday')),
                DropdownMenuItem(value: 4, child: Text('Thursday')),
                DropdownMenuItem(value: 5, child: Text('Friday')),
                DropdownMenuItem(value: 6, child: Text('Saturday')),
                DropdownMenuItem(value: 7, child: Text('Sunday')),
              ],
              onChanged: controller.updateDayOfWeek,
            ),
          ),
      ],
    );
  }
}
