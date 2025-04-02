/// Notification channel IDs
class NotificationChannelIds {
  // Standard notification channels
  static const String work = 'work_notifications';
  static const String personal = 'personal_notifications';
  static const String health = 'health_notifications';
  static const String defaultChannel = 'default_notifications';

  // Channels with custom sounds - naming convention: <channel>_sound
  static const String workSound = '${work}_sound';
  static const String personalSound = '${personal}_sound';
  static const String healthSound = '${health}_sound';
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
  // Standard channel names and descriptions
  static const String workName = 'Work Notifications';
  static const String workDescription =
      'Notifications related to work and productivity';

  static const String personalName = 'Personal Notifications';
  static const String personalDescription =
      'Notifications related to personal matters';

  static const String healthName = 'Health Notifications';
  static const String healthDescription =
      'Notifications related to health and wellness';

  // Custom sound channel names and descriptions - consistent naming pattern
  static const String workSoundName = '$workName with Sound';
  static const String workSoundDescription =
      '$workDescription (with custom sound)';

  static const String personalSoundName = '$personalName with Sound';
  static const String personalSoundDescription =
      '$personalDescription (with custom sound)';

  static const String healthSoundName = '$healthName with Sound';
  static const String healthSoundDescription =
      '$healthDescription (with custom sound)';
}

/// Notification categories and interaction types
class NotificationCategories {
  static const String interactive = 'INTERACTIVE_CATEGORY';
}

/// Notification resources
class NotificationResources {
  static const String defaultIcon = '@mipmap/ic_launcher';
  static const String customSoundAndroid = 'custom_sound';
  static const String customSoundIOS = 'custom_sound.wav';
}

/// Notification action texts
class NotificationActionTexts {
  static const String snooze = 'Snooze';
  static const String dismiss = 'Dismiss';
  static const String reply = 'Reply';
}
