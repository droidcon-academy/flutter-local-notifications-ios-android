import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String channelId;
  final NotificationType type;
  final DateTime? scheduledTime;
  final TimeOfDay? timeOfDay;
  final int? dayOfWeek;
  final RepeatInterval? repeatInterval;
  final Duration? periodDuration;
  final int? occurrenceCount;
  final bool isFullScreen;
  final bool hasActions;
  final bool imageAttachment;
  final int? maxProgress;
  final int? currentProgress;
  final String? payload;
  final String? groupKey;
  final NotificationLevel level;
  final bool customSound;
  final String? deepLink;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.channelId,
    required this.type,
    this.scheduledTime,
    this.timeOfDay,
    this.dayOfWeek,
    this.repeatInterval,
    this.periodDuration,
    this.occurrenceCount,
    this.isFullScreen = false,
    this.hasActions = false,
    this.imageAttachment = false,
    this.maxProgress,
    this.currentProgress,
    this.payload,
    this.groupKey,
    this.level = NotificationLevel.normal,
    this.customSound = false,
    this.deepLink,
  });

  /// Create a copy of this notification with updated values
  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    String? channelId,
    NotificationType? type,
    DateTime? scheduledTime,
    TimeOfDay? timeOfDay,
    int? dayOfWeek,
    RepeatInterval? repeatInterval,
    Duration? periodDuration,
    int? occurrenceCount,
    bool? isFullScreen,
    bool? hasActions,
    bool? imageAttachment,
    int? maxProgress,
    int? currentProgress,
    String? payload,
    String? groupKey,
    NotificationLevel? level,
    bool? customSound,
    String? deepLink,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      channelId: channelId ?? this.channelId,
      type: type ?? this.type,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      repeatInterval: repeatInterval ?? this.repeatInterval,
      periodDuration: periodDuration ?? this.periodDuration,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      hasActions: hasActions ?? this.hasActions,
      imageAttachment: imageAttachment ?? this.imageAttachment,
      maxProgress: maxProgress ?? this.maxProgress,
      currentProgress: currentProgress ?? this.currentProgress,
      payload: payload ?? this.payload,
      groupKey: groupKey ?? this.groupKey,
      level: level ?? this.level,
      customSound: customSound ?? this.customSound,
      deepLink: deepLink ?? this.deepLink,
    );
  }

  /// Convert to JSON for payload
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'channelId': channelId,
    'type': type.name,
    'scheduledTime': scheduledTime?.toIso8601String(),
    'timeOfDay':
        timeOfDay != null
            ? {'hour': timeOfDay!.hour, 'minute': timeOfDay!.minute}
            : null,
    'dayOfWeek': dayOfWeek,
    'repeatInterval': repeatInterval?.name,
    'periodDuration': periodDuration?.inMilliseconds,
    'occurrenceCount': occurrenceCount,
    'isFullScreen': isFullScreen,
    'hasActions': hasActions,
    'imageAttachment':
        imageAttachment, // Changed from 'imageBytes' to 'imageAttachment' to match property name
    'maxProgress': maxProgress,
    'currentProgress': currentProgress,
    'payload': payload,
    'groupKey': groupKey,
    'level': level.name,
    'customSound': customSound,
    'deepLink': deepLink,
  };

  /// Create from JSON (payload)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      channelId: json['channelId'] as String,
      type: NotificationType.values.firstWhere((e) => e.name == json['type']),
      scheduledTime:
          json['scheduledTime'] != null
              ? DateTime.parse(json['scheduledTime'] as String)
              : null,
      timeOfDay:
          json['timeOfDay'] != null
              ? TimeOfDay(
                hour: json['timeOfDay']['hour'] as int,
                minute: json['timeOfDay']['minute'] as int,
              )
              : null,
      dayOfWeek: json['dayOfWeek'] as int?,
      repeatInterval:
          json['repeatInterval'] != null
              ? RepeatInterval.values.firstWhere(
                (e) => e.name == json['repeatInterval'],
              )
              : null,
      periodDuration:
          json['periodDuration'] != null
              ? Duration(milliseconds: json['periodDuration'] as int)
              : null,
      occurrenceCount: json['occurrenceCount'] as int?,
      isFullScreen: json['isFullScreen'] as bool? ?? false,
      hasActions: json['hasActions'] as bool? ?? false,
      imageAttachment: json['imageAttachment'],
      maxProgress: json['maxProgress'] as int?,
      currentProgress: json['currentProgress'] as int?,
      payload: json['payload'] as String?,
      groupKey: json['groupKey'] as String?,
      level:
          json['level'] != null
              ? NotificationLevel.values.firstWhere(
                (e) => e.name == json['level'],
              )
              : NotificationLevel.normal,
      customSound: json['customSound'] as bool? ?? false,
      deepLink: json['deepLink'] as String?,
    );
  }

  /// Helper to serialize to string
  String toPayload() => jsonEncode(toJson());

  /// Helper to deserialize from payload string
  static NotificationModel fromPayload(String payload) =>
      NotificationModel.fromJson(jsonDecode(payload));
}

/// Enum defining the main notification types
enum NotificationType { instant, scheduled, periodic }

/// Defines importance and behavior levels for notifications.
///
/// Each level configures appropriate platform-specific settings for
/// notification visibility, sound, vibration, and priority.
enum NotificationLevel {
  /// Standard notification level with default importance.
  ///
  /// Plays sound, vibrates, and is publicly visible.
  normal(
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
    playSound: true,
    vibrate: true,
    visibility: NotificationVisibility.public,
  ),

  /// Low-prominence notification level.
  ///
  /// Doesn't play sound or vibrate, and has restricted visibility.
  low(
    importance: Importance.low,
    priority: Priority.low,
    playSound: false,
    vibrate: false,
    visibility: NotificationVisibility.private,
  ),

  /// High-priority notification level for important alerts.
  ///
  /// Uses maximum importance, plays sound, vibrates, and is publicly visible.
  urgent(
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    vibrate: true,
    visibility: NotificationVisibility.public,
  );

  final Importance importance;
  final Priority priority;
  final bool playSound;
  final bool vibrate;
  final NotificationVisibility visibility;

  const NotificationLevel({
    required this.importance,
    required this.priority,
    required this.playSound,
    required this.vibrate,
    required this.visibility,
  });
}
