import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/helper/date_validation_helper.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/student_auth_repository.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStudentStatusUseCase {
  final StudentAuthRepository _studentAuthRepository;
  final StudentsRepository _studentsRepository;

  const UpdateStudentStatusUseCase({
    required StudentAuthRepository studentAuthRepository,
    required StudentsRepository studentsRepository,
  })  : _studentAuthRepository = studentAuthRepository,
        _studentsRepository = studentsRepository;

  Future<Either<AppErrorModel, StudentEntity>> call({
    required StudentEntity student,
    required bool isActive,
  }) async {
    if (student.isActive == isActive) {
      return Right<AppErrorModel, StudentEntity>(student);
    }

    if (isActive) {
      final hasValidSubscription =
          DateValidationHelper.isEndDateInFuture(
        endAt: student.subscriptionEndAt,
      );

      if (!hasValidSubscription) {
        return Left<AppErrorModel, StudentEntity>(
          DateValidationHelper
              .cannotActivateExpiredSubscriptionError(),
        );
      }
    }

    final authResult =
        await _studentAuthRepository.updateStudentAccountStatus(
      studentId: student.studentId,
      isActive: isActive,
    );

    return authResult.fold<
        Future<Either<AppErrorModel, StudentEntity>>>(
      (error) async {
        return Left<AppErrorModel, StudentEntity>(error);
      },
      (_) async {
        final updatedStudent = student.copyWith(
          isActive: isActive,
        );

        final firestoreResult =
            await _studentsRepository.updateStudent(
          student: updatedStudent,
        );

        return firestoreResult.fold<
            Future<Either<AppErrorModel, StudentEntity>>>(
          (error) async {
            await _studentAuthRepository
                .updateStudentAccountStatus(
              studentId: student.studentId,
              isActive: student.isActive,
            );

            return Left<AppErrorModel, StudentEntity>(error);
          },
          (_) async {
            return Right<AppErrorModel, StudentEntity>(
              updatedStudent,
            );
          },
        );
      },
    );
  }
}