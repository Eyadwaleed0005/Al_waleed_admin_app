import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';

sealed class EditLessonExamQuestionState {
  const EditLessonExamQuestionState();
}

final class EditLessonExamQuestionInitial
    extends EditLessonExamQuestionState {
  const EditLessonExamQuestionInitial();
}

final class EditLessonExamQuestionLoading
    extends EditLessonExamQuestionState {
  const EditLessonExamQuestionLoading();
}

final class EditLessonExamQuestionSuccess
    extends EditLessonExamQuestionState {
  const EditLessonExamQuestionSuccess();
}

final class EditLessonExamQuestionFailure
    extends EditLessonExamQuestionState {
  const EditLessonExamQuestionFailure({
    required this.error,
  });

  final AppErrorModel error;
}