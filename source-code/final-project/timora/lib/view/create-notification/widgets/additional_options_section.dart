import 'package:flutter/material.dart';
import 'package:timora/service/create-notification/create_notification_controller.dart';

class AdditionalOptionsSection extends StatelessWidget {
  final CreateNotificationController controller;

  const AdditionalOptionsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.showFullScreenOption)
          _buildSwitchTile(
            context: context,
            title: 'Full-Screen Alert',
            subtitle: 'Show as a high-priority alert',
            icon: Icons.fullscreen,
            value: controller.value.isFullScreen,
            onChanged: controller.updateFullScreenOption,
          ),
        if (controller.showFullScreenOption) const SizedBox(height: 12),
        _buildSwitchTile(
          context: context,
          title: 'Interactive Actions',
          subtitle: 'Snooze, Dismiss and Reply',
          icon: Icons.touch_app,
          value: controller.value.hasActions,
          onChanged: controller.updateHasActions,
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          context: context,
          title: 'Custom Sound',
          subtitle: null,
          icon: Icons.music_note,
          value: controller.value.customSound,
          onChanged: controller.updateCustomSound,
        ),
        const SizedBox(height: 16),
        if (controller.showImageAttachment)
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => controller.pickImage(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        controller.value.imageAttachment
                            ? theme.colorScheme.primary.withValues(alpha: 0.5)
                            : theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                    width: 1.5,
                  ),
                  color:
                      controller.value.imageAttachment
                          ? theme.colorScheme.primary.withValues(alpha: 0.05)
                          : theme.colorScheme.surfaceContainerLowest,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            controller.value.imageAttachment
                                ? theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                )
                                : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        controller.value.imageAttachment
                            ? Icons.check_circle
                            : Icons.add_photo_alternate,
                        color:
                            controller.value.imageAttachment
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attach Image',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color:
                                  controller.value.imageAttachment
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.value.imageAttachment
                                ? 'Image attached!'
                                : 'Tap to select an image',
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  controller.value.imageAttachment
                                      ? theme.colorScheme.primary.withValues(
                                        alpha: 0.8,
                                      )
                                      : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color:
                          controller.value.imageAttachment
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    String? subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.5,
        ),
        color: theme.colorScheme.surfaceContainerLowest,
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
                : null,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                value
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color:
                value
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        value: value,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        activeColor: theme.colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
