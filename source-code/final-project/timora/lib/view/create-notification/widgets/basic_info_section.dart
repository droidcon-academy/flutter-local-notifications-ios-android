import 'package:flutter/material.dart';
import 'package:timora/service/create-notification/create_notification_controller.dart';

class BasicInfoSection extends StatelessWidget {
  final CreateNotificationController controller;

  const BasicInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller.titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            prefixIcon: const Icon(Icons.title),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.bodyController,
          decoration: InputDecoration(
            labelText: 'Message',
            prefixIcon: const Icon(Icons.message),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
          maxLines: 3,
          validator:
              (value) => value!.isEmpty ? 'Please enter a message' : null,
        ),
      ],
    );
  }
}
