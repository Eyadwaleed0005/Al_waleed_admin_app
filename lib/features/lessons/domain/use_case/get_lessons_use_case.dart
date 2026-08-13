import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class GetLessonsUseCase {
  const GetLessonsUseCase({
    required LessonsRepository repository,
  }) : _repository = repository;

  final LessonsRepository _repository;

  Future<Either<AppErrorModel, List<LessonEntity>>> call({
    String? gradeId,
    bool? isPublished,
  }) {
    return _repository.getLessons(
      gradeId: gradeId,
      isPublished: isPublished,
    );
  }
}