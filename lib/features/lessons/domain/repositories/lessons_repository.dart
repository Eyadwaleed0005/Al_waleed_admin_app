import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:dartz/dartz.dart';

abstract class LessonsRepository {
  Future<Either<AppErrorModel, List<LessonEntity>>> getLessons({
    String? gradeId,
    bool? isPublished,
  });

  Future<Either<AppErrorModel, LessonEntity>> getLessonById({
    required String lessonId,
  });

  Stream<Either<AppErrorModel, List<LessonEntity>>> streamLessons({
    String? gradeId,
    bool? isPublished,
  });

  Future<Either<AppErrorModel, Unit>> createLesson({
    required LessonEntity lesson,
    required String localPdfFilePath,
  });

  Future<Either<AppErrorModel, Unit>> updateLesson({
    required LessonEntity lesson,
    String? replacementPdfFilePath,
  });

  Future<Either<AppErrorModel, Unit>> deleteLesson({required String lessonId});
}
