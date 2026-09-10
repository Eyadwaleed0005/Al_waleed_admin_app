import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/view_exams_screen_widgets/exam_card.dart';
import 'package:flutter/material.dart';

class ExamsListView extends StatelessWidget {
  const ExamsListView({
    super.key,
    required this.exams,
    this.onExamPressed,
    this.onViewResultsPressed,
  });

  final List<ExamCardViewData> exams;

  final ValueChanged<ExamCardViewData>? onExamPressed;
  final ValueChanged<ExamCardViewData>? onViewResultsPressed;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.zero,
      itemCount: exams.length,
      separatorBuilder: (_, __) {
        return verticalSpace(14);
      },
      itemBuilder: (BuildContext context, int index) {
        final ExamCardViewData exam = exams[index];

        return ExamCard(
          exam: exam,
          onExamPressed: onExamPressed == null
              ? null
              : () {
                  onExamPressed!(exam);
                },
          onViewResultsPressed:
              exam.status == ExamStatus.ended && onViewResultsPressed != null
              ? () {
                  onViewResultsPressed!(exam);
                }
              : null,
        );
      },
    );
  }
}
