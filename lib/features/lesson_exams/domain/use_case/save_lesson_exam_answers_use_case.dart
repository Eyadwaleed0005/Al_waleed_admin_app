import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/repositories/lesson_exam_repository.dart';
import 'package:dartz/dartz.dart';

class SaveLessonExamAnswersUseCase {
  const SaveLessonExamAnswersUseCase(this._repository);

  final LessonExamRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required String lessonId,
    required Map<String, int> correctChoiceIndexes,
  }) {
    final normalizedAnswers = Map<String, int>.unmodifiable(
      correctChoiceIndexes.map(
        (questionId, choiceIndex) {
          return MapEntry(
            questionId.trim(),
            choiceIndex,
          );
        },
      ),
    );

    return _repository.saveCorrectAnswers(
      lessonId: lessonId.trim(),
      correctChoiceIndexes: normalizedAnswers,
    );
  }
}