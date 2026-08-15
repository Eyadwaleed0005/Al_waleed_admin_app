import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/lesson_exams_state.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exam_questions_list.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exam_total_degrees_card.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exams_actions.dart';
import 'package:flutter/material.dart';

class LessonExamsContent extends StatelessWidget {
  const LessonExamsContent({
    super.key,
    required this.state,
    required this.onChoiceSelected,
    required this.onDeleteQuestion,
    required this.onEditQuestion,
    required this.onSaveExamPressed,
    required this.onAddQuestionPressed,
  });

  final LessonExamsState state;

  final LessonExamChoiceSelected onChoiceSelected;

  final ValueChanged<LessonExamQuestionEntity> onDeleteQuestion;

  final ValueChanged<LessonExamQuestionEntity> onEditQuestion;

  final VoidCallback onSaveExamPressed;

  final VoidCallback onAddQuestionPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LessonExamTotalDegreesCard(totalDegrees: state.totalDegrees),

        verticalSpace(20),

        Expanded(
          child: LessonExamQuestionsList(
            state: state,
            onChoiceSelected: onChoiceSelected,
            onDeleteQuestion: onDeleteQuestion,
            onEditQuestion: onEditQuestion,
          ),
        ),

        verticalSpace(16),

        LessonExamsActions(
          primaryButtonText: 'حفظ التعديلات',
          secondaryButtonText: 'إضافة سؤال',
          isPrimaryLoading: state.isSavingAnswers,
          isPrimaryEnabled: state.canSaveAnswers,
          isSecondaryEnabled: !state.isActionInProgress,
          onPrimaryPressed: onSaveExamPressed,
          onSecondaryPressed: onAddQuestionPressed,
        ),
      ],
    );
  }
}
