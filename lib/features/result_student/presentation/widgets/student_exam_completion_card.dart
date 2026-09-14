import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/features/result_student/domain/entities/student_exam_results_overview_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentExamCompletionCard extends StatelessWidget {
  final StudentExamResultsOverviewEntity studentExamResultsOverview;

  const StudentExamCompletionCard({
    required this.studentExamResultsOverview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final int completedExamsCount =
        studentExamResultsOverview.completedExamsCount;

    final int totalExamsCount = studentExamResultsOverview.totalExamsCount;

    final double completionPercentage = totalExamsCount > 0
        ? (completedExamsCount / totalExamsCount)
              .clamp(0.0, 1.0)
              .toDouble()
        : 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 16.h,
      ),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorPalette.primary,
          width: 1.2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primaryShadow,
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: ColorPalette.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.fact_check_outlined,
                  color: ColorPalette.primary,
                  size: 24.sp,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الاختبارات المكتملة',
                      textAlign: TextAlign.right,
                      style:
                          AppTextStyle.font20TextPrimarySemiBoldKufam(),
                    ),
                    verticalSpace(4),
                    Text(
                      totalExamsCount == 0
                          ? 'لا توجد اختبارات مضافة لهذا الصف'
                          : 'أدى الطالب $completedExamsCount من أصل '
                                '$totalExamsCount اختبارات',
                      textAlign: TextAlign.right,
                      style:
                          AppTextStyle.font13TextSecondaryRegularTajawal(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(completionPercentage * 100).round()}%',
                style: AppTextStyle.font13TextSecondaryRegularTajawal()
                    .copyWith(
                      color: ColorPalette.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                '$completedExamsCount / $totalExamsCount',
                style: AppTextStyle.font20TextPrimarySemiBoldKufam()
                    .copyWith(
                      color: ColorPalette.primary,
                    ),
              ),
            ],
          ),
          verticalSpace(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(
                begin: 0,
                end: completionPercentage,
              ),
              builder: (context, animatedValue, child) {
                return LinearProgressIndicator(
                  value: animatedValue,
                  minHeight: 9.h,
                  backgroundColor: ColorPalette.primary.withOpacity(0.10),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorPalette.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}