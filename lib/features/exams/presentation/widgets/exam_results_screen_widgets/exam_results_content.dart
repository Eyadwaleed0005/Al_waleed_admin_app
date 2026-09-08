import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_summary_section.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_welcome_card.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/student_exam_result_card.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/student_exam_results_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamResultsContent extends StatelessWidget {
  const ExamResultsContent({super.key, required this.examId});

  final String examId;

  static const List<StudentExamResultViewData> _previewStudentResults = [
    StudentExamResultViewData(
      studentId: 'student-1',
      studentName: 'عمر أحمد',
      gradeName: 'الثالث الثانوي',
      studentScoreText: '٣٨',
      totalScoreText: '٤٠',
      status: StudentExamResultStatus.passed,
    ),
    StudentExamResultViewData(
      studentId: 'student-2',
      studentName: 'مريم خالد',
      gradeName: 'الثالث الثانوي',
      studentScoreText: '٣٤',
      totalScoreText: '٤٠',
      status: StudentExamResultStatus.passed,
    ),
    StudentExamResultViewData(
      studentId: 'student-3',
      studentName: 'يوسف سامح',
      gradeName: 'الثالث الثانوي',
      studentScoreText: '٣١',
      totalScoreText: '٤٠',
      status: StudentExamResultStatus.passed,
    ),
    StudentExamResultViewData(
      studentId: 'student-4',
      studentName: 'سلمى عادل',
      gradeName: 'الثالث الثانوي',
      studentScoreText: '١٧',
      totalScoreText: '٤٠',
      status: StudentExamResultStatus.failed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentManagementBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppAnimations.screenSection(
                  delay: 0,
                  child: const SecondaryCustomHeaderBar(title: 'تقرير النتائج'),
                ),
                verticalSpace(30),
                AppAnimations.screenSection(
                  delay: 120,
                  child: const ExamResultsWelcomeCard(
                    examName: 'اختبار الكيمياء العضوية',
                    examDetailsText: 'انتهى في ١٨ يوليو ٢٠٢٦ · ٤٠ درجة',
                  ),
                ),
                verticalSpace(24),
                AppAnimations.screenSection(
                  delay: 240,
                  child: const ExamResultsSummarySection(
                    averageScoreText: '٨٢٪',
                    participantsCountText: '٩٦',
                  ),
                ),
                verticalSpace(24),
                Expanded(
                  child: AppAnimations.screenSection(
                    delay: 360,
                    child: StudentExamResultsListView(
                      studentResults: _previewStudentResults,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
