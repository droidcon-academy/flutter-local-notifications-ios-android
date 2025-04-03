import 'package:flutter/material.dart';
import 'package:timora/model/notification_model.dart';
import 'package:timora/service/create-notification/create_notification_controller.dart';

class PrioritySection extends StatelessWidget {
  final CreateNotificationController controller;

  const PrioritySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              NotificationLevel.values.map((level) {
                final isSelected = controller.value.level == level;
                return GestureDetector(
                  onTap: () => controller.updateLevel(level),
                  child: Column(
                    children: [
                      Icon(
                        level == NotificationLevel.urgent
                            ? Icons.priority_high
                            : level == NotificationLevel.normal
                            ? Icons.notifications
                            : Icons.low_priority,
                        color:
                            isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        level.name[0].toUpperCase() + level.name.substring(1),
                        style: TextStyle(
                          color:
                              isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
        if (controller.value.level == NotificationLevel.urgent &&
            !controller.isIOS &&
            !controller.isHighFrequencyNotification)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Full-screen alerts are available for urgent notifications',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
