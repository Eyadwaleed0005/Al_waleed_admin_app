import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_results_report_entity.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/exam_attempts_status_section.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_summary_section.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_ui_helper.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_welcome_card.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/student_exam_result_card.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/student_exam_results_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamResultsSuccessView extends StatelessWidget {
  const ExamResultsSuccessView({super.key, required this.report});

  final ExamResultsReportEntity report;

  @override
  Widget build(BuildContext context) {
    final List<StudentExamResultViewData> studentResults =
        ExamResultsUiHelper.mapResultsToViewData(report);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      sliver: SliverMainAxisGroup(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: AppAnimations.screenSection(
              delay: 120,
              child: ExamResultsWelcomeCard(
                examName: report.exam.examName,
                examDetailsText: ExamResultsUiHelper.buildExamDetailsText(
                  report.exam,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: verticalSpace(24)),
          SliverToBoxAdapter(
            child: AppAnimations.screenSection(
              delay: 240,
              child: ExamResultsSummarySection(
                averageScoreText: ExamResultsUiHelper.formatAverageScore(
                  report,
                ),
                participantsCountText:
                    ExamResultsUiHelper.formatParticipantsCount(report),
              ),
            ),
          ),
          SliverToBoxAdapter(child: verticalSpace(16)),
          SliverToBoxAdapter(
            child: AppAnimations.screenSection(
              delay: 300,
              child: ExamAttemptsStatusSection(
                submittedCount: report.submittedCount,
                inProgressCount: report.inProgressCount,
              ),
            ),
          ),
          SliverToBoxAdapter(child: verticalSpace(24)),
          if (!report.hasSubmittedResults)
            const SliverToBoxAdapter(
              child: AppEmptyWidget(
                title: 'لم يسلّم أي طالب حتى الآن',
                message:
                    'يوجد طلاب ما زالوا يؤدون الاختبار، '
                    'وستظهر نتائجهم هنا بعد التسليم.',
                icon: Icons.hourglass_top_rounded,
              ),
            )
          else
            StudentExamResultsListView(studentResults: studentResults),
        ],
      ),
    );
  }
}
