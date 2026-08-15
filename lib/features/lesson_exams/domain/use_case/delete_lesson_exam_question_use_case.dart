import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/repositories/lesson_exam_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteLessonExamQuestionUseCase {
  const DeleteLessonExamQuestionUseCase(this._repository);

  final LessonExamRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required String lessonId,
    required String questionId,
  }) {
    return _repository.deleteQuestion(
      lessonId: lessonId.trim(),
      questionId: questionId.trim(),
    );
  }
}
