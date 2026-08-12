import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDeleteButton extends StatelessWidget {
  const CustomDeleteButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon = Icons.delete_outline_rounded,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading;

    final backgroundColor = isLoading || isEnabled
        ? ColorPalette.error.withValues(alpha: 0.055)
        : ColorPalette.error.withValues(alpha: 0.025);

    final borderColor = isLoading || isEnabled
        ? ColorPalette.error.withValues(alpha: 0.48)
        : ColorPalette.error.withValues(alpha: 0.20);

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: canPress ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: ColorPalette.error,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: isLoading
              ? ColorPalette.error
              : ColorPalette.error.withValues(alpha: 0.45),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          side: BorderSide(color: borderColor, width: 1.2.w),
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
                  key: const ValueKey('delete-button-loading'),
                  color: ColorPalette.error,
                  size: 21.sp,
                  strokeWidth: 2.5.w,
                )
              : Row(
                  key: const ValueKey('delete-button-content'),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.ltr,
                  children: [
                    Icon(
                      icon,
                      size: 20.sp,
                      color: canPress
                          ? ColorPalette.error
                          : ColorPalette.error.withValues(alpha: 0.45),
                    ),
                    horizontalSpace(8),
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyle.font15ErrorBoldTajawal(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
