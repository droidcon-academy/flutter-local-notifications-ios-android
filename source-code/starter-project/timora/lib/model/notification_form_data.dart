import 'package:flutter/material.dart';
import 'package:timora/core/constants/notification_constants.dart';
import 'package:timora/model/notification_model.dart';

// TODO: This class represents the form data for creating notifications
// It's used by the UI to collect user input for notification creation
// You'll use this data to create NotificationModel instances

class NotificationFormData {
  String title = '';
  String body = '';
  DateTime? scheduledDateTime;
  TimeOfDay? recurringTime;
  int? dayOfWeek; // 1-7 (Monday-Sunday)
  String channelId = NotificationChannelIds.personal;
  NotificationLevel level = NotificationLevel.normal;
  bool isFullScreen = false;
  bool hasActions = false;
  bool imageAttachment = false;
  bool customSound = false;
  String notificationType = 'Instant'; // Default type
  String periodicSubtype = 'Daily'; // Default subtype
}
