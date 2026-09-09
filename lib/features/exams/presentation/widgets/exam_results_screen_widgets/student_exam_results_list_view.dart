import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/student_exam_result_card.dart';
import 'package:flutter/material.dart';

class StudentExamResultsListView extends StatelessWidget {
  const StudentExamResultsListView({super.key, required this.studentResults});

  final List<StudentExamResultViewData> studentResults;

  @override
  Widget build(BuildContext context) {
    final int childrenCount = studentResults.isEmpty
        ? 0
        : studentResults.length * 2 - 1;

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index.isOdd) {
          return verticalSpace(14);
        }

        final int studentIndex = index ~/ 2;

        return StudentExamResultCard(
          studentResult: studentResults[studentIndex],
        );
      }, childCount: childrenCount),
    );
  }
}
