import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admin/features/result_student/domain/entities/student_exam_results_overview_entity.dart';
import 'package:alwaleed_admin/features/result_student/presentation/widgets/student_exam_completion_card.dart';
import 'package:alwaleed_admin/features/result_student/presentation/widgets/student_exam_results_information_card.dart';
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
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      children: [
        AppAnimations.screenSection(
          delay: 80,
          child: StudentExamResultsInformationCard(
            studentExamResultsOverview: studentExamResultsOverview,
          ),
        ),
        verticalSpace(16),
        AppAnimations.screenSection(
          delay: 140,
          child: StudentExamCompletionCard(
            studentExamResultsOverview: studentExamResultsOverview,
          ),
        ),
        verticalSpace(24),
        AppAnimations.screenSection(
          delay: 200,
          child: AppEmptyWidget(
            title: 'لا توجد نتائج اختبارات',
            message:
                'لم يؤدِ ${studentExamResultsOverview.studentFullName} '
                'أي اختبار حتى الآن',
            icon: Icons.science_outlined,
          ),
        ),
      ],
    );
  }
}
