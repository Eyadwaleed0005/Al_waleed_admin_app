import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/add_exam_question_cubit.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/add_exam_questions_screen_widgets/add_exam_questions_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExamQuestionsScreen extends StatelessWidget {
  const AddExamQuestionsScreen({
    super.key,
    required this.examDraft,
  });

  final ExamDraftEntity examDraft;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddExamQuestionCubit>(
      create: (_) => AddExamQuestionCubit(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: AddExamQuestionsContent(
          examDraft: examDraft,
        ),
      ),
    );
  }
}