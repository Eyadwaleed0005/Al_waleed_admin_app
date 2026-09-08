import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/add_exam_question_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExamQuestionCubit
    extends Cubit<AddExamQuestionState> {
  AddExamQuestionCubit()
      : super(const AddExamQuestionInitial());

  void addQuestion({
    required String questionText,
    required int questionDegree,
    required List<String> choices,
    ExamQuestionImageFile? image,
  }) {
    if (state is AddExamQuestionLoading) {
      return;
    }

    final String normalizedQuestionText =
        questionText.trim();

    final List<String> normalizedChoices = choices
        .map((String choice) => choice.trim())
        .toList(growable: false);

    final bool hasInvalidData =
        normalizedQuestionText.isEmpty ||
        questionDegree <= 0 ||
        normalizedChoices.length != 4 ||
        normalizedChoices.any(
          (String choice) => choice.isEmpty,
        );

    if (hasInvalidData) {
      return;
    }

    emit(const AddExamQuestionLoading());

    final String temporaryQuestionId =
        'draft-question-'
        '${DateTime.now().microsecondsSinceEpoch}';

    final ExamQuestionEntity question =
        ExamQuestionEntity(
      questionId: temporaryQuestionId,
      examId: '',
      questionText: normalizedQuestionText,
      degree: questionDegree,
      choices: List<String>.unmodifiable(
        normalizedChoices,
      ),
    );

    final ExamQuestionDraftEntity questionDraft =
        ExamQuestionDraftEntity(
      question: question,
      image: image,
    );

    emit(
      AddExamQuestionSuccess(
        questionDraft: questionDraft,
      ),
    );
  }
}