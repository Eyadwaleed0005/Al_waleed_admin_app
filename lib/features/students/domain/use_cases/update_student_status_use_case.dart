import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admin/features/students/domain/helper/date_validation_helper.dart';
import 'package:alwaleed_admin/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStudentStatusUseCase {
  const UpdateStudentStatusUseCase({
    required StudentsRepository studentsRepository,
  }) : _studentsRepository = studentsRepository;

  final StudentsRepository _studentsRepository;

  Future<Either<AppErrorModel, StudentEntity>> call({
    required StudentEntity student,
    required bool isActive,
  }) async {
    if (student.isActive == isActive) {
      return Right<AppErrorModel, StudentEntity>(student);
    }

    if (isActive) {
      final subscriptionEndAt = student.subscriptionEndAt;

      final hasValidSubscription =
          subscriptionEndAt != null &&
          DateValidationHelper.isEndDateInFuture(endAt: subscriptionEndAt);

      if (!hasValidSubscription) {
        return Left<AppErrorModel, StudentEntity>(
          DateValidationHelper.cannotActivateExpiredSubscriptionError(),
        );
      }
    }

    final updatedStudent = student.copyWith(isActive: isActive);

    final result = await _studentsRepository.updateStudent(
      student: updatedStudent,
    );

    return result.map((_) => updatedStudent);
  }
}
