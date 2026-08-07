import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudentAuthRepository {
  Future<Either<AppErrorModel, String>> createStudentAccount({
    required String email,
    required String password,
  });

  Future<Either<AppErrorModel, Unit>> updateStudentPassword({
    required String studentId,
    required String newPassword,
  });

  Future<Either<AppErrorModel, Unit>> updateStudentEmail({
    required String studentId,
    required String newEmail,
  });

  Future<Either<AppErrorModel, Unit>> updateStudentAccountStatus({
    required String studentId,
    required bool isActive,
  });

  Future<Either<AppErrorModel, Unit>> deleteStudentAccount({
    required String studentId,
  });
}