import 'package:alwaleed_admin/core/helper/arabic_numbers_helper.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/features/result_student/domain/entities/student_exam_results_overview_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentExamResultsStatisticsSection extends StatelessWidget {
  final StudentExamResultsOverviewEntity studentExamResultsOverview;

  const StudentExamResultsStatisticsSection({
    required this.studentExamResultsOverview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StudentExamResultStatisticCard(
            value:
                '${toArabicNumbers(studentExamResultsOverview.highestResultPercentage)}٪',
            label: 'أعلى نتيجة',
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _StudentExamResultStatisticCard(
            value:
                '${toArabicNumbers(studentExamResultsOverview.averageResultPercentage)}٪',
            label: 'متوسط النتائج',
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _StudentExamResultStatisticCard(
            value: toArabicNumbers(
              studentExamResultsOverview.completedExamsCount,
            ),
            label: 'اختبارًا',
          ),
        ),
      ],
    );
  }
}

class _StudentExamResultStatisticCard extends StatelessWidget {
  final String value;
  final String label;

  const _StudentExamResultStatisticCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 9.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorPalette.surface.withValues(alpha: 0.86),
            ColorPalette.highlight.withValues(alpha: 0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorPalette.primary, width: 1.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: AppTextStyle.font15PrimaryBoldTajawal()),
          ),
          verticalSpace(3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyle.font12TextSecondaryRegularTajawal(),
            ),
          ),
        ],
      ),
    );
  }
}
