import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_results_report_entity.dart';

abstract class ExamResultsState {
  const ExamResultsState();
}

class ExamResultsInitial extends ExamResultsState {
  const ExamResultsInitial();
}

class ExamResultsLoading extends ExamResultsState {
  const ExamResultsLoading();
}

class ExamResultsEmpty extends ExamResultsState {
  const ExamResultsEmpty({required this.exam});

  final ExamEntity exam;
}

class ExamResultsSuccess extends ExamResultsState {
  const ExamResultsSuccess({required this.report});

  final ExamResultsReportEntity report;
}

class ExamResultsError extends ExamResultsState {
  const ExamResultsError({required this.error});

  final AppErrorModel error;
}
