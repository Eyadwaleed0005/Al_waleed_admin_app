import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteLessonUseCase {
  const DeleteLessonUseCase({
    required LessonsRepository repository,
  }) : _repository = repository;

  final LessonsRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required String lessonId,
  }) {
    return _repository.deleteLesson(
      lessonId: lessonId,
    );
  }
}