import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/lesson_exams_state.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exam_question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef LessonExamChoiceSelected =
    void Function(LessonExamQuestionEntity question, int choiceIndex);

class LessonExamQuestionsList extends StatelessWidget {
  const LessonExamQuestionsList({
    super.key,
    required this.state,
    required this.onChoiceSelected,
    required this.onDeleteQuestion,
    required this.onEditQuestion,
  });

  final LessonExamsState state;

  final LessonExamChoiceSelected onChoiceSelected;

  final ValueChanged<LessonExamQuestionEntity> onDeleteQuestion;

  final ValueChanged<LessonExamQuestionEntity> onEditQuestion;

  @override
  Widget build(BuildContext context) {
    final questions = state.exam.questions;

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 20.h),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == questions.length - 1 ? 0 : 16.h,
          ),
          child: LessonExamQuestionCard(
            question: question,
            questionNumber: index + 1,

            selectedChoiceIndex: state.selectedChoiceIndexFor(
              question.questionId,
            ),

            isEnabled: !state.isActionInProgress,

            isDeleting: state.isQuestionDeleting(question.questionId),

            onChoiceSelected: (choiceIndex) {
              onChoiceSelected(question, choiceIndex);
            },

            onEditPressed: () {
              onEditQuestion(question);
            },

            onDeletePressed: () {
              onDeleteQuestion(question);
            },
          ),
        );
      },
    );
  }
}
