enum AppRoutes {
  home('/'),
  createNotification('/create-notification'),
  notificationDetails('/notification-details'),
  settings('/settings');

  final String value;
  const AppRoutes(this.value);

  static final Map<String, AppRoutes> _routeMap = {
    for (var route in AppRoutes.values) route.value: route,
  };

  static AppRoutes fromName(String name) {
    return _routeMap[name] ?? AppRoutes.home;
  }
}
