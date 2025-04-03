import 'package:flutter/material.dart';
import 'package:timora/core/constants/notification_constants.dart';
import 'package:timora/core/view/widgets/widgets.dart';
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

    return ChipSelector(
      options: categories.keys.toList(),
      selectedOption: controller.value.channelId,
      onSelected: controller.updateChannelId,
      // Custom display function to show the category name instead of the ID
      customLabelBuilder: (option) => categories[option] ?? option,
    );
  }
}
