import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:alwaleed_admain/features/exams/presentation/widgets/exam_questions_screen_widgets/exam_question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ExamQuestionChoiceSelected =
    void Function(
      ExamQuestionEntity question,
      int choiceIndex,
    );

class ExamQuestionsListView extends StatelessWidget {
  const ExamQuestionsListView({
    super.key,
    required this.questions,
    required this.selectedChoiceIndexes,
    required this.questionImages,
    required this.showActions,
    required this.onChoiceSelected,
    required this.onEditQuestion,
    required this.onDeleteQuestion,
    this.isEnabled = true,
    this.deletingQuestionId,
  });

  final List<ExamQuestionEntity> questions;
  final Map<String, int> selectedChoiceIndexes;
  final Map<String, ExamQuestionImageFile> questionImages;

  final ExamQuestionChoiceSelected onChoiceSelected;
  final ValueChanged<ExamQuestionEntity> onEditQuestion;
  final ValueChanged<ExamQuestionEntity> onDeleteQuestion;

  final bool showActions;
  final bool isEnabled;
  final String? deletingQuestionId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(
        questions.length,
        (int index) {
          final ExamQuestionEntity question =
              questions[index];

          final bool isLastQuestion =
              index == questions.length - 1;

          return Padding(
            key: ValueKey<String>(
              question.questionId,
            ),
            padding: EdgeInsets.only(
              bottom: isLastQuestion ? 0 : 16.h,
            ),
            child: ExamQuestionCard(
              question: question,
              questionNumber: index + 1,
              selectedChoiceIndex:
                  selectedChoiceIndexes[
                    question.questionId
                  ],
              localImage:
                  questionImages[question.questionId],
              showActions: showActions,
              isEnabled: isEnabled,
              isDeleting:
                  deletingQuestionId ==
                  question.questionId,
              onChoiceSelected: (int choiceIndex) {
                onChoiceSelected(
                  question,
                  choiceIndex,
                );
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
      ),
    );
  }
}