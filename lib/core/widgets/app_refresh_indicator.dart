import 'dart:async';

import 'package:alwaleed_admin/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admin/core/connection/cubit/network_status_state.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final RefreshCallback onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return _handleRefresh(context);
      },
      color: ColorPalette.primary,
      backgroundColor: ColorPalette.surface,
      strokeWidth: 3.w,
      edgeOffset: 0,
      displacement: 36.h,
      elevation: 2,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      semanticsLabel: 'تحديث البيانات',
      notificationPredicate: (ScrollNotification notification) {
        return notification.depth == 0;
      },
      child: child,
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final NetworkStatusCubit networkCubit = context.read<NetworkStatusCubit>();

    if (networkCubit.state is NetworkStatusDisconnected) {
      unawaited(networkCubit.checkConnection(forceShowOfflineBanner: true));

      return;
    }

    await onRefresh();
  }
}
