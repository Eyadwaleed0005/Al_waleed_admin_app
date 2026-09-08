import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_draft_entity.dart';

sealed class EditExamQuestionState {
  const EditExamQuestionState();
}

final class EditExamQuestionInitial
    extends EditExamQuestionState {
  const EditExamQuestionInitial();
}

final class EditExamQuestionLoading
    extends EditExamQuestionState {
  const EditExamQuestionLoading();
}

final class EditExamQuestionSuccess
    extends EditExamQuestionState {
  const EditExamQuestionSuccess({
    required this.questionDraft,
  });

  final ExamQuestionDraftEntity questionDraft;
}

final class EditExamQuestionFailure
    extends EditExamQuestionState {
  const EditExamQuestionFailure({
    required this.error,
  });

  final AppErrorModel error;
}