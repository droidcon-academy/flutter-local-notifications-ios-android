import 'package:flutter/material.dart';
import 'package:timora/core/constants/notification_constants.dart';
import 'package:timora/model/notification_model.dart';

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
