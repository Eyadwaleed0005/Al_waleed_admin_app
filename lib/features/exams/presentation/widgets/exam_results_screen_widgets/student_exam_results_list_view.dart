import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_animations.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/student_exam_result_card.dart';
import 'package:flutter/material.dart';

class StudentExamResultsListView extends StatelessWidget {
  const StudentExamResultsListView({
    super.key,
    required this.studentResults,
  });

  final List<StudentExamResultViewData> studentResults;

  @override
  Widget build(BuildContext context) {
    final int childrenCount = studentResults.isEmpty
        ? 0
        : studentResults.length * 2 - 1;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index.isOdd) {
            return verticalSpace(14);
          }

          final int studentIndex = index ~/ 2;
          final int staggerIndex =
              studentIndex > 4 ? 4 : studentIndex;

          final int animationDelay =
              380 + (staggerIndex * 70);

          return AppAnimations.screenSection(
            delay: animationDelay,
            child: StudentExamResultCard(
              studentResult: studentResults[studentIndex],
            ),
          );
        },
        childCount: childrenCount,
      ),
    );
  }
}