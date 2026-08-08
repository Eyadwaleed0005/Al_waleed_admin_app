import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/helper/students_filter_helper.dart';
import 'package:alwaleed_admain/features/students/domain/params/student_params.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class GetStudentsUseCase {
  final StudentsRepository _studentsRepository;

  const GetStudentsUseCase({required this._studentsRepository});

  Future<Either<AppErrorModel, List<StudentEntity>>> call({
    required StudentsFilterParams params,
  }) async {
    final normalizedGradeId = params.gradeId.trim();

    final result = await _studentsRepository.getStudents(
      gradeId: normalizedGradeId.isEmpty ? null : normalizedGradeId,
    );

    return result.map((students) {
      return StudentsFilterHelper.apply(students: students, params: params);
    });
  }
}
