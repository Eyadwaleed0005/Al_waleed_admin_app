import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/student_auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../data_sources/auth/student_auth_remote_data_source.dart';

class StudentAuthRepositoryImpl implements StudentAuthRepository {
  final StudentAuthRemoteDataSource _remoteDataSource;

  const StudentAuthRepositoryImpl({
    required StudentAuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<AppErrorModel, String>> createStudentAccount({
    required String email,
    required String password,
  }) {
    return _execute<String>(() {
      return _remoteDataSource.createStudentAccount(
        email: email,
        password: password,
      );
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateStudentPassword({
    required String studentId,
    required String newPassword,
  }) {
    return _execute<Unit>(() async {
      await _remoteDataSource.updateStudentPassword(
        studentId: studentId,
        newPassword: newPassword,
      );

      return unit;
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateStudentEmail({
    required String studentId,
    required String newEmail,
  }) {
    return _execute<Unit>(() async {
      await _remoteDataSource.updateStudentEmail(
        studentId: studentId,
        newEmail: newEmail,
      );

      return unit;
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateStudentAccountStatus({
    required String studentId,
    required bool isActive,
  }) {
    return _execute<Unit>(() async {
      await _remoteDataSource.updateStudentAccountStatus(
        studentId: studentId,
        isActive: isActive,
      );

      return unit;
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> deleteStudentAccount({
    required String studentId,
  }) {
    return _execute<Unit>(() async {
      await _remoteDataSource.deleteStudentAccount(studentId: studentId);

      return unit;
    });
  }

  Future<Either<AppErrorModel, T>> _execute<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();

      return Right<AppErrorModel, T>(result);
    } catch (error) {
      return Left<AppErrorModel, T>(FirebaseErrorHandler.handle(error));
    }
  }
}
