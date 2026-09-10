import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/features/result_student/presentation/widgets/student_exam_results_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentExamResultsScreen extends StatelessWidget {
  final String studentId;

  const StudentExamResultsScreen({
    required this.studentId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: StudentExamResultsContent(
        studentId: studentId,
      ),
    );
  }
}