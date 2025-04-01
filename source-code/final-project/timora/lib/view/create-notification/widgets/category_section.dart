import 'package:flutter/material.dart';
import 'package:timora/core/constants/notification_constants.dart';
import 'package:timora/service/create-notification/create_notification_controller.dart';

class CategorySection extends StatelessWidget {
  final CreateNotificationController controller;

  const CategorySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final categories = {
      NotificationChannelIds.work: 'Work',
      NotificationChannelIds.personal: 'Personal',
      NotificationChannelIds.health: 'Health',
    };

    final theme = Theme.of(context);

    return Wrap(
      spacing: 8.0,
      children:
          categories.entries.map((entry) {
            final isSelected = controller.value.channelId == entry.key;
            return ChoiceChip(
              checkmarkColor: theme.colorScheme.onPrimary,
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  controller.updateChannelId(entry.key);
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
}
