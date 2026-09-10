import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/result_student/domain/entities/student_exam_results_overview_entity.dart';
import 'package:alwaleed_admain/features/result_student/domain/repository/student_exam_results_repository.dart';
import 'package:dartz/dartz.dart';

class GetStudentExamResultsByStudentIdUseCase {
  final StudentExamResultsRepository studentExamResultsRepository;

  const GetStudentExamResultsByStudentIdUseCase({
    required this.studentExamResultsRepository,
  });

  Future<Either<AppErrorModel, StudentExamResultsOverviewEntity>> call({
    required String studentId,
  }) {
    return studentExamResultsRepository.getStudentExamResultsByStudentId(
      studentId: studentId,
    );
  }
}
