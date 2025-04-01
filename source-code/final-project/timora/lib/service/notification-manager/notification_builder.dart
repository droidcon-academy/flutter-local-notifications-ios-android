import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timora/service/notification-manager/notification_manager.dart';
import 'package:timora/model/notification_model.dart';

/// Creates and configures notifications using a fluent API.
///
/// This builder simplifies the process of creating notifications by providing
/// a chainable API that guides developers through the configuration process.
class NotificationBuilder {
  final NotificationManager _manager;
  NotificationModel _model;

  NotificationBuilder._(this._manager, this._model);

  /// Creates a basic notification builder with required information.
  ///
  /// Initializes a notification with essential properties and returns a builder
  /// for further configuration.
  ///
  /// [manager] The notification manager instance
  /// [id] Unique identifier for this notification
  /// [title] Title text to display
  /// [body] Main content text to display
  /// [channelId] Channel identifier for grouping notifications
  /// [level] Importance level of the notification
  ///
  /// Throws an [ArgumentError] if any required parameter is empty.
  factory NotificationBuilder.create(
    NotificationManager manager, {
    required int id,
    required String title,
    required String body,
    required String channelId,
    NotificationLevel level = NotificationLevel.normal,
  }) {
    if (title.isEmpty) {
      throw ArgumentError('Notification title cannot be empty');
    }

    if (body.isEmpty) {
      throw ArgumentError('Notification body cannot be empty');
    }

    if (channelId.isEmpty) {
      throw ArgumentError('Channel ID cannot be empty');
    }

    return NotificationBuilder._(
      manager,
      NotificationModel(
        id: id,
        title: title,
        body: body,
        channelId: channelId,
        level: level,
        type: NotificationType.instant,
      ),
    );
  }

  /// Gets the notification ID.
  int get id => _model.id;

  /// Gets the underlying notification model.
  NotificationModel get model => _model;

  /// Configures the notification to appear as a full-screen high-priority alert.
  ///
  /// Full-screen notifications can break through Do Not Disturb mode on some devices.
  ///
  /// [isFullScreen] Whether the notification should be displayed as full-screen
  NotificationBuilder setFullScreen(bool isFullScreen) {
    // Avoid unnecessary updates
    if (_model.isFullScreen == isFullScreen) {
      return this;
    }
    _model = _model.copyWith(isFullScreen: isFullScreen);
    return this;
  }

  /// Adds an image to be displayed in the expanded notification view.
  ///
  /// [imageBytes] The raw bytes of the image to display
  ///
  /// Throws an [ArgumentError] if the image bytes array is empty.
  NotificationBuilder setImage(Uint8List imageBytes) {
    if (imageBytes.isEmpty) {
      throw ArgumentError('Image bytes cannot be empty');
    }
    _model = _model.copyWith(imageBytes: imageBytes);
    return this;
  }

  /// Adds interactive action buttons to the notification.
  ///
  NotificationBuilder setActions() {
    _model = _model.copyWith(hasActions: true);
    return this;
  }

  /// Schedules the notification to be delivered at a specific future time.
  ///
  /// Changes the notification type to scheduled.
  ///
  /// [scheduledTime] Time when the notification should be delivered
  ///
  /// Throws an [ArgumentError] if the scheduled time is in the past.
  NotificationBuilder scheduleFor(DateTime scheduledTime) {
    final now = DateTime.now();
    if (scheduledTime.isBefore(now)) {
      throw ArgumentError('Scheduled time cannot be in the past');
    }
    _model = _model.copyWith(
      type: NotificationType.scheduled,
      scheduledTime: scheduledTime,
    );
    return this;
  }

  /// Configures the notification to repeat at a specific interval.
  ///
  /// Changes the notification type to periodic.
  ///
  /// [repeatInterval] How frequently the notification should repeat
  NotificationBuilder setRepeatInterval(RepeatInterval repeatInterval) {
    _model = _model.copyWith(
      type: NotificationType.periodic,
      repeatInterval: repeatInterval,
    );
    return this;
  }

  /// Sets a specific time of day for recurring notifications.
  ///
  /// Used primarily with daily and weekly notifications to ensure they appear
  /// at a consistent time.
  ///
  /// [timeOfDay] The time when the notification should be shown
  NotificationBuilder atTimeOfDay(TimeOfDay timeOfDay) {
    _model = _model.copyWith(timeOfDay: timeOfDay);
    return this;
  }

  /// Sets the day of week for weekly recurring notifications.
  ///
  /// [dayOfWeek] Day of week (1-7, where 1 is Monday and 7 is Sunday)
  ///
  /// Throws an [ArgumentError] if dayOfWeek is out of valid range.
  NotificationBuilder onDayOfWeek(int dayOfWeek) {
    if (dayOfWeek < 1 || dayOfWeek > 7) {
      throw ArgumentError('Day of week must be between 1-7 (Monday to Sunday)');
    }
    _model = _model.copyWith(dayOfWeek: dayOfWeek);
    return this;
  }

  /// Configures the notification to display a progress indicator.
  ///
  /// Shows a progress bar in the notification, useful for download or
  /// processing tasks.
  ///
  /// [current] Current progress value
  /// [max] Maximum progress value
  ///
  /// Throws an [ArgumentError] if values are invalid.
  NotificationBuilder setProgress(int current, int max) {
    if (current < 0) {
      throw ArgumentError('Current progress cannot be negative');
    }
    if (max <= 0) {
      throw ArgumentError('Maximum progress must be positive');
    }
    if (current > max) {
      throw ArgumentError('Current progress cannot exceed maximum');
    }
    _model = _model.copyWith(currentProgress: current, maxProgress: max);
    return this;
  }

  /// Shows the notification immediately or at the configured time.
  ///
  /// The behavior depends on the notification type (instant, scheduled, periodic).
  ///
  /// Throws an [ArgumentError] if required properties for the notification type are missing.
  Future<void> show() async {
    switch (_model.type) {
      case NotificationType.instant:
        return await _manager.showInstantNotification(model: _model);

      case NotificationType.scheduled:
        if (_model.scheduledTime == null) {
          throw ArgumentError(
            'scheduledTime must be set for scheduled notifications',
          );
        }
        return await _manager.scheduleNotification(model: _model);

      case NotificationType.periodic:
        if (_model.repeatInterval == null) {
          throw ArgumentError(
            'repeatInterval must be set for periodic notifications',
          );
        }
        return await _manager.showPeriodicNotification(model: _model);
    }
  }

  /// Cancels this notification if it exists.
  ///
  /// Removes both active and pending notifications with this ID.
  Future<void> cancel() async {
    await _manager.cancelNotification(_model.id);
  }
}
