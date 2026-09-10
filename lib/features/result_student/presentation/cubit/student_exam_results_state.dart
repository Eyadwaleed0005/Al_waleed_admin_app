
import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/result_student/domain/entities/student_exam_results_overview_entity.dart';

abstract class StudentExamResultsState {
  const StudentExamResultsState();
}

class StudentExamResultsInitial extends StudentExamResultsState {
  const StudentExamResultsInitial();
}

class StudentExamResultsLoading extends StudentExamResultsState {
  const StudentExamResultsLoading();
}

class StudentExamResultsEmpty extends StudentExamResultsState {
  final StudentExamResultsOverviewEntity studentExamResultsOverview;

  const StudentExamResultsEmpty({
    required this.studentExamResultsOverview,
  });
}

class StudentExamResultsSuccess extends StudentExamResultsState {
  final StudentExamResultsOverviewEntity studentExamResultsOverview;

  const StudentExamResultsSuccess({
    required this.studentExamResultsOverview,
  });
}

class StudentExamResultsError extends StudentExamResultsState {
  final AppErrorModel appErrorModel;

  const StudentExamResultsError({
    required this.appErrorModel,
  });
}