import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admin/features/students/domain/helper/date_validation_helper.dart';
import 'package:alwaleed_admin/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStudentSubscriptionUseCase {
  const UpdateStudentSubscriptionUseCase({
    required StudentsRepository studentsRepository,
  }) : _studentsRepository = studentsRepository;

  final StudentsRepository _studentsRepository;

  Future<Either<AppErrorModel, StudentEntity>> call({
    required StudentEntity student,
    required DateTime subscriptionStartAt,
    required DateTime subscriptionEndAt,
  }) async {
    final isValidDateRange = DateValidationHelper.isValidDateRange(
      startAt: subscriptionStartAt,
      endAt: subscriptionEndAt,
    );

    if (!isValidDateRange) {
      return Left<AppErrorModel, StudentEntity>(
        DateValidationHelper.invalidDateRangeError(),
      );
    }

    final isEndDateInFuture = DateValidationHelper.isEndDateInFuture(
      endAt: subscriptionEndAt,
    );

    if (!isEndDateInFuture) {
      return Left<AppErrorModel, StudentEntity>(
        DateValidationHelper.expiredEndDateError(),
      );
    }

    final updatedStudent = student.copyWith(
      subscriptionStartAt: subscriptionStartAt,
      subscriptionEndAt: subscriptionEndAt,
      isActive: true,
    );

    final result = await _studentsRepository.updateStudent(
      student: updatedStudent,
    );

    return result.map((_) => updatedStudent);
  }
}
