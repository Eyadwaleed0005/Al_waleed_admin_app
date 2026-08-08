import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
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
      onRefresh: onRefresh,
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
}