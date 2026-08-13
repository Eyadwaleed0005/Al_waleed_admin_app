import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/features/lessons/data/data_sources/lessons_remote_data_source.dart';
import 'package:alwaleed_admain/features/lessons/data/models/lesson_model.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:dartz/dartz.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  const LessonsRepositoryImpl({
    required LessonsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final LessonsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppErrorModel, List<LessonEntity>>> getLessons({
    String? gradeId,
    bool? isPublished,
  }) {
    return _execute<List<LessonEntity>>(() async {
      final lessons = await _remoteDataSource.getLessons(
        gradeId: gradeId,
        isPublished: isPublished,
      );

      return List<LessonEntity>.unmodifiable(lessons);
    });
  }

  @override
  Future<Either<AppErrorModel, LessonEntity>> getLessonById({
    required String lessonId,
  }) {
    return _execute<LessonEntity>(() {
      return _remoteDataSource.getLessonById(lessonId: lessonId);
    });
  }

  @override
  Stream<Either<AppErrorModel, List<LessonEntity>>> streamLessons({
    String? gradeId,
    bool? isPublished,
  }) {
    return _executeStream<List<LessonEntity>>(() {
      return _remoteDataSource
          .streamLessons(gradeId: gradeId, isPublished: isPublished)
          .map<List<LessonEntity>>((lessons) {
            return List<LessonEntity>.unmodifiable(lessons);
          });
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> createLesson({
    required LessonEntity lesson,
    required String localPdfFilePath,
  }) {
    return _execute<Unit>(() async {
      final lessonModel = LessonModel.fromEntity(lesson);

      await _remoteDataSource.createLesson(
        lesson: lessonModel,
        localPdfFilePath: localPdfFilePath,
      );

      return unit;
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateLesson({
    required LessonEntity lesson,
    String? replacementPdfFilePath,
  }) {
    return _execute<Unit>(() async {
      final lessonModel = LessonModel.fromEntity(lesson);

      await _remoteDataSource.updateLesson(
        lesson: lessonModel,
        replacementPdfFilePath: replacementPdfFilePath,
      );

      return unit;
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> deleteLesson({required String lessonId}) {
    return _execute<Unit>(() async {
      await _remoteDataSource.deleteLesson(lessonId: lessonId);

      return unit;
    });
  }

  Future<Either<AppErrorModel, T>> _execute<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();

      return Right<AppErrorModel, T>(result);
    } on FirebaseRemoteException catch (error) {
      return Left<AppErrorModel, T>(error.errorModel);
    }
  }

  Stream<Either<AppErrorModel, T>> _executeStream<T>(
    Stream<T> Function() operation,
  ) async* {
    try {
      await for (final result in operation()) {
        yield Right<AppErrorModel, T>(result);
      }
    } on FirebaseRemoteException catch (error) {
      yield Left<AppErrorModel, T>(error.errorModel);
    }
  }
}
