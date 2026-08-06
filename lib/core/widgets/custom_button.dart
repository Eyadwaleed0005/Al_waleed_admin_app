import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final bool canPress = isEnabled && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: canPress ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ColorPalette.primary,
          foregroundColor: ColorPalette.surface,
          disabledBackgroundColor: isLoading
              ? ColorPalette.primary
              : ColorPalette.disabled,
          disabledForegroundColor: ColorPalette.surface,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ?  AppLoadingIndicator(
                  key: ValueKey('button-loading'),
                  color: ColorPalette.surface,
                  size: 20.sp,
                  strokeWidth: 2.5.w,
                )
              : Text(
                  text,
                  key: const ValueKey('button-text'),
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyle.font15SurfaceBoldTajawal(),
                ),
        ),
      ),
    );
  }
}