import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_draft_entity.dart';

sealed class AddExamQuestionState {
  const AddExamQuestionState();
}

final class AddExamQuestionInitial
    extends AddExamQuestionState {
  const AddExamQuestionInitial();
}

final class AddExamQuestionLoading
    extends AddExamQuestionState {
  const AddExamQuestionLoading();
}

final class AddExamQuestionSuccess
    extends AddExamQuestionState {
  const AddExamQuestionSuccess({
    required this.questionDraft,
  });

  final ExamQuestionDraftEntity questionDraft;
}