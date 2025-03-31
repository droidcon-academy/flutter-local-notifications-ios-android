import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timora/model/notification_model.dart';
import 'package:intl/intl.dart';

/// Utility class for notification-related operations
class NotificationUtils {
  /// Returns a color based on the notification category
  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'personal':
        return Colors.green;
      case 'health':
        return Colors.red;
      case 'finance':
        return Colors.purple;
      case 'education':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  /// Formats the scheduled time of a notification
  static String formatScheduleTime(NotificationModel model) {
    // Check notification type
    if (model.type == NotificationType.periodic) {
      return _formatPeriodicSchedule(model);
    }

    final dateTime = model.scheduledTime;

    if (dateTime == null) {
      return 'Not scheduled';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final notificationDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    // Format date based on how soon it is
    String dateFormat;
    if (notificationDate == today) {
      dateFormat = 'Today';
    } else if (notificationDate == tomorrow) {
      dateFormat = 'Tomorrow';
    } else {
      dateFormat = DateFormat('MMM d').format(dateTime);
    }

    // Format time
    final timeFormat = DateFormat('h:mm a').format(dateTime);

    return '$dateFormat at $timeFormat';
  }

  /// Formats a periodic notification schedule
  static String _formatPeriodicSchedule(NotificationModel model) {
    if (model.repeatInterval == null) {
      return 'Recurring';
    }

    String repeatText = '';

    switch (model.repeatInterval) {
      case RepeatInterval.everyMinute:
        if (model.timeOfDay != null) {
          final hour = model.timeOfDay!.hour.toString().padLeft(2, '0');
          final minute = model.timeOfDay!.minute.toString().padLeft(2, '0');
          repeatText = 'Every minute (from $hour:$minute)';
        } else {
          repeatText = 'Every minute';
        }
        break;
      case RepeatInterval.hourly:
        if (model.timeOfDay != null) {
          final hour = model.timeOfDay!.hour.toString().padLeft(2, '0');
          final minute = model.timeOfDay!.minute.toString().padLeft(2, '0');
          repeatText = 'Hourly (starting $hour:$minute)';
        } else {
          repeatText = 'Hourly';
        }
        break;
      case RepeatInterval.daily:
        if (model.timeOfDay != null) {
          final hour = model.timeOfDay!.hour.toString().padLeft(2, '0');
          final minute = model.timeOfDay!.minute.toString().padLeft(2, '0');
          repeatText = 'Daily at $hour:$minute';
        } else {
          repeatText = 'Daily';
        }
        break;
      case RepeatInterval.weekly:
        if (model.dayOfWeek != null && model.timeOfDay != null) {
          final weekday = _getWeekdayName(model.dayOfWeek!);
          final hour = model.timeOfDay!.hour.toString().padLeft(2, '0');
          final minute = model.timeOfDay!.minute.toString().padLeft(2, '0');
          repeatText = 'Weekly on $weekday at $hour:$minute';
        } else {
          repeatText = 'Weekly';
        }
        break;
      default:
        repeatText = model.repeatInterval.toString().split('.').last;
    }

    return repeatText;
  }

  /// Gets the weekday name from the weekday number (1-7, Monday-Sunday)
  static String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}
