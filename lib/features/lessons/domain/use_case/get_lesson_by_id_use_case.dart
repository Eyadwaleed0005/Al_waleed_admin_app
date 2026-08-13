import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class GetLessonByIdUseCase {
  const GetLessonByIdUseCase({
    required LessonsRepository repository,
  }) : _repository = repository;

  final LessonsRepository _repository;

  Future<Either<AppErrorModel, LessonEntity>> call({
    required String lessonId,
  }) {
    return _repository.getLessonById(
      lessonId: lessonId,
    );
  }
}