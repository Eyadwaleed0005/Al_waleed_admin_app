import 'package:alwaleed_admin/core/helper/app_system_ui.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_draft_entity.dart';
import 'package:alwaleed_admin/features/exams/domain/use_case/create_exam_question_use_case.dart';
import 'package:alwaleed_admin/features/exams/domain/use_case/create_exam_use_case.dart';
import 'package:alwaleed_admin/features/exams/domain/use_case/delete_exam_question_use_case.dart';
import 'package:alwaleed_admin/features/exams/domain/use_case/get_exam_by_id_use_case.dart';
import 'package:alwaleed_admin/features/exams/domain/use_case/update_exam_question_use_case.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/exam_questions_cubit.dart';
import 'package:alwaleed_admin/features/exams/presentation/widgets/exam_questions_screen_widgets/exam_questions_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ExamQuestionsScreen extends StatelessWidget {
  const ExamQuestionsScreen({super.key, this.examId, this.examDraft});

  final String? examId;

  final ExamDraftEntity? examDraft;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExamQuestionsCubit>(
      create: (_) {
        return ExamQuestionsCubit(
          examId: examId,
          examDraft: examDraft,
          getExamByIdUseCase: GetIt.instance<GetExamByIdUseCase>(),
          createExamUseCase: GetIt.instance<CreateExamUseCase>(),
          createExamQuestionUseCase:
              GetIt.instance<CreateExamQuestionUseCase>(),
          updateExamQuestionUseCase:
              GetIt.instance<UpdateExamQuestionUseCase>(),
          deleteExamQuestionUseCase:
              GetIt.instance<DeleteExamQuestionUseCase>(),
        )..initialize();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.dark(),
        child: ExamQuestionsContent(examId: examId, examDraft: examDraft),
      ),
    );
  }
}
