import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStudentProfileUseCase {
  final StudentsRepository _studentsRepository;

  const UpdateStudentProfileUseCase({
    required StudentsRepository studentsRepository,
  }) : _studentsRepository = studentsRepository;

  Future<Either<AppErrorModel, StudentEntity>> call({
    required StudentEntity student,
  }) async {
    final result = await _studentsRepository.updateStudent(
      student: student,
    );

    return result.map((_) => student);
  }
}