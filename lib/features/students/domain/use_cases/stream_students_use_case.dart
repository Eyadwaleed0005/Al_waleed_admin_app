import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/helper/students_filter_helper.dart';
import 'package:alwaleed_admain/features/students/domain/params/student_params.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class StreamStudentsUseCase {
  final StudentsRepository _studentsRepository;

  const StreamStudentsUseCase({
    required StudentsRepository studentsRepository,
  }) : _studentsRepository = studentsRepository;

  Stream<Either<AppErrorModel, List<StudentEntity>>> call({
    required StudentsFilterParams params,
  }) {
    final normalizedGradeId = params.gradeId.trim();

    return _studentsRepository
        .streamStudents(
          gradeId: normalizedGradeId.isEmpty
              ? null
              : normalizedGradeId,
        )
        .map((result) {
          return result.map((students) {
            return StudentsFilterHelper.apply(
              students: students,
              params: params,
            );
          });
        });
  }
}