import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class CreateLessonUseCase {
  const CreateLessonUseCase({
    required LessonsRepository repository,
  }) : _repository = repository;

  final LessonsRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required LessonEntity lesson,
    required String localPdfFilePath,
  }) {
    return _repository.createLesson(
      lesson: lesson,
      localPdfFilePath: localPdfFilePath,
    );
  }
}