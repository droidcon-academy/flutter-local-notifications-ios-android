import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timora/core/util/notification_util.dart';
import 'package:timora/model/notification_model.dart';
import 'package:timora/service/notification-manager/notification_builder.dart';
import 'package:timora/service/notification-manager/notification_manager.dart';
import 'package:timora/model/notification_form_data.dart';
import 'package:timora/model/validation_result.dart';

class CreateNotificationController extends ValueNotifier<NotificationFormData> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final NotificationManager notificationManager = NotificationManager();

  // Use value notifier pattern instead of ChangeNotifier
  CreateNotificationController() : super(NotificationFormData());

  // Getters
  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isHighFrequencyNotification =>
      value.notificationType == 'Periodic' &&
      (value.periodicSubtype == 'Hourly' ||
          value.periodicSubtype == 'Every Minute');

  bool get showFullScreenOption =>
      !isIOS && // Not iOS
      !isHighFrequencyNotification && // Not high frequency
      value.level == NotificationLevel.urgent; // Is urgent priority

  bool get showImageAttachment => !isHighFrequencyNotification;

  // Update methods
  void updateNotificationType(String type) {
    value = value..notificationType = type;
    value.scheduledDateTime = null;
    value.recurringTime = null;
    value.dayOfWeek = null;

    if (type != 'Periodic') {
      value.periodicSubtype = 'Daily';
    }
    notifyListeners();
  }

  void updatePeriodicSubtype(String subtype) {
    value = value..periodicSubtype = subtype;
    value.recurringTime = null;
    value.dayOfWeek = null;
    notifyListeners();
  }

  void updateChannelId(String channelId) {
    value = value..channelId = channelId;
    notifyListeners();
  }

  void updateLevel(NotificationLevel level) {
    value = value..level = level;
    if (level != NotificationLevel.urgent) {
      value.isFullScreen = false;
    }
    notifyListeners();
  }

  void updateFullScreenOption(bool isFullScreen) {
    value = value..isFullScreen = isFullScreen;
    notifyListeners();
  }

  void updateHasActions(bool hasActions) {
    value = value..hasActions = hasActions;
    notifyListeners();
  }

  void updateDayOfWeek(int? day) {
    value = value..dayOfWeek = day;
    notifyListeners();
  }

  // Image picker - now returns a Future<bool> to indicate success
  Future<bool> pickImage() async {
    // This is a mock implementation using a sample image
    value = value..imageBytes = sampleImageBytes;
    notifyListeners();
    return true;
  }

  // Methods that need dates/times should be called with the results instead
  void setScheduledDateTime(DateTime dateTime) {
    value = value..scheduledDateTime = dateTime;
    notifyListeners();
  }

  void setRecurringTime(TimeOfDay time) {
    value = value..recurringTime = time;
    notifyListeners();
  }

  // Validation - returns a ValidationResult instead of showing UI
  ValidationResult validateNotificationFields() {
    // For scheduled notifications
    if (value.notificationType == 'Scheduled') {
      if (value.scheduledDateTime == null) {
        return ValidationResult(false, 'Please select a date and time');
      }
      return ValidationResult(true, null);
    }

    // For periodic notifications
    if (value.notificationType == 'Periodic') {
      // For daily and weekly notifications, time is required
      if ((value.periodicSubtype == 'Daily' ||
              value.periodicSubtype == 'Weekly') &&
          value.recurringTime == null) {
        return ValidationResult(
          false,
          'Please select a time for the recurring notification',
        );
      }

      // For weekly notifications, day of week is required
      if (value.periodicSubtype == 'Weekly' && value.dayOfWeek == null) {
        return ValidationResult(false, 'Please select a day of week');
      }

      return ValidationResult(true, null);
    }

    return ValidationResult(true, null);
  }

  // Prepare notification - returns a builder that can be shown
  NotificationBuilder prepareNotification() {
    final title = titleController.text;
    final body = bodyController.text;
    final id = DateTime.now().millisecondsSinceEpoch % 10000;

    // Create a basic notification builder
    var builder = notificationManager.createNotification(
      id: id,
      title: title,
      body: body,
      channelId: value.channelId,
      level: value.level,
    );

    // Add common properties
    builder = builder.setFullScreen(value.isFullScreen);

    if (value.imageBytes != null) {
      builder = builder.setImage(value.imageBytes!);
    }

    if (value.hasActions) {
      builder = builder.setActions(['Snooze', 'Dismiss']);
    }

    // Configure based on type
    switch (value.notificationType) {
      case 'Instant':
        // No additional configuration needed for instant notifications
        break;

      case 'Scheduled':
        builder = builder.scheduleFor(value.scheduledDateTime!);
        break;

      case 'Periodic':
        // Map UI selection to RepeatInterval
        late RepeatInterval repeatInterval;

        switch (value.periodicSubtype) {
          case 'Daily':
            repeatInterval = RepeatInterval.daily;
            break;
          case 'Weekly':
            repeatInterval = RepeatInterval.weekly;
            break;
          case 'Hourly':
            repeatInterval = RepeatInterval.hourly;
            break;
          case 'Every Minute':
            repeatInterval = RepeatInterval.everyMinute;
            break;
        }

        builder = builder.setRepeatInterval(repeatInterval);

        // For daily/weekly notifications, set the time of day
        if (value.periodicSubtype == 'Daily' ||
            value.periodicSubtype == 'Weekly') {
          builder = builder.atTimeOfDay(value.recurringTime!);

          // For weekly notifications, set the day of week
          if (value.periodicSubtype == 'Weekly') {
            builder = builder.onDayOfWeek(value.dayOfWeek!);
          }
        }

        // For hourly or every minute notifications with a specific start time
        if ((value.periodicSubtype == 'Hourly' ||
                value.periodicSubtype == 'Every Minute') &&
            value.recurringTime != null) {
          // Just set the time of day without scheduling a separate notification
          builder = builder.atTimeOfDay(value.recurringTime!);
        }
        break;
    }

    return builder;
  }

  // Progress notification setup
  NotificationBuilder createProgressNotification({
    required int progress,
    required int maxProgress,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch % 10000;
    final bool isComplete = progress >= maxProgress;

    final title = isComplete ? 'Download Complete' : 'Download Progress';
    final body =
        isComplete
            ? 'File ready to open'
            : 'Downloading: ${(progress / maxProgress * 100).round()}%';

    return notificationManager
        .createNotification(
          id: id,
          title: title,
          body: body,
          channelId: value.channelId,
          level: NotificationLevel.normal,
        )
        .setProgress(progress, maxProgress);
  }

  // Group notification setup
  Future<List<NotificationBuilder>> createGroupNotificationBuilders() async {
    final List<String> messageContents = [
      'First message in the group',
      'Second notification with more details',
      'Third notification in the sequence',
    ];

    // Create individual notification builders
    final List<NotificationBuilder> notificationBuilders = [];

    for (int i = 0; i < messageContents.length; i++) {
      final id = DateTime.now().millisecondsSinceEpoch % 10000 + i;
      final builder = notificationManager.createNotification(
        id: id,
        title: 'Group Message ${i + 1}',
        body: messageContents[i],
        channelId: value.channelId,
        level: NotificationLevel.normal,
      );

      notificationBuilders.add(builder);
    }

    return notificationBuilders;
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
