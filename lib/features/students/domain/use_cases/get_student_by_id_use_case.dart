import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class GetStudentByIdUseCase {
  final StudentsRepository _studentsRepository;

  const GetStudentByIdUseCase({required StudentsRepository studentsRepository})
    : _studentsRepository = studentsRepository;

  Future<Either<AppErrorModel, StudentEntity>> call({
    required String studentId,
  }) {
    return _studentsRepository.getStudentById(studentId: studentId);
  }
}
