import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavItem extends StatefulWidget {
  const NavItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<NavItem> createState() => NavItemState();
}

class NavItemState extends State<NavItem> {
  bool isPressed = false;

  void changePressedState(bool value) {
    if (isPressed == value) return;

    setState(() {
      isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isSelected || isPressed;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => changePressedState(true),
        onTapUp: (_) => changePressedState(false),
        onTapCancel: () => changePressedState(false),
        child: SizedBox(
          height: double.infinity,
          child: Center(
            child: AnimatedScale(
              scale: isPressed ? 0.94 : 1,
              duration: const Duration(milliseconds: 110),
              curve: Curves.easeOut,
              child: AppAnimations.bottomNavItem(
                isSelected: widget.isSelected,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  height: 54.h,
                  constraints: BoxConstraints(minWidth: 48.w, maxWidth: 68.w),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? ColorPalette.primarySoftBackground
                        : isPressed
                        ? ColorPalette.accent.withValues(alpha: 0.18)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isActive
                          ? ColorPalette.accent
                          : Colors.transparent,
                      width: isActive ? 1 : 0,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: ColorPalette.accent.withValues(
                                alpha: isPressed ? 0.34 : 0.20,
                              ),
                              blurRadius: isPressed ? 10.r : 7.r,
                              spreadRadius: isPressed ? 0.5.r : 0.2.r,
                            ),
                            BoxShadow(
                              color: ColorPalette.primary.withValues(
                                alpha: 0.06,
                              ),
                              blurRadius: 5.r,
                              offset: Offset(0, 2.h),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: widget.isSelected ? 1.05 : 1,
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutBack,
                        child: Image.asset(
                          widget.iconPath,
                          width: 23.w,
                          height: 23.w,
                          fit: BoxFit.contain,
                          color: isActive
                              ? ColorPalette.primary
                              : ColorPalette.textMuted,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported_outlined,
                              size: 23.sp,
                              color: isActive
                                  ? ColorPalette.primary
                                  : ColorPalette.textMuted,
                            );
                          },
                        ),
                      ),
                      verticalSpace(3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        style: isActive
                            ? Textstyles.font11PrimaryBoldTajawal()
                            : Textstyles.font11TextMutedRegularTajawal(),
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
    );
  }
}
