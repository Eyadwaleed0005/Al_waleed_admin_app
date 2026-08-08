import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/student_auth_repository.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStudentEmailUseCase {
  final StudentAuthRepository _studentAuthRepository;
  final StudentsRepository _studentsRepository;

  const UpdateStudentEmailUseCase({
    required StudentAuthRepository studentAuthRepository,
    required StudentsRepository studentsRepository,
  })  : _studentAuthRepository = studentAuthRepository,
        _studentsRepository = studentsRepository;

  Future<Either<AppErrorModel, StudentEntity>> call({
    required StudentEntity student,
    required String newEmail,
  }) async {
    final normalizedEmail = newEmail.trim().toLowerCase();

    if (normalizedEmail == student.email) {
      return Right<AppErrorModel, StudentEntity>(student);
    }

    final authResult =
        await _studentAuthRepository.updateStudentEmail(
      studentId: student.studentId,
      newEmail: normalizedEmail,
    );

    return authResult.fold<
        Future<Either<AppErrorModel, StudentEntity>>>(
      (error) async {
        return Left<AppErrorModel, StudentEntity>(error);
      },
      (_) async {
        final updatedStudent = student.copyWith(
          email: normalizedEmail,
        );

        final firestoreResult =
            await _studentsRepository.updateStudent(
          student: updatedStudent,
        );

        return firestoreResult.fold<
            Future<Either<AppErrorModel, StudentEntity>>>(
          (error) async {
            await _studentAuthRepository.updateStudentEmail(
              studentId: student.studentId,
              newEmail: student.email,
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