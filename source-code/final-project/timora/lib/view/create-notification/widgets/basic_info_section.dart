import 'package:flutter/material.dart';
import 'package:timora/core/view/widgets/widgets.dart';
import 'package:timora/service/create-notification/create_notification_controller.dart';

class BasicInfoSection extends StatelessWidget {
  final CreateNotificationController controller;

  const BasicInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledTextField(
          controller: controller.titleController,
          label: 'Title',
          prefixIcon: Icons.title,
          validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
        ),
        const SizedBox(height: 20),
        StyledTextField(
          controller: controller.bodyController,
          label: 'Message',
          prefixIcon: Icons.message,
          multiline: true,
          validator:
              (value) => value!.isEmpty ? 'Please enter a message' : null,
        ),
      ],
    );
  }
}
