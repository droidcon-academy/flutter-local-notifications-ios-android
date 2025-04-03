import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
// You'll need this import for working with notifications
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  void updateCustomSound(bool useCustomSound) {
    value = value..customSound = useCustomSound;
    notifyListeners();
  }

  // Image picker - now returns a Future<bool> to indicate success
  Future<bool> pickImage() async {
    // This is a mock implementation using a sample image
    value = value..imageAttachment = true;
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
    // TODO: Implement notification preparation
    // 1. Get the notification content (title, body) from the text controllers
    // 2. Generate a unique ID for the notification
    // 3. Create a basic notification builder with the NotificationManager
    // 4. Configure common properties (full screen, image, actions, custom sound)
    // 5. Configure type-specific properties based on the notification type:
    //    - For instant notifications: no additional configuration needed
    //    - For scheduled notifications: set the scheduled time
    //    - For periodic notifications: set the repeat interval and time
    // 6. Return the configured notification builder

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

    // Return the builder without any additional configuration
    // The learner will implement the configuration in the codelab
    return builder;
  }

  // Progress notification setup
  NotificationBuilder createProgressNotification({
    required int progress,
    required int maxProgress,
  }) {
    // TODO: Implement progress notification creation
    // 1. Generate a unique ID for the notification
    // 2. Determine if the progress is complete
    // 3. Set appropriate title and body text based on progress
    // 4. Create a notification with the progress information
    // 5. Configure the notification with progress values

    final id = DateTime.now().millisecondsSinceEpoch % 10000;

    // Create a basic notification with placeholder text
    return notificationManager.createNotification(
      id: id,
      title: 'Progress Notification',
      body: 'Progress placeholder',
      channelId: value.channelId,
      level: NotificationLevel.normal,
    );
    // The learner will implement the progress configuration in the codelab
  }

  // Group notification setup
  Future<List<NotificationBuilder>> createGroupNotificationBuilders() async {
    // TODO: Implement group notification builders creation
    // 1. Define a list of message contents for the group notifications
    // 2. Create an empty list to hold the notification builders
    // 3. For each message, create a notification builder with a unique ID
    // 4. Add each builder to the list
    // 5. Return the list of notification builders

    // Create an empty list of notification builders
    final List<NotificationBuilder> notificationBuilders = [];

    // Create a single placeholder notification
    final id = DateTime.now().millisecondsSinceEpoch % 10000;
    final builder = notificationManager.createNotification(
      id: id,
      title: 'Group Notification',
      body: 'Group notification placeholder',
      channelId: value.channelId,
      level: NotificationLevel.normal,
    );

    notificationBuilders.add(builder);

    // The learner will implement the full group notification in the codelab
    return notificationBuilders;
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
