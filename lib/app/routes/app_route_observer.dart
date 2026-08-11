import 'package:flutter/material.dart';

class AppRouteObserver extends NavigatorObserver {
  final ValueNotifier<String?> currentRouteName = ValueNotifier<String?>(null);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    _updateCurrentRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    _updateCurrentRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    _updateCurrentRoute(newRoute);
  }

  void _updateCurrentRoute(Route<dynamic>? route) {
    final routeName = route?.settings.name;

    if (routeName == null) {
      return;
    }

    if (currentRouteName.value == routeName) {
      return;
    }

    currentRouteName.value = routeName;
  }
}
