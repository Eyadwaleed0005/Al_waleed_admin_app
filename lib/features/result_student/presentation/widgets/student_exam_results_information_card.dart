import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/features/result_student/domain/entities/student_exam_results_overview_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentExamResultsInformationCard extends StatelessWidget {
  final StudentExamResultsOverviewEntity studentExamResultsOverview;

  const StudentExamResultsInformationCard({
    required this.studentExamResultsOverview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isStudentAccountActive =
        studentExamResultsOverview.isStudentAccountActive;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorPalette.primary, width: 1.2.w),
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
          Text(
            studentExamResultsOverview.studentFullName,
            textAlign: TextAlign.right,
            style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
          ),
          verticalSpace(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                studentExamResultsOverview.studentGradeName,
                style: AppTextStyle.font13TextSecondaryRegularTajawal(),
              ),
              horizontalSpace(6),
              Text(
                '•',
                style: AppTextStyle.font13TextSecondaryRegularTajawal(),
              ),
              horizontalSpace(6),
              Text(
                isStudentAccountActive ? 'الحساب نشط' : 'الحساب غير نشط',
                style: AppTextStyle.font13TextSecondaryRegularTajawal()
                    .copyWith(
                      color: isStudentAccountActive
                          ? ColorPalette.success
                          : ColorPalette.error,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
