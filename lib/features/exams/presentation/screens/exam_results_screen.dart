import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExamResultsScreen extends StatelessWidget {
  const ExamResultsScreen({
    super.key,
    required this.examId,
  });

  final String examId;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: ExamResultsContent(
        examId: examId,
      ),
    );
  }
}