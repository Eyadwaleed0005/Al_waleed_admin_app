import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
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
      displacement: 50.h,
      edgeOffset: 4.h,
      elevation: 2,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      semanticsLabel: 'تحديث البيانات',
      child: child,
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    await context.read<NetworkStatusCubit>().checkConnection(
      forceShowOfflineBanner: true,
    );

    if (!context.mounted) {
      return;
    }

    await onRefresh();
  }
}
