import 'package:alwaleed_admin/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admin/features/result_student/presentation/cubit/student_exam_results_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentExamResultsErrorView extends StatelessWidget {
  final String studentId;
  final String errorMessage;

  const StudentExamResultsErrorView({
    required this.studentId,
    required this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: errorMessage,
      onRetry: () {
        context
            .read<StudentExamResultsCubit>()
            .getStudentExamResultsByStudentId(studentId: studentId);
      },
    );
  }
}
