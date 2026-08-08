import 'dart:async';

import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppOfflineBanner extends StatefulWidget {
  const AppOfflineBanner({
    super.key,
    this.message = 'لا يوجد اتصال بالإنترنت، يتم عرض آخر بيانات محفوظة.',
    this.displayDuration = const Duration(seconds: 8),
    this.onHidden,
  });

  final String message;
  final Duration displayDuration;
  final VoidCallback? onHidden;

  @override
  State<AppOfflineBanner> createState() => _AppOfflineBannerState();
}

class _AppOfflineBannerState extends State<AppOfflineBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _animation;

  late final Animation<Offset> _slideAnimation;

  late final Key _dismissibleKey;

  Timer? _hideTimer;

  bool _isHiding = false;

  @override
  void initState() {
    super.initState();

    _dismissibleKey = UniqueKey();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(_animation);

    _animationController.forward();

    _hideTimer = Timer(widget.displayDuration, _hide);
  }

  Future<void> _hide() async {
    if (_isHiding) {
      return;
    }

    _isHiding = true;
    _hideTimer?.cancel();

    await _animationController.reverse();

    if (!mounted) {
      return;
    }

    widget.onHidden?.call();
  }

  void _handleDismissed(DismissDirection direction) {
    if (_isHiding) {
      return;
    }

    _isHiding = true;
    _hideTimer?.cancel();
    widget.onHidden?.call();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Dismissible(
            key: _dismissibleKey,
            direction: DismissDirection.horizontal,
            resizeDuration: const Duration(milliseconds: 250),
            onDismissed: _handleDismissed,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorPalette.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: const BoxDecoration(
                      color: ColorPalette.background,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: 20.sp,
                      color: ColorPalette.error,
                    ),
                  ),

                  horizontalSpace(12),

                  Expanded(
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.right,
                      style: AppTextStyle.font14ErrorSemiBoldTajawal(),
                    ),
                  ),

                  horizontalSpace(8),

                  IconButton(
                    onPressed: _hide,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20.sp,
                      color: ColorPalette.error,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
