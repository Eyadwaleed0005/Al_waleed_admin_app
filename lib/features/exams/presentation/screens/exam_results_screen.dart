import 'package:alwaleed_admin/app/dependency_injection/service_locator.dart';
import 'package:alwaleed_admin/core/helper/app_system_ui.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/exam_results_cubit.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_results_screen_widgets/exam_results_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamResultsScreen extends StatelessWidget {
  const ExamResultsScreen({super.key, required this.examId});

  final String examId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExamResultsCubit>(
      create: (_) {
        return getIt<ExamResultsCubit>()..loadExamResults(examId: examId);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.dark(),
        child: const ExamResultsContent(),
      ),
    );
  }
}
