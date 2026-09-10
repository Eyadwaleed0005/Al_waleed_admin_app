import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/result_student/domain/entities/student_exam_results_overview_entity.dart';
import 'package:dartz/dartz.dart';


abstract class StudentExamResultsRepository {
  Future<Either<AppErrorModel, StudentExamResultsOverviewEntity>>
  getStudentExamResultsByStudentId({required String studentId});
}
