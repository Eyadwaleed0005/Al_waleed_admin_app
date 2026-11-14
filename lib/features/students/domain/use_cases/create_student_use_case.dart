import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admin/features/students/domain/helper/date_validation_helper.dart';
import 'package:alwaleed_admin/features/students/domain/params/student_params.dart';
import 'package:alwaleed_admin/features/students/domain/repositories/student_auth_repository.dart';
import 'package:alwaleed_admin/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class CreateStudentUseCase {
  const CreateStudentUseCase({
    required StudentAuthRepository studentAuthRepository,
    required StudentsRepository studentsRepository,
  }) : _studentAuthRepository = studentAuthRepository,
       _studentsRepository = studentsRepository;

  final StudentAuthRepository _studentAuthRepository;
  final StudentsRepository _studentsRepository;

  Future<Either<AppErrorModel, StudentEntity>> call({
    required CreateStudentParams params,
  }) async {
    final normalizedEmail = params.email.trim().toLowerCase();

    final accountResult = await _studentAuthRepository.createStudentAccount(
      email: normalizedEmail,
      password: params.password,
    );

    return accountResult.fold<Future<Either<AppErrorModel, StudentEntity>>>(
      (error) async {
        return Left<AppErrorModel, StudentEntity>(error);
      },
      (studentId) async {
        final subscriptionEndAt = params.subscriptionEndAt;

        final isActive =
            subscriptionEndAt != null &&
            DateValidationHelper.isEndDateInFuture(endAt: subscriptionEndAt);

        final student = StudentEntity(
          studentId: studentId,
          gradeId: params.gradeId.trim(),
          name: params.name.trim(),
          email: normalizedEmail,
          phoneNumber: params.phoneNumber.trim(),
          subscriptionStartAt: params.subscriptionStartAt,
          subscriptionEndAt: subscriptionEndAt,
          isActive: isActive,
          isLoggedIn: false,
        );

        final studentResult = await _studentsRepository.createStudent(
          student: student,
        );

        return studentResult.fold<Future<Either<AppErrorModel, StudentEntity>>>(
          (error) async {
            await _studentAuthRepository.deleteStudentAccount(
              studentId: studentId,
            );

            return Left<AppErrorModel, StudentEntity>(error);
          },
          (_) async {
            return Right<AppErrorModel, StudentEntity>(student);
          },
        );
      },
    );
  }
}
