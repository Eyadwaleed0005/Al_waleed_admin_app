import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateLessonUseCase {
  const UpdateLessonUseCase({
    required LessonsRepository repository,
  }) : _repository = repository;

  final LessonsRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required LessonEntity lesson,
    String? replacementPdfFilePath,
  }) {
    return _repository.updateLesson(
      lesson: lesson,
      replacementPdfFilePath: replacementPdfFilePath,
    );
  }
}