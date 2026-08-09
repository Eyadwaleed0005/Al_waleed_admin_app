import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

OverlayEntry? _activeToastEntry;

void showAppToast(
  BuildContext context, {
  required String message,
  IconData icon = Icons.check_circle_rounded,
  Duration duration = const Duration(milliseconds: 1500),
}) {
  if (_activeToastEntry?.mounted ?? false) {
    _activeToastEntry?.remove();
  }

  late final OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return _AppToastOverlay(
        message: message,
        icon: icon,
        duration: duration,
        onDismiss: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }

          if (identical(_activeToastEntry, overlayEntry)) {
            _activeToastEntry = null;
          }
        },
      );
    },
  );

  _activeToastEntry = overlayEntry;

  Overlay.of(context, rootOverlay: true).insert(overlayEntry);
}

class _AppToastOverlay extends StatefulWidget {
  const _AppToastOverlay({
    required this.message,
    required this.icon,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_AppToastOverlay> createState() => _AppToastOverlayState();
}

class _AppToastOverlayState extends State<_AppToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );

    _showToast();
  }

  Future<void> _showToast() async {
    await _controller.forward();

    await Future<void>.delayed(widget.duration);

    if (!mounted) {
      return;
    }

    await _controller.reverse();

    if (!mounted) {
      return;
    }

    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 280.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPalette.textPrimary.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 20.r,
                          offset: Offset(0, 8.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon,
                          color: ColorPalette.accent,
                          size: 24.sp,
                        ),
                        horizontalSpace(10),
                        Flexible(
                          child: Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: AppTextStyle.font15SurfaceMediumTajawal(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
