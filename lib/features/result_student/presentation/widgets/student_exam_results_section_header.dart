import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentExamResultsSectionHeader extends StatelessWidget {
  const StudentExamResultsSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorPalette.surface.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Text(
        'نتائج الاختبارات',
        textAlign: TextAlign.center,
        style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
      ),
    );
  }
}
