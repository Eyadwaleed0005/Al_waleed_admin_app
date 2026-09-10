import 'package:alwaleed_admain/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admain/features/result_student/domain/entities/student_exam_results_overview_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentExamResultsEmptyView extends StatelessWidget {
  final StudentExamResultsOverviewEntity studentExamResultsOverview;

  const StudentExamResultsEmptyView({
    required this.studentExamResultsOverview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 20.h,
      ),
      child: AppEmptyWidget(
        title: 'لا توجد نتائج اختبارات',
        message:
            'لم يؤدِ ${studentExamResultsOverview.studentFullName} أي اختبار حتى الآن',
        icon: Icons.science_outlined,
      ),
    );
  }
}