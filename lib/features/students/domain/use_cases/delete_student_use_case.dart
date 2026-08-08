import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/student_auth_repository.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteStudentUseCase {
  final StudentAuthRepository _studentAuthRepository;
  final StudentsRepository _studentsRepository;

  const DeleteStudentUseCase({
    required StudentAuthRepository studentAuthRepository,
    required StudentsRepository studentsRepository,
  }) : _studentAuthRepository = studentAuthRepository,
       _studentsRepository = studentsRepository;

  Future<Either<AppErrorModel, Unit>> call({
    required StudentEntity student,
  }) async {
    final firestoreResult = await _studentsRepository.deleteStudent(
      studentId: student.studentId,
    );

    return firestoreResult.fold<Future<Either<AppErrorModel, Unit>>>(
      (error) async {
        return Left<AppErrorModel, Unit>(error);
      },
      (_) async {
        final authResult = await _studentAuthRepository.deleteStudentAccount(
          studentId: student.studentId,
        );

        return authResult.fold<Future<Either<AppErrorModel, Unit>>>(
          (error) async {
            if (error.type == AppErrorType.notFound) {
              return Right<AppErrorModel, Unit>(unit);
            }

            await _studentsRepository.createStudent(student: student);

            return Left<AppErrorModel, Unit>(error);
          },
          (_) async {
            return Right<AppErrorModel, Unit>(unit);
          },
        );
      },
    );
  }
}
