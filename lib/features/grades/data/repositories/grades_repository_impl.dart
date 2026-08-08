import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/features/grades/data/data_sources/grades_remote_data_source.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/repositories/grades_repository.dart';
import 'package:dartz/dartz.dart';

class GradesRepositoryImpl
    implements GradesRepository {
  final GradesRemoteDataSource
      _remoteDataSource;

  const GradesRepositoryImpl({
    required GradesRemoteDataSource
        remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<
      AppErrorModel,
      List<GradeEntity>>> getGrades({
    bool activeOnly = true,
  }) async {
    try {
      final grades =
          await _remoteDataSource.getGrades(
        activeOnly: activeOnly,
      );

      return Right(
        List<GradeEntity>.from(grades),
      );
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Stream<Either<
      AppErrorModel,
      List<GradeEntity>>> streamGrades({
    bool activeOnly = true,
  }) async* {
    try {
      await for (final grades
          in _remoteDataSource.streamGrades(
        activeOnly: activeOnly,
      )) {
        yield Right(
          List<GradeEntity>.from(grades),
        );
      }
    } on FirebaseRemoteException catch (error) {
      yield Left(error.errorModel);
    }
  }
}