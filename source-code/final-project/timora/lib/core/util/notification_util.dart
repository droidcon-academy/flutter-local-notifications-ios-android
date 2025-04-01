import 'dart:typed_data';

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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

Uint8List sampleImageBytes = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x10,
  0x00,
  0x00,
  0x00,
  0x10,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0xF3,
  0xFF,
  0x61,
  0x00,
  0x00,
  0x00,
  0x01,
  0x73,
  0x52,
  0x47,
  0x42,
  0x00,
  0xAE,
  0xCE,
  0x1C,
  0xE9,
  0x00,
  0x00,
  0x00,
  0x04,
  0x67,
  0x41,
  0x4D,
  0x41,
  0x00,
  0x00,
  0xB1,
  0x8F,
  0x0B,
  0xFC,
  0x61,
  0x05,
  0x00,
  0x00,
  0x00,
  0x20,
  0x63,
  0x48,
  0x52,
  0x4D,
  0x00,
  0x00,
  0x7A,
  0x26,
  0x00,
  0x00,
  0x80,
  0x84,
  0x00,
  0x00,
  0xFA,
  0x00,
  0x00,
  0x00,
  0x80,
  0xE8,
  0x00,
  0x00,
  0x75,
  0x30,
  0x00,
  0x00,
  0xEA,
  0x60,
  0x00,
  0x00,
  0x3A,
  0x98,
  0x00,
  0x00,
  0x17,
  0x70,
  0x9C,
  0xBA,
  0x51,
  0x3C,
  0x00,
  0x00,
  0x00,
  0x18,
  0x74,
  0x45,
  0x58,
  0x74,
  0x53,
  0x6F,
  0x66,
  0x74,
  0x77,
  0x61,
  0x72,
  0x65,
  0x00,
  0x50,
  0x61,
  0x69,
  0x6E,
  0x74,
  0x2E,
  0x4E,
  0x45,
  0x54,
  0x20,
  0x76,
  0x33,
  0x35,
  0x2E,
  0x31,
  0x31,
  0x9E,
  0xC2,
  0xF5,
  0x41,
  0x00,
  0x00,
  0x00,
  0x25,
  0x49,
  0x44,
  0x41,
  0x54,
  0x28,
  0x53,
  0x63,
  0xFC,
  0xCF,
  0x80,
  0x23,
  0xC0,
  0xC8,
  0xF8,
  0xFF,
  0xFF,
  0xFF,
  0xF1,
  0x7F,
  0x06,
  0x0C,
  0x26,
  0x13,
  0xFF,
  0xFF,
  0xFF,
  0xFF,
  0x07,
  0x18,
  0xE8,
  0x00,
  0x62,
  0x64,
  0xC4,
  0xFF,
  0xFF,
  0xFF,
  0xFF,
  0xC3,
  0x07,
  0x00,
  0xD8,
  0xB9,
  0x0A,
  0xDC,
  0xBE,
  0xFA,
  0x06,
  0x2E,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);
