import 'package:flutter/material.dart';
import 'package:timora/core/util/notification_util.dart';
import 'package:timora/core/view/widgets/widgets.dart';
import 'package:timora/model/notification_model.dart';

/// Displays notification information in a card format.
///
/// Shows the notification category, scheduled time, title, body, and action buttons
/// for editing or deleting the notification.
class NotificationCard extends StatelessWidget {
  /// The notification model containing all the data to display.
  final NotificationModel model;

  /// Callback triggered when the user wants to edit the notification.
  final VoidCallback onEdit;

  /// Callback triggered when the user wants to delete the notification.
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.model,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = model.channelId;
    final categoryColor = NotificationUtils.categoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onEdit,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.95),
                  ],
                ),
                border: Border.all(
                  color: categoryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardHeader(
                      category: category,
                      scheduleTime: NotificationUtils.formatScheduleTime(model),
                    ),
                    const SizedBox(height: 12),
                    _CardContent(title: model.title, body: model.body),
                    _CardActions(
                      onEdit: onEdit,
                      onDelete: onDelete,
                      notificationTitle: model.title, // For accessibility
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays the header section of the notification card.
///
/// Contains the category badge and scheduled time of the notification.
class _CardHeader extends StatelessWidget {
  /// The category name of the notification.
  final String category;

  /// Formatted string representing when the notification is scheduled.
  final String scheduleTime;

  const _CardHeader({required this.category, required this.scheduleTime});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CategoryBadge(category: category),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.7,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                scheduleTime,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Presents the main content section of the notification card.
///
/// Displays the title and body of the notification with appropriate styling.
class _CardContent extends StatelessWidget {
  /// The title text of the notification.
  final String title;

  /// The body text/message content of the notification.
  final String body;

  const _CardContent({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: -0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
            height: 1.3,
            letterSpacing: 0.1,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Provides action buttons for the notification card.
///
/// Includes edit and delete buttons with appropriate styling and accessibility.
class _CardActions extends StatelessWidget {
  /// Callback invoked when the edit button is pressed.
  final VoidCallback onEdit;

  /// Callback invoked when the delete button is pressed.
  final VoidCallback onDelete;

  /// Title of the notification, used for accessibility labels.
  final String notificationTitle;

  const _CardActions({
    required this.onEdit,
    required this.onDelete,
    required this.notificationTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onEdit,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onDelete,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the notification category as a styled badge.
///
/// Uses category-specific colors and styling to visually differentiate notification types.
class CategoryBadge extends StatelessWidget {
  /// The category name to display.
  final String category;

  const CategoryBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final channel = NotificationChannel.fromId(category);
    final displayText = channel.displayName.toUpperCase();

    return StyledBadge(text: displayText, color: channel.color);
  }
}
