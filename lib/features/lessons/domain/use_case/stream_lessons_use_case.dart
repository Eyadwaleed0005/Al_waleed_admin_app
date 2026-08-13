import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class StreamLessonsUseCase {
  const StreamLessonsUseCase({
    required LessonsRepository repository,
  }) : _repository = repository;

  final LessonsRepository _repository;

  Stream<Either<AppErrorModel, List<LessonEntity>>> call({
    String? gradeId,
    bool? isPublished,
  }) {
    return _repository.streamLessons(
      gradeId: gradeId,
      isPublished: isPublished,
    );
  }
}