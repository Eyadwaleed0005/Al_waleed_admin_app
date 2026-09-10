import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/features/result_student/domain/entities/student_exam_results_overview_entity.dart';
import 'package:alwaleed_admain/features/result_student/presentation/cubit/student_exam_results_cubit.dart';
import 'package:alwaleed_admain/features/result_student/presentation/widgets/student_exam_result_card.dart';
import 'package:alwaleed_admain/features/result_student/presentation/widgets/student_exam_results_information_card.dart';
import 'package:alwaleed_admain/features/result_student/presentation/widgets/student_exam_results_section_header.dart';
import 'package:alwaleed_admain/features/result_student/presentation/widgets/student_exam_results_statistics_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentExamResultsSuccessView extends StatelessWidget {
  final String studentId;
  final StudentExamResultsOverviewEntity studentExamResultsOverview;

  const StudentExamResultsSuccessView({
    required this.studentId,
    required this.studentExamResultsOverview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorPalette.primary,
      backgroundColor: ColorPalette.surface,
      onRefresh: () {
        return context
            .read<StudentExamResultsCubit>()
            .getStudentExamResultsByStudentId(studentId: studentId);
      },
      child: ListView(
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
            child: StudentExamResultsStatisticsSection(
              studentExamResultsOverview: studentExamResultsOverview,
            ),
          ),
          verticalSpace(14),
          AppAnimations.screenSection(
            delay: 200,
            child: const StudentExamResultsSectionHeader(),
          ),
          verticalSpace(14),
          for (
            int resultIndex = 0;
            resultIndex < studentExamResultsOverview.studentExamResults.length;
            resultIndex++
          ) ...[
            AppAnimations.formFieldEntrance(
              order: resultIndex + 3,
              child: StudentExamResultCard(
                studentExamResult:
                    studentExamResultsOverview.studentExamResults[resultIndex],
              ),
            ),
            if (resultIndex !=
                studentExamResultsOverview.studentExamResults.length - 1)
              verticalSpace(12),
          ],
        ],
      ),
    );
  }
}
