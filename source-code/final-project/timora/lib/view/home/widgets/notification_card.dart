import 'package:flutter/material.dart';
import 'package:timora/core/util/notification_util.dart';
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: categoryColor.withAlpha(77), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
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
    return Row(
      children: [
        CategoryBadge(category: category),
        const Spacer(),
        Text(
          scheduleTime,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
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
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          body,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade800,
            fontSize: 14,
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
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            iconSize: 20,
            visualDensity: VisualDensity.compact,
            tooltip: 'Edit reminder',
            icon: Icon(Icons.edit_outlined, color: Colors.blue.shade700),
            onPressed: onEdit,
          ),
          IconButton(
            iconSize: 20,
            visualDensity: VisualDensity.compact,
            tooltip: 'Delete reminder',
            icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
            onPressed: onDelete,
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
    final color = NotificationUtils.categoryColor(category);
    final displayText = category.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(127)),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
