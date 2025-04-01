import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          mainTypes.map((type) {
            final isSelected = controller.value.notificationType == type;
            return ChoiceChip(
              checkmarkColor: theme.colorScheme.onPrimary,
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  controller.updateNotificationType(type);
                }
              },
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
              ),
            );
          }).toList(),
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
        const SizedBox(height: 16),
        const Text(
          'Repeat Frequency:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children:
              periodicSubtypes.map((subtype) {
                final isSelected = controller.value.periodicSubtype == subtype;
                return ChoiceChip(
                  checkmarkColor: theme.colorScheme.onSecondary,
                  label: Text(subtype),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      controller.updatePeriodicSubtype(subtype);
                    }
                  },
                  selectedColor: theme.colorScheme.secondary,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    color:
                        isSelected
                            ? theme.colorScheme.onSecondary
                            : theme.colorScheme.onSurface,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    final formData = controller.value;

    // For scheduled notifications
    if (formData.notificationType == 'Scheduled') {
      return Tooltip(
        message: 'Select a date and time for the notification',
        child: ElevatedButton.icon(
          onPressed: onDateTimePicked,
          icon: const Icon(Icons.calendar_today),
          label: Text(
            formData.scheduledDateTime == null
                ? 'Select Date & Time'
                : 'Scheduled: ${formData.scheduledDateTime!.day}/${formData.scheduledDateTime!.month}/${formData.scheduledDateTime!.year} at ${formData.scheduledDateTime!.hour}:${formData.scheduledDateTime!.minute.toString().padLeft(2, '0')}',
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    // For periodic notifications that need time selection (Daily/Weekly/Hourly)
    if (formData.notificationType == 'Periodic' &&
        (formData.periodicSubtype == 'Daily' ||
            formData.periodicSubtype == 'Weekly' ||
            formData.periodicSubtype == 'Hourly')) {
      String buttonLabel;

      // Different label text based on the notification subtype
      if (formData.periodicSubtype == 'Daily') {
        buttonLabel =
            formData.recurringTime == null
                ? 'Select Time of Day'
                : 'Daily at: ${formData.recurringTime!.format(context)}';
      } else if (formData.periodicSubtype == 'Weekly') {
        buttonLabel =
            formData.recurringTime == null
                ? 'Select Time of Day'
                : 'Weekly at: ${formData.recurringTime!.format(context)}';
      } else {
        buttonLabel =
            formData.recurringTime == null
                ? 'Select Start Time (Optional)'
                : 'Starting at: ${formData.recurringTime!.format(context)}';
      }

      return Tooltip(
        message: 'Select a time for the recurring notification',
        child: ElevatedButton.icon(
          onPressed: onTimePicked,
          icon: const Icon(Icons.access_time),
          label: Text(buttonLabel),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
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
            padding: const EdgeInsets.only(top: 16.0),
            child: DropdownButtonFormField<int>(
              value: controller.value.dayOfWeek,
              decoration: InputDecoration(
                labelText: 'Day of Week',
                prefixIcon: const Icon(Icons.view_week),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
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
