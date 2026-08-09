import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/student_auth_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteStudentUseCase {
  final StudentAuthRepository _studentAuthRepository;

  const DeleteStudentUseCase({
    required StudentAuthRepository studentAuthRepository,
  }) : _studentAuthRepository = studentAuthRepository;

  Future<Either<AppErrorModel, Unit>> call({
    required StudentEntity student,
  }) {
    return _studentAuthRepository.deleteStudentAccount(
      studentId: student.studentId,
    );
  }
}