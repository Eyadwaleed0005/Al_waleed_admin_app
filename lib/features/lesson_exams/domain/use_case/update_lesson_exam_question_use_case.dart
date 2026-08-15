import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/repositories/lesson_exam_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateLessonExamQuestionUseCase {
  const UpdateLessonExamQuestionUseCase(
    this._repository,
  );

  final LessonExamRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required String lessonId,
    required String questionId,
    required String questionText,
    required int degree,
    required List<String> choices,
    LessonExamQuestionImageFile? newImage,
    bool removeCurrentImage = false,
  }) {
    final normalizedChoices = choices
        .map((choice) => choice.trim())
        .toList(growable: false);

    return _repository.updateQuestion(
      lessonId: lessonId.trim(),
      questionId: questionId.trim(),
      questionText: questionText.trim(),
      degree: degree,
      choices: normalizedChoices,
      newImage: newImage,
      removeCurrentImage: removeCurrentImage,
    );
  }
}