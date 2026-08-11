import 'package:alwaleed_admain/app/routes/app_route_observer.dart';
import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/core/connection/cubit/network_status_state.dart';
import 'package:alwaleed_admain/core/widgets/app_offline_banner.dart';
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
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool _initialStateChecked = false;
  bool _isOfflineBannerActive = false;

  bool get _canShowOfflineBanner {
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

    _syncBannerWithCurrentState();
  }

  void _handleRouteChanged() {
    if (!mounted) {
      return;
    }

    _syncBannerWithCurrentState();
  }

  void _syncBannerWithCurrentState() {
    if (!_canShowOfflineBanner) {
      _hideOfflineBanner();
      return;
    }

    final networkState = context.read<NetworkStatusCubit>().state;

    if (networkState is NetworkStatusDisconnected) {
      _showOfflineBanner();
      return;
    }

    _hideOfflineBanner();
  }

  void _showOfflineBanner() {
    if (!_canShowOfflineBanner || _isOfflineBannerActive) {
      return;
    }

    _isOfflineBannerActive = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      if (!_canShowOfflineBanner) {
        _isOfflineBannerActive = false;
        return;
      }

      final networkState = context.read<NetworkStatusCubit>().state;

      if (networkState is! NetworkStatusDisconnected) {
        _isOfflineBannerActive = false;
        return;
      }

      final scaffoldMessenger = _scaffoldMessengerKey.currentState;

      if (scaffoldMessenger == null) {
        _isOfflineBannerActive = false;
        return;
      }

      scaffoldMessenger.clearMaterialBanners();

      scaffoldMessenger.showMaterialBanner(
        MaterialBanner(
          padding: EdgeInsets.zero,
          leadingPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          dividerColor: Colors.transparent,
          elevation: 0,
          content: AppOfflineBanner(onHidden: _hideOfflineBanner),
          actions: const [SizedBox.shrink()],
        ),
      );
    });
  }

  void _hideOfflineBanner() {
    _isOfflineBannerActive = false;

    _scaffoldMessengerKey.currentState?.clearMaterialBanners();
  }

  void _handleNetworkState(NetworkStatusState state) {
    if (!_canShowOfflineBanner) {
      _hideOfflineBanner();
      return;
    }

    if (state is NetworkStatusDisconnected) {
      _showOfflineBanner();
      return;
    }

    if (state is NetworkStatusConnected) {
      _hideOfflineBanner();
    }
  }

  @override
  void dispose() {
    widget.routeObserver.currentRouteName.removeListener(_handleRouteChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: BlocListener<NetworkStatusCubit, NetworkStatusState>(
        listenWhen: (previous, current) {
          final wasOffline = previous is NetworkStatusDisconnected;

          final isOffline = current is NetworkStatusDisconnected;

          return wasOffline != isOffline;
        },
        listener: (context, state) {
          _handleNetworkState(state);
        },
        child: widget.child,
      ),
    );
  }
}
