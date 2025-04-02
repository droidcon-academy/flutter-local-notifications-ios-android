import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timora/core/constants/notification_constants.dart';
import 'package:timora/core/util/notification_util.dart';
import 'package:timora/model/notification_model.dart';
import 'package:timora/service/notification-manager/notification_builder.dart';

/// Callback handler for notification actions when app is in background.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(
    'notification(${notificationResponse.id}) action tapped: '
    '${notificationResponse.actionId} with'
    ' payload: ${notificationResponse.payload}',
  );
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

/// Manages notification operations including creation, scheduling, and cancellation.
///
/// Provides a facade for the Flutter Local Notifications plugin with a
/// simplified API for common notification tasks.
class NotificationManager {
  // Singleton pattern implementation
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  //----------------------------------------------------------------------------
  // INITIALIZATION METHODS
  //----------------------------------------------------------------------------

  /// Initializes the notification system.
  ///
  /// Must be called before any notifications are shown. Configures time zones,
  /// notification settings, and platform-specific channels.
  Future<void> init() async {
    if (_isInitialized) return;

    await _initializeTimeZones();
    await _initializeNotificationSettings();
    await _setupNotificationChannels();

    _isInitialized = true;
  }

  /// Initializes timezone data for scheduling notifications.
  ///
  /// Sets up the local timezone to ensure scheduled notifications appear at
  /// the correct time.
  Future<void> _initializeTimeZones() async {
    tz_data.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  /// Initializes notification settings and categories.
  ///
  /// Configures platform-specific settings and action categories, especially
  /// for interactive notifications.
  Future<void> _initializeNotificationSettings() async {
    final androidSettings = AndroidInitializationSettings(
      NotificationResources.defaultIcon,
    );

    // Configure iOS action categories
    final snoozeAction = DarwinNotificationAction.plain(
      NotificationActionIds.snooze,
      NotificationActionTexts.snooze,
      options: {DarwinNotificationActionOption.foreground},
    );
    final dismissAction = DarwinNotificationAction.plain(
      NotificationActionIds.dismiss,
      NotificationActionTexts.dismiss,
      options: {DarwinNotificationActionOption.foreground},
    );
    final replyAction = DarwinNotificationAction.text(
      NotificationActionIds.reply,
      NotificationActionTexts.reply,
      buttonTitle: NotificationActionTexts.reply,
    );

    final interactiveCategory = DarwinNotificationCategory(
      NotificationCategories.interactive,
      actions: [snoozeAction, dismissAction, replyAction],
    );

    final iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      notificationCategories: [interactiveCategory],
    );

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
    );
  }

  /// Sets up notification channels for Android.
  ///
  /// Creates predefined channels with appropriate importance levels for
  /// different notification categories (work, personal, health).
  Future<void> _setupNotificationChannels() async {
    if (!Platform.isAndroid) return;

    final plugin =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (plugin == null) return;

    // Create standard and custom sound channels for each category
    await _createChannelPair(
      plugin,
      standardId: NotificationChannelIds.work,
      standardName: NotificationChannelDetails.workName,
      standardDesc: NotificationChannelDetails.workDescription,
      soundId: NotificationChannelIds.workSound,
      soundName: NotificationChannelDetails.workSoundName,
      soundDesc: NotificationChannelDetails.workSoundDescription,
      importance: Importance.high,
    );

    await _createChannelPair(
      plugin,
      standardId: NotificationChannelIds.personal,
      standardName: NotificationChannelDetails.personalName,
      standardDesc: NotificationChannelDetails.personalDescription,
      soundId: NotificationChannelIds.personalSound,
      soundName: NotificationChannelDetails.personalSoundName,
      soundDesc: NotificationChannelDetails.personalSoundDescription,
      importance: Importance.defaultImportance,
    );

    await _createChannelPair(
      plugin,
      standardId: NotificationChannelIds.health,
      standardName: NotificationChannelDetails.healthName,
      standardDesc: NotificationChannelDetails.healthDescription,
      soundId: NotificationChannelIds.healthSound,
      soundName: NotificationChannelDetails.healthSoundName,
      soundDesc: NotificationChannelDetails.healthSoundDescription,
      importance: Importance.high,
    );
  }

  /// Helper method to create a pair of notification channels (standard and custom sound)
  Future<void> _createChannelPair(
    AndroidFlutterLocalNotificationsPlugin plugin, {
    required String standardId,
    required String standardName,
    required String standardDesc,
    required String soundId,
    required String soundName,
    required String soundDesc,
    required Importance importance,
  }) async {
    // Standard channel
    await plugin.createNotificationChannel(
      AndroidNotificationChannel(
        standardId,
        standardName,
        description: standardDesc,
        importance: importance,
      ),
    );

    // Channel with custom sound
    await plugin.createNotificationChannel(
      AndroidNotificationChannel(
        soundId,
        soundName,
        description: soundDesc,
        importance: importance,
        sound: const RawResourceAndroidNotificationSound(
          NotificationResources.customSoundAndroid,
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // PERMISSIONS AND UTILITY METHODS
  //----------------------------------------------------------------------------

  /// Requests notification permissions from the system.
  ///
  /// Returns `true` if permissions are granted, `false` otherwise.
  /// Handles platform-specific permission requests for iOS and Android.
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final plugin =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();
      final bool? result = await plugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result ?? false;
    } else if (Platform.isAndroid) {
      final plugin =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await plugin?.requestNotificationsPermission() ?? false;
    }
    return false;
  }

  /// Checks if the plugin is initialized and permissions are granted.
  ///
  /// Initializes the plugin if needed and verifies permissions.
  /// Returns `true` if notifications can be shown, `false` otherwise.
  Future<bool> _checkNotificationPrerequisites() async {
    if (!_isInitialized) {
      await init();
    }

    return await requestPermissions();
  }

  //----------------------------------------------------------------------------
  // NOTIFICATION CREATION AND CONFIGURATION
  //----------------------------------------------------------------------------

  /// Creates a notification builder to configure and show notifications.
  ///
  /// Returns a [NotificationBuilder] instance that provides a fluent API
  /// for configuring notification properties.
  ///
  /// [id] Unique identifier for this notification
  /// [title] Title text to display
  /// [body] Main content text to display
  /// [channelId] Channel identifier for grouping notifications
  /// [level] Importance level of the notification
  NotificationBuilder createNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    NotificationLevel level = NotificationLevel.normal,
  }) {
    return NotificationBuilder.create(
      this,
      id: id,
      title: title,
      body: body,
      channelId: channelId,
      level: level,
    );
  }

  /// Creates a notification details configuration based on settings.
  ///
  /// Configures platform-specific notification details based on the provided
  /// parameters.
  ///
  /// [channelId] The channel ID for categorizing the notification
  /// [level] The importance level of the notification
  /// [isFullScreen] Whether to show as a high-priority full-screen alert
  /// [imageBytes] Optional image to display in the notification
  /// [hasActions] Whether the notification includes interactive actions
  /// [actionLabels] Labels for notification action buttons
  Future<NotificationDetails> getNotificationDetailsConfig({
    required String channelId,
    required NotificationLevel level,
    bool isFullScreen = false,
    bool imageAttachment = false,
    bool hasActions = false,
    bool customSound = false,
  }) async {
    final Uint8List imageBytes = base64Decode(
      NotificationUtils.sampleImageBase64,
    );

    // Get the temporary directory using path_provider
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/notification_image.png';
    final File imageFile = File(filePath);

    // Only write the file if it doesn't already exist
    if (!await imageFile.exists()) {
      await imageFile.writeAsBytes(imageBytes);
    }

    // Get the appropriate channel ID based on customSound flag
    final effectiveChannelId = _getEffectiveChannelId(channelId, customSound);

    // Configure Android specific details
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      effectiveChannelId,
      effectiveChannelId.toUpperCase(),
      importance: level.importance,
      priority: level.priority,
      playSound: level.playSound,
      enableVibration: level.vibrate,
      visibility: level.visibility,
      fullScreenIntent: isFullScreen,
      styleInformation:
          imageAttachment
              ? BigPictureStyleInformation(
                ByteArrayAndroidBitmap(imageBytes),
                largeIcon: ByteArrayAndroidBitmap(imageBytes),
              )
              : null,
      actions:
          hasActions
              ? [
                ...['Snooze', 'Dismiss'].map(
                  (label) => AndroidNotificationAction(
                    label.toLowerCase().replaceAll(' ', '_'),
                    label,
                  ),
                ),
                const AndroidNotificationAction(
                  NotificationActionIds.reply,
                  NotificationActionTexts.reply,
                  inputs: [
                    AndroidNotificationActionInput(
                      label: NotificationActionTexts.reply,
                      allowFreeFormInput: true,
                    ),
                  ],
                ),
              ]
              : null,
    );

    // Configure iOS specific details
    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      categoryIdentifier:
          hasActions ? NotificationCategories.interactive : channelId,
      presentAlert: true,
      presentBadge: true,
      presentSound: level.playSound,
      sound: customSound ? NotificationResources.customSoundIOS : null,
      attachments:
          imageAttachment
              ? [
                DarwinNotificationAttachment(
                  filePath,
                  thumbnailClippingRect:
                      const DarwinNotificationAttachmentThumbnailClippingRect(
                        x: 0.0,
                        y: 0.0,
                        width: 0.3,
                        height: 0.3,
                      ),
                ),
              ]
              : null,
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  /// Helper method to get the appropriate channel ID based on custom sound flag
  String _getEffectiveChannelId(String channelId, bool customSound) {
    if (!Platform.isAndroid || !customSound) {
      return channelId;
    }

    // Map of standard channels to their sound-enabled counterparts
    const channelMap = {
      NotificationChannelIds.work: NotificationChannelIds.workSound,
      NotificationChannelIds.personal: NotificationChannelIds.personalSound,
      NotificationChannelIds.health: NotificationChannelIds.healthSound,
    };

    return channelMap[channelId] ?? channelId;
  }

  //----------------------------------------------------------------------------
  // NOTIFICATION DISPLAY METHODS
  //----------------------------------------------------------------------------

  /// Shows an instant notification immediately.
  ///
  /// Displays a notification with the configuration specified in [model].
  /// Validates prerequisites before showing the notification.
  Future<void> showInstantNotification({
    required NotificationModel model,
  }) async {
    final canShow = await _checkNotificationPrerequisites();
    if (!canShow) {
      debugPrint('Cannot show notification: prerequisites not met');
      return;
    }

    final details = await getNotificationDetailsConfig(
      channelId: model.channelId,
      level: model.level,
      isFullScreen: model.isFullScreen,
      imageAttachment: model.imageAttachment,
      hasActions: model.hasActions,
      customSound: model.customSound,
    );

    await _flutterLocalNotificationsPlugin.show(
      model.id,
      model.title,
      model.body,
      details,
      payload: model.toPayload(),
    );
  }

  /// Schedules a notification for a specific future time.
  ///
  /// Configures a notification to be delivered at the time specified in
  /// [model.scheduledTime]. If [enabled] is `false`, cancels any existing
  /// notification with the same ID.
  ///
  /// Throws an [ArgumentError] if [model.scheduledTime] is null.
  Future<void> scheduleNotification({
    required NotificationModel model,
    bool enabled = true,
  }) async {
    if (!enabled) {
      await cancelNotification(model.id);
      return;
    }

    final canShow = await _checkNotificationPrerequisites();
    if (!canShow) {
      debugPrint('Cannot schedule notification: prerequisites not met');
      return;
    }

    if (model.scheduledTime == null) {
      throw ArgumentError(
        'scheduledTime must be provided for scheduled notifications',
      );
    }

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      model.scheduledTime!,
      tz.local,
    );

    final details = await getNotificationDetailsConfig(
      channelId: model.channelId,
      level: model.level,
      isFullScreen: model.isFullScreen,
      imageAttachment: model.imageAttachment,
      hasActions: model.hasActions,
      customSound: model.customSound,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      model.id,
      model.title,
      model.body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: model.toPayload(),
    );
  }

  /// Displays a periodic notification that repeats at a fixed interval.
  ///
  /// Configures a notification to repeat according to the [model.repeatInterval].
  /// If [enabled] is `false`, cancels any existing notification with the same ID.
  ///
  /// Throws an [ArgumentError] if [model.repeatInterval] is null.
  Future<void> showPeriodicNotification({
    required NotificationModel model,
    bool enabled = true,
  }) async {
    if (!enabled) {
      await cancelNotification(model.id);
      return;
    }

    final canShow = await _checkNotificationPrerequisites();
    if (!canShow) {
      debugPrint('Cannot show periodic notification: prerequisites not met');
      return;
    }

    if (model.repeatInterval == null) {
      throw ArgumentError(
        'repeatInterval must be provided for periodic notifications',
      );
    }

    final details = await getNotificationDetailsConfig(
      channelId: model.channelId,
      level: model.level,
      isFullScreen: model.isFullScreen,
      imageAttachment: model.imageAttachment,
      hasActions: model.hasActions,
      customSound: model.customSound,
    );

    // For daily/weekly notifications with a specific time, use zonedSchedule with matchDateTimeComponents
    if (_shouldUseZonedSchedule(model)) {
      await _scheduleRecurringAtTime(model, details);
    } else {
      // For simpler repeating notifications without specific time requirements
      await _flutterLocalNotificationsPlugin.periodicallyShow(
        model.id,
        model.title,
        model.body,
        model.repeatInterval!,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: model.toPayload(),
      );
    }
  }

  /// Determines if zonedSchedule should be used instead of periodicallyShow.
  ///
  /// Returns `true` if the notification is daily or weekly and has a specific
  /// time of day set.
  bool _shouldUseZonedSchedule(NotificationModel model) {
    return (model.repeatInterval == RepeatInterval.daily ||
            model.repeatInterval == RepeatInterval.weekly) &&
        model.timeOfDay != null;
  }

  /// Schedules a recurring notification at a specific time.
  ///
  /// Configures a notification to repeat at a specific time of day based on
  /// the model's timeOfDay and optional dayOfWeek properties.
  Future<void> _scheduleRecurringAtTime(
    NotificationModel model,
    NotificationDetails details,
  ) async {
    // Calculate the next occurrence based on the model properties
    tz.TZDateTime nextOccurrence = _calculateNextOccurrence(
      timeOfDay: model.timeOfDay!,
      dayOfWeek:
          model.repeatInterval == RepeatInterval.weekly
              ? model.dayOfWeek
              : null,
    );

    // Determine the recurrence pattern
    DateTimeComponents matchDateTimeComponents =
        model.repeatInterval == RepeatInterval.daily
            ? DateTimeComponents.time
            : DateTimeComponents.dayOfWeekAndTime;

    // Schedule the notification with the recurrence pattern
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      model.id,
      model.title,
      model.body,
      nextOccurrence,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: matchDateTimeComponents,
      payload: model.toPayload(),
    );
  }

  /// Shows a notification with a progress indicator.
  ///
  /// Displays a notification showing progress toward completion of a task,
  /// using the values in [model.currentProgress] and [model.maxProgress].
  ///
  /// Throws an [ArgumentError] if progress values are not provided.
  Future<void> showProgressNotification({
    required NotificationModel model,
  }) async {
    if (model.maxProgress == null || model.currentProgress == null) {
      throw ArgumentError(
        'maxProgress and currentProgress must be provided for progress notifications',
      );
    }

    final canShow = await _checkNotificationPrerequisites();
    if (!canShow) {
      debugPrint('Cannot show progress notification: prerequisites not met');
      return;
    }

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      model.channelId,
      model.channelId.toUpperCase(),
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: model.maxProgress!,
      progress: model.currentProgress!,
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      categoryIdentifier: model.channelId,
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      model.id,
      model.title,
      model.body,
      details,
      payload: model.toPayload(),
    );
  }

  /// Creates a group of notifications with a summary.
  ///
  /// Converts the list of [notifications] to models and calls
  /// [showGroupedNotifications] to display them.
  Future<void> createGroupNotification({
    required String groupKey,
    required String channelId,
    required String groupTitle,
    required String groupSummary,
    required List<NotificationBuilder> notifications,
  }) async {
    List<NotificationModel> models =
        notifications.map((builder) => builder.model).toList();
    return await showGroupedNotifications(
      groupKey: groupKey,
      groupChannelId: channelId,
      groupTitle: groupTitle,
      groupSummary: groupSummary,
      notifications: models,
    );
  }

  /// Shows a set of grouped notifications with a summary.
  ///
  /// Displays multiple related notifications as a group with a summary notification
  /// on platforms that support it (primarily Android).
  Future<void> showGroupedNotifications({
    required String groupKey,
    required String groupChannelId,
    required String groupTitle,
    required String groupSummary,
    required List<NotificationModel> notifications,
  }) async {
    final canShow = await _checkNotificationPrerequisites();
    if (!canShow) {
      debugPrint('Cannot show grouped notifications: prerequisites not met');
      return;
    }

    // Create individual notifications
    for (final notification in notifications) {
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        groupChannelId,
        groupChannelId.toUpperCase(),
        importance: Importance.high,
        priority: Priority.high,
        groupKey: groupKey,
        setAsGroupSummary: false,
      );

      DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        categoryIdentifier: groupChannelId,
        threadIdentifier: groupKey,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        notification.id,
        notification.title,
        notification.body,
        details,
        payload: notification.toPayload(),
      );
    }

    // Create summary notification for Android
    if (Platform.isAndroid) {
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        groupChannelId,
        groupChannelId.toUpperCase(),
        importance: Importance.high,
        priority: Priority.high,
        groupKey: groupKey,
        setAsGroupSummary: true,
      );

      NotificationDetails details = NotificationDetails(
        android: androidDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        0, // Use a unique ID for the summary
        groupTitle,
        groupSummary,
        details,
      );
    }
  }

  //----------------------------------------------------------------------------
  // NOTIFICATION MANAGEMENT METHODS
  //----------------------------------------------------------------------------

  /// Cancels a specific notification by ID.
  ///
  /// Removes both active and pending notifications with the specified [id].
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancels all active and scheduled notifications.
  ///
  /// Removes all notifications created by the application.
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Gets a list of all pending notification requests.
  ///
  /// Returns a list of [NotificationModel] objects representing pending
  /// notifications. For notifications with invalid or missing payloads,
  /// creates fallback models with available information.
  Future<List<NotificationModel>> getPendingNotifications() async {
    final requests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return requests.map((request) {
      // Try to parse the payload into a NotificationModel
      if (request.payload != null) {
        try {
          return NotificationModel.fromPayload(request.payload!);
        } catch (e) {
          debugPrint('Failed to parse notification payload: $e');
        }
      }

      // If parsing fails or payload is null, create a fallback model
      return NotificationModel(
        id: request.id,
        title: request.title ?? 'No Title',
        body: request.body ?? 'No Message',
        channelId: NotificationChannelIds.defaultChannel,
        type: NotificationType.scheduled,
      );
    }).toList();
  }

  //----------------------------------------------------------------------------
  // HELPER METHODS
  //----------------------------------------------------------------------------

  /// Calculates the next occurrence time for a recurring notification.
  ///
  /// Determines when a notification should next appear based on the specified
  /// [timeOfDay] and optional [dayOfWeek].
  tz.TZDateTime _calculateNextOccurrence({
    required TimeOfDay timeOfDay,
    int? dayOfWeek,
  }) {
    final now = tz.TZDateTime.now(tz.local);

    // Set the time component
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // If the time today is already past, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // If a specific day of week is requested (for weekly notifications)
    if (dayOfWeek != null) {
      // Keep adding days until we reach the desired day of week
      while (scheduledDate.weekday != dayOfWeek) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }

    return scheduledDate;
  }
}
