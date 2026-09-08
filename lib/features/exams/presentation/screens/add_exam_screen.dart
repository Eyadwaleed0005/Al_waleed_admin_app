import 'package:alwaleed_admain/app/dependency_injection/service_locator.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/add_exam_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/add_exam_screen_widgets/add_exam_content.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExamScreen extends StatelessWidget {
  const AddExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddExamCubit(
        streamGradesUseCase: getIt<StreamGradesUseCase>(),
      )..loadGrades(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: const AddExamContent(),
      ),
    );
  }
}