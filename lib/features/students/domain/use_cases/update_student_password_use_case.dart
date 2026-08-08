import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/student_auth_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStudentPasswordUseCase {
  final StudentAuthRepository _studentAuthRepository;

  const UpdateStudentPasswordUseCase({
    required StudentAuthRepository studentAuthRepository,
  }) : _studentAuthRepository = studentAuthRepository;

  Future<Either<AppErrorModel, Unit>> call({
    required String studentId,
    required String newPassword,
  }) {
    return _studentAuthRepository.updateStudentPassword(
      studentId: studentId.trim(),
      newPassword: newPassword,
    );
  }
}