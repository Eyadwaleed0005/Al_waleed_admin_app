import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/exam_result_summary_card.dart';
import 'package:flutter/material.dart';

class ExamResultsSummarySection extends StatelessWidget {
  const ExamResultsSummarySection({
    super.key,
    required this.averageScoreText,
    required this.participantsCountText,
  });

  final String averageScoreText;
  final String participantsCountText;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: ExamResultSummaryCard(
            valueText: averageScoreText,
            labelText: 'متوسط الدرجات',
            valueColor: ColorPalette.secondary,
          ),
        ),
        horizontalSpace(16),
        Expanded(
          child: ExamResultSummaryCard(
            valueText: participantsCountText,
            labelText: 'شاركوا',
            valueColor: ColorPalette.primary,
          ),
        ),
      ],
    );
  }
}