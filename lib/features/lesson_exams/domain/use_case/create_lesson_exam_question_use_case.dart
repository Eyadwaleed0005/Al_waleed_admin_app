import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/repositories/lesson_exam_repository.dart';
import 'package:dartz/dartz.dart';

class CreateLessonExamQuestionUseCase {
  const CreateLessonExamQuestionUseCase(this._repository);

  final LessonExamRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required String lessonId,
    required String questionText,
    required int degree,
    required List<String> choices,
    LessonExamQuestionImageFile? image,
  }) {
    final normalizedChoices = choices
        .map((choice) => choice.trim())
        .toList(growable: false);

    return _repository.createQuestion(
      lessonId: lessonId.trim(),
      questionText: questionText.trim(),
      degree: degree,
      choices: normalizedChoices,
      image: image,
    );
  }
}
