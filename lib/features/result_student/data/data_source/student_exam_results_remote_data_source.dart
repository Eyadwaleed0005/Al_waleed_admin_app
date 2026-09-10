import '../models/student_exam_results_overview_model.dart';

abstract class StudentExamResultsRemoteDataSource {
  Future<StudentExamResultsOverviewModel> getStudentExamResultsByStudentId({
    required String studentId,
  });
}
