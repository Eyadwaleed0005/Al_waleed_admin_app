import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';

sealed class AddLessonExamQuestionState {
  const AddLessonExamQuestionState();
}

final class AddLessonExamQuestionInitial
    extends AddLessonExamQuestionState {
  const AddLessonExamQuestionInitial();
}

final class AddLessonExamQuestionLoading
    extends AddLessonExamQuestionState {
  const AddLessonExamQuestionLoading();
}

final class AddLessonExamQuestionSuccess
    extends AddLessonExamQuestionState {
  const AddLessonExamQuestionSuccess();
}

final class AddLessonExamQuestionFailure
    extends AddLessonExamQuestionState {
  const AddLessonExamQuestionFailure({
    required this.error,
  });

  final AppErrorModel error;
}