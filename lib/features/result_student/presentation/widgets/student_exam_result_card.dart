import 'package:alwaleed_admain/core/helper/arabic_numbers_helper.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/features/result_student/domain/entities/student_exam_result_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentExamResultCard extends StatelessWidget {
  final StudentExamResultEntity studentExamResult;

  const StudentExamResultCard({required this.studentExamResult, super.key});

  @override
  Widget build(BuildContext context) {
    final double normalizedResultProgress =
        (studentExamResult.resultPercentage / 100).clamp(0, 1).toDouble();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorPalette.primary, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primaryShadow,
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '${toArabicNumbers(studentExamResult.studentObtainedScore)} / ${toArabicNumbers(studentExamResult.examTotalScore)}',
                  style: AppTextStyle.font12PrimaryBoldTajawal(),
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Text(
                  studentExamResult.examName,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.font15TextPrimaryBoldTajawal(),
                ),
              ),
            ],
          ),
          verticalSpace(8),
          Row(
            children: [
              Expanded(
                child: Text(
                  MaterialLocalizations.of(
                    context,
                  ).formatMediumDate(studentExamResult.examSubmittedAt),
                  textAlign: TextAlign.left,
                  style: AppTextStyle.font11TextMutedRegularTajawal(),
                ),
              ),
              horizontalSpace(12),
              Text(
                'اختبار عام • ${toArabicNumbers(studentExamResult.resultPercentage)}٪',
                textAlign: TextAlign.right,
                style: AppTextStyle.font11PrimaryBoldTajawal().copyWith(
                  color: ColorPalette.secondary,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: normalizedResultProgress,
              minHeight: 6.h,
              color: ColorPalette.primary,
              backgroundColor: ColorPalette.paleSage,
            ),
          ),
        ],
      ),
    );
  }
}
