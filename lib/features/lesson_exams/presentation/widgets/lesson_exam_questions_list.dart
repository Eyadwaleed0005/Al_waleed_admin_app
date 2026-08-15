import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/widgets/lesson_exam_question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef LessonExamChoiceSelected =
    void Function(LessonExamQuestionEntity question, int choiceIndex);

class LessonExamQuestionsList extends StatelessWidget {
  const LessonExamQuestionsList({
    super.key,
    required this.questions,
    required this.selectedCorrectChoiceIndexes,
    required this.onChoiceSelected,
    required this.onDeleteQuestion,
    required this.onEditQuestion,
    this.isActionInProgress = false,
    this.deletingQuestionId,
  });

  final List<LessonExamQuestionEntity> questions;

  final Map<String, int> selectedCorrectChoiceIndexes;

  final LessonExamChoiceSelected onChoiceSelected;

  final ValueChanged<LessonExamQuestionEntity> onDeleteQuestion;

  final ValueChanged<LessonExamQuestionEntity> onEditQuestion;

  final bool isActionInProgress;

  final String? deletingQuestionId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        final questionId = question.questionId;

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == questions.length - 1 ? 0 : 16.h,
          ),
          child: LessonExamQuestionCard(
            question: question,
            questionNumber: index + 1,
            selectedChoiceIndex: selectedCorrectChoiceIndexes[questionId],
            isEnabled: !isActionInProgress,
            isDeleting: deletingQuestionId == questionId,
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
