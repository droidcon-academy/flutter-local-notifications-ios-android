import 'package:flutter/material.dart';
import 'package:timora/service/create-notification/create_notification_controller.dart';

class AdditionalOptionsSection extends StatelessWidget {
  final CreateNotificationController controller;

  const AdditionalOptionsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.showFullScreenOption)
          SwitchListTile(
            title: const Text('Full-Screen Alert'),
            subtitle: const Text('Show as a high-priority alert'),
            secondary: const Icon(Icons.fullscreen),
            value: controller.value.isFullScreen,
            onChanged: controller.updateFullScreenOption,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            tileColor: Colors.white,
          ),
        if (controller.showFullScreenOption) const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Interactive Actions'),
          subtitle: const Text('Snooze, Dismiss and Reply'),
          secondary: const Icon(Icons.touch_app),
          value: controller.value.hasActions,
          onChanged: controller.updateHasActions,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          tileColor: Colors.white,
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Custom Sound'),
          secondary: const Icon(Icons.music_note),
          value: controller.value.customSound,
          onChanged: controller.updateCustomSound,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          tileColor: Colors.white,
        ),
        const SizedBox(height: 8),
        if (controller.showImageAttachment)
          InkWell(
            onTap: () => controller.pickImage(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    controller.value.imageAttachment
                        ? Icons.check_circle
                        : Icons.add_photo_alternate,
                    color:
                        controller.value.imageAttachment
                            ? Colors.green
                            : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Attach Image',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        controller.value.imageAttachment
                            ? 'Image attached!'
                            : 'Tap to select an image',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
