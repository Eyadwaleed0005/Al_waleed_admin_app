import 'dart:async';

import 'package:alwaleed_admain/app/routes/app_route_observer.dart';
import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppNetworkStatusListener extends StatefulWidget {
  const AppNetworkStatusListener({
    super.key,
    required this.child,
    required this.routeObserver,
  });

  final Widget child;
  final AppRouteObserver routeObserver;

  @override
  State<AppNetworkStatusListener> createState() {
    return _AppNetworkStatusListenerState();
  }
}

class _AppNetworkStatusListenerState extends State<AppNetworkStatusListener> {
  bool _initialStateChecked = false;

  bool get _canCheckNetworkStatus {
    final routeName = widget.routeObserver.currentRouteName.value;

    return routeName != null && routeName != RouteNames.splashScreen;
  }

  @override
  void initState() {
    super.initState();

    widget.routeObserver.currentRouteName.addListener(_handleRouteChanged);
  }

  @override
  void didUpdateWidget(covariant AppNetworkStatusListener oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.routeObserver == widget.routeObserver) {
      return;
    }

    oldWidget.routeObserver.currentRouteName.removeListener(
      _handleRouteChanged,
    );

    widget.routeObserver.currentRouteName.addListener(_handleRouteChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialStateChecked) {
      return;
    }

    _initialStateChecked = true;

    unawaited(_syncNetworkWithCurrentRoute());
  }

  void _handleRouteChanged() {
    if (!mounted) {
      return;
    }

    unawaited(_syncNetworkWithCurrentRoute());
  }

  Future<void> _syncNetworkWithCurrentRoute() async {
    if (!mounted || !_canCheckNetworkStatus) {
      return;
    }

    await context.read<NetworkStatusCubit>().checkConnection();
  }

  @override
  void dispose() {
    widget.routeObserver.currentRouteName.removeListener(_handleRouteChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
