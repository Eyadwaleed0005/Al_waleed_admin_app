import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
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
  }) async {
    try {
      final studentId = await _remoteDataSource.createStudentAccount(
        email: email,
        password: password,
      );

      return Right(studentId);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateStudentPassword({
    required String studentId,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.updateStudentPassword(
        studentId: studentId,
        newPassword: newPassword,
      );

      return Right(unit);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateStudentEmail({
    required String studentId,
    required String newEmail,
  }) async {
    try {
      await _remoteDataSource.updateStudentEmail(
        studentId: studentId,
        newEmail: newEmail,
      );

      return Right(unit);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateStudentAccountStatus({
    required String studentId,
    required bool isActive,
  }) async {
    try {
      await _remoteDataSource.updateStudentAccountStatus(
        studentId: studentId,
        isActive: isActive,
      );

      return Right(unit);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> deleteStudentAccount({
    required String studentId,
  }) async {
    try {
      await _remoteDataSource.deleteStudentAccount(
        studentId: studentId,
      );

      return Right(unit);
    } on FirebaseRemoteException catch (error) {
      return Left(error.errorModel);
    }
  }
}