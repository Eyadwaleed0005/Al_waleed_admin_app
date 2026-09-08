import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/view_exams_screen_widgets/exam_card.dart';
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
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: exams.length,
      separatorBuilder: (_, __) => verticalSpace(14),
      itemBuilder: (context, index) {
        final ExamCardViewData exam = exams[index];

        return ExamCard(
          exam: exam,
          onExamPressed:
              exam.status == ExamStatus.ended || onExamPressed == null
              ? null
              : () => onExamPressed!(exam),
          onViewResultsPressed:
              exam.status != ExamStatus.ended || onViewResultsPressed == null
              ? null
              : () => onViewResultsPressed!(exam),
        );
      },
    );
  }
}
