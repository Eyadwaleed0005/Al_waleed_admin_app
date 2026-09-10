import 'dart:async';

import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_result_entity.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_results_report_entity.dart';
import 'package:alwaleed_admin/features/exams/domain/use_case/get_exam_by_id_use_case.dart';
import 'package:alwaleed_admin/features/exams/domain/use_case/get_exam_results_use_case.dart';
import 'package:alwaleed_admin/features/exams/domain/use_case/stream_exam_results_use_case.dart';
import 'package:alwaleed_admin/features/exams/presentation/cubit/exam_results_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamResultsCubit extends Cubit<ExamResultsState> {
  ExamResultsCubit({
    required GetExamByIdUseCase getExamByIdUseCase,
    required GetExamResultsUseCase getExamResultsUseCase,
    required StreamExamResultsUseCase streamExamResultsUseCase,
  }) : _getExamByIdUseCase = getExamByIdUseCase,
       _getExamResultsUseCase = getExamResultsUseCase,
       _streamExamResultsUseCase = streamExamResultsUseCase,
       super(const ExamResultsInitial());

  final GetExamByIdUseCase _getExamByIdUseCase;
  final GetExamResultsUseCase _getExamResultsUseCase;
  final StreamExamResultsUseCase _streamExamResultsUseCase;

  StreamSubscription<Either<AppErrorModel, List<ExamResultEntity>>>?
  _resultsSubscription;

  String? _examId;
  ExamEntity? _exam;

  Future<void> loadExamResults({required String examId}) async {
    _examId = examId;

    emit(const ExamResultsLoading());

    await _resultsSubscription?.cancel();

    final examResult = await _getExamByIdUseCase(examId: examId);

    if (isClosed) {
      return;
    }

    await examResult.fold<Future<void>>(
      (error) async {
        emit(ExamResultsError(error: error));
      },
      (exam) async {
        _exam = exam;

        _startResultsStream(examId: examId);
      },
    );
  }

  void _startResultsStream({required String examId}) {
    _resultsSubscription = _streamExamResultsUseCase(
      examId: examId,
    ).listen(_handleResults);
  }

  Future<void> refreshExamResults() async {
    final examId = _examId;

    if (examId == null || _exam == null) {
      return;
    }

    final result = await _getExamResultsUseCase(examId: examId);

    if (isClosed) {
      return;
    }

    _handleResults(result);
  }

  Future<void> retry() async {
    final examId = _examId;

    if (examId == null) {
      return;
    }

    await loadExamResults(examId: examId);
  }

  void _handleResults(Either<AppErrorModel, List<ExamResultEntity>> result) {
    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(ExamResultsError(error: error));
      },
      (results) {
        final exam = _exam;

        if (exam == null) {
          return;
        }

        final report = ExamResultsReportEntity(
          exam: exam,
          results: List<ExamResultEntity>.unmodifiable(results),
        );

        if (report.isEmpty) {
          emit(ExamResultsEmpty(exam: exam));
          return;
        }

        emit(ExamResultsSuccess(report: report));
      },
    );
  }

  @override
  Future<void> close() async {
    await _resultsSubscription?.cancel();
    return super.close();
  }
}
