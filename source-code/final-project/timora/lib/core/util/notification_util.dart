import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timora/model/notification_model.dart';
import 'package:intl/intl.dart';

/// Utility class for notification-related operations
class NotificationUtils {
  /// Returns a color based on the notification channel ID
  static Color categoryColor(String channelId) {
    return NotificationChannel.colorFromId(channelId);
  }

  /// Returns the display name for a notification channel ID
  static String channelDisplayName(String channelId) {
    return NotificationChannel.displayNameFromId(channelId);
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

  static String sampleImageBase64 =
      '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';
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
