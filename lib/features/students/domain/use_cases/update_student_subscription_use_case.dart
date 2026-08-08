import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/helper/date_validation_helper.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/student_auth_repository.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStudentSubscriptionUseCase {
  final StudentAuthRepository _studentAuthRepository;
  final StudentsRepository _studentsRepository;

  const UpdateStudentSubscriptionUseCase({
    required StudentAuthRepository studentAuthRepository,
    required StudentsRepository studentsRepository,
  })  : _studentAuthRepository = studentAuthRepository,
        _studentsRepository = studentsRepository;

  Future<Either<AppErrorModel, StudentEntity>> call({
    required StudentEntity student,
    required DateTime subscriptionStartAt,
    required DateTime subscriptionEndAt,
  }) async {
    final isValidDateRange =
        DateValidationHelper.isValidDateRange(
      startAt: subscriptionStartAt,
      endAt: subscriptionEndAt,
    );

    if (!isValidDateRange) {
      return Left<AppErrorModel, StudentEntity>(
        DateValidationHelper.invalidDateRangeError(),
      );
    }

    final isEndDateInFuture =
        DateValidationHelper.isEndDateInFuture(
      endAt: subscriptionEndAt,
    );

    if (!isEndDateInFuture) {
      return Left<AppErrorModel, StudentEntity>(
        DateValidationHelper.expiredEndDateError(),
      );
    }

    // الاشتراك الجديد أو التجديد يعيدان تفعيل حساب الطالب.
    final authResult =
        await _studentAuthRepository.updateStudentAccountStatus(
      studentId: student.studentId,
      isActive: true,
    );

    return authResult.fold<
        Future<Either<AppErrorModel, StudentEntity>>>(
      (error) async {
        return Left<AppErrorModel, StudentEntity>(error);
      },
      (_) async {
        final updatedStudent = student.copyWith(
          subscriptionStartAt: subscriptionStartAt,
          subscriptionEndAt: subscriptionEndAt,
          isActive: true,
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