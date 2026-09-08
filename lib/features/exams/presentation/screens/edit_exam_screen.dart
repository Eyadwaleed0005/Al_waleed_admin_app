import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/delete_exam_use_case.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/get_exam_by_id_use_case.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/update_exam_use_case.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/edit_exam_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/edit_exam_screen_widgets/edit_exam_content.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/repositories/grades_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EditExamScreen extends StatelessWidget {
  const EditExamScreen({
    super.key,
    required this.exam,
    this.grades = const [],
  });

  final ExamEntity exam;
  final List<GradeEntity> grades;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditExamCubit>(
      create: (_) => EditExamCubit(
        examId: exam.examId,
        getExamByIdUseCase: GetIt.instance<GetExamByIdUseCase>(),
        updateExamUseCase: GetIt.instance<UpdateExamUseCase>(),
        deleteExamUseCase: GetIt.instance<DeleteExamUseCase>(),
        gradesRepository: GetIt.instance<GradesRepository>(),
      )..initialize(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: const EditExamContent(),
      ),
    );
  }
}