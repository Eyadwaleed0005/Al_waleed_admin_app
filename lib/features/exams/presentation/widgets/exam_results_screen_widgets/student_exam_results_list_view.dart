import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/student_exam_result_card.dart';
import 'package:flutter/material.dart';

class StudentExamResultsListView extends StatelessWidget {
  const StudentExamResultsListView({
    super.key,
    required this.studentResults,
  });

  final List<StudentExamResultViewData> studentResults;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: studentResults.length,
      separatorBuilder: (_, __) => verticalSpace(14),
      itemBuilder: (context, index) {
        final StudentExamResultViewData studentResult =
            studentResults[index];

        return StudentExamResultCard(
          studentResult: studentResult,
        );
      },
    );
  }
}