import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/update_exam_question_use_case.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/edit_exam_question_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/edit_exam_question_screen_widgets/edit_exam_question_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EditExamQuestionScreen extends StatelessWidget {
  const EditExamQuestionScreen({super.key, required this.questionDraft});

  final ExamQuestionDraftEntity questionDraft;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditExamQuestionCubit>(
      create: (_) {
        return EditExamQuestionCubit(
          questionDraft: questionDraft,
          updateExamQuestionUseCase:
              GetIt.instance<UpdateExamQuestionUseCase>(),
        );
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: EditExamQuestionContent(questionDraft: questionDraft),
      ),
    );
  }
}
