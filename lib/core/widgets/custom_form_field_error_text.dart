import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFormFieldErrorText extends StatelessWidget {
  const CustomFormFieldErrorText({super.key, required this.errorText});

  final String? errorText;

  @override
  Widget build(BuildContext context) {
    if (errorText == null || errorText!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 6.h, right: 12.w, left: 12.w),
      child: Text(
        errorText!,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: ColorPalette.error,
          fontSize: 12.sp,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
