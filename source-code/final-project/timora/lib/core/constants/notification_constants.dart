/// Notification channel IDs
class NotificationChannelIds {
  static const String work = 'work_channel';
  static const String personal = 'personal_channel';
  static const String health = 'health_channel';
  static const String defaultChannel = 'default';
}

/// Notification action IDs
class NotificationActionIds {
  static const String snooze = 'snooze';
  static const String dismiss = 'dismiss';
  static const String complete = 'complete';
  static const String view = 'view';
  static const String reply = 'reply';
}

/// Notification group IDs
class NotificationGroups {
  static const String work = 'work_group';
  static const String personal = 'personal_group';
  static const String health = 'health_group';
}

/// Notification payload keys
class NotificationPayloadKeys {
  static const String type = 'type';
  static const String id = 'id';
  static const String screen = 'screen';
  static const String data = 'data';
}

/// Notification channel display names and descriptions
class NotificationChannelDetails {
  static const String workName = 'Work Notifications';
  static const String workDescription =
      'Notifications related to work tasks and meetings';

  static const String personalName = 'Personal Notifications';
  static const String personalDescription =
      'Notifications for personal reminders and events';

  static const String healthName = 'Health Notifications';
  static const String healthDescription =
      'Notifications for health-related reminders';
}

/// Notification categories and interaction types
class NotificationCategories {
  static const String interactive = 'INTERACTIVE_CATEGORY';
}

/// Notification resources
class NotificationResources {
  static const String defaultIcon = '@mipmap/ic_launcher';
}

/// Notification action texts
class NotificationActionTexts {
  static const String snooze = 'Snooze';
  static const String dismiss = 'Dismiss';
  static const String reply = 'Reply';
}
