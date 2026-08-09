import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSecondaryButton extends StatelessWidget {
  const CustomSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback onPressed;

  final IconData? icon;

  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final bool canPress = isEnabled && !isLoading;

    final Color contentColor = isEnabled
        ? ColorPalette.primary
        : ColorPalette.disabled;

    final Color borderColor = isEnabled || isLoading
        ? ColorPalette.primary
        : ColorPalette.disabled;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton(
        onPressed: canPress ? onPressed : null,
        style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: ColorPalette.primary,
          disabledForegroundColor: ColorPalette.disabled,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          side: BorderSide(color: borderColor, width: 1.5.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isLoading
              ? AppLoadingIndicator(
                  key: const ValueKey('secondary-button-loading'),
                  color: ColorPalette.primary,
                  size: 20.sp,
                  strokeWidth: 2.5.w,
                )
              : icon == null
              ? Text(
                  text,
                  key: const ValueKey('secondary-button-text'),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.font15TextPrimaryBoldTajawal().copyWith(
                    color: contentColor,
                  ),
                )
              : Row(
                  key: const ValueKey('secondary-button-icon-and-text'),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(icon, size: 22.sp, color: contentColor),
                    horizontalSpace(8),
                    Flexible(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.font15TextPrimaryBoldTajawal()
                            .copyWith(color: contentColor),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
