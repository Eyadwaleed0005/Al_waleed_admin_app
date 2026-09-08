import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/stream_exams_use_case.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/view_exams_state.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewExamsCubit extends Cubit<ViewExamsState> {
  ViewExamsCubit({
    required StreamExamsUseCase streamExamsUseCase,
    required StreamGradesUseCase streamGradesUseCase,
  }) : _streamExamsUseCase = streamExamsUseCase,
       _streamGradesUseCase = streamGradesUseCase,
       super(const ViewExamsLoading());

  final StreamExamsUseCase _streamExamsUseCase;
  final StreamGradesUseCase _streamGradesUseCase;

  StreamSubscription<Either<AppErrorModel, List<ExamEntity>>>?
  _examsSubscription;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  List<ExamEntity> _allExams = const [];
  List<GradeEntity> _grades = const [];

  AppErrorModel? _examsError;
  AppErrorModel? _gradesError;

  bool _examsLoaded = false;
  bool _gradesLoaded = false;

  String _searchQuery = '';
  String _selectedGradeId = '';
  ExamStatus? _selectedStatus;

  String get searchQuery => _searchQuery;

  String get selectedGradeId => _selectedGradeId;

  ExamStatus? get selectedStatus => _selectedStatus;

  Future<void> loadData() async {
    await Future.wait([
      _examsSubscription?.cancel() ?? Future<void>.value(),
      _gradesSubscription?.cancel() ?? Future<void>.value(),
    ]);

    _examsLoaded = false;
    _gradesLoaded = false;

    _examsError = null;
    _gradesError = null;

    emit(const ViewExamsLoading());

    _examsSubscription = _streamExamsUseCase().listen(_handleExamsResult);

    _gradesSubscription = _streamGradesUseCase().listen(_handleGradesResult);
  }

  void searchExams(String value) {
    _searchQuery = value.trim().toLowerCase();

    _emitCurrentState();
  }

  void selectGrade(String gradeId) {
    _selectedGradeId = gradeId.trim();

    _emitCurrentState();
  }

  void selectStatus(ExamStatus? status) {
    _selectedStatus = status;

    _emitCurrentState();
  }

  Future<void> retry() {
    return loadData();
  }

  void _handleExamsResult(Either<AppErrorModel, List<ExamEntity>> result) {
    result.fold(
      (error) {
        _examsError = error;
        _examsLoaded = true;

        _emitCurrentState();
      },
      (exams) {
        _examsError = null;
        _examsLoaded = true;

        _allExams = List<ExamEntity>.unmodifiable(exams);

        _emitCurrentState();
      },
    );
  }

  void _handleGradesResult(Either<AppErrorModel, List<GradeEntity>> result) {
    result.fold(
      (error) {
        _gradesError = error;
        _gradesLoaded = true;

        _emitCurrentState();
      },
      (grades) {
        _gradesError = null;
        _gradesLoaded = true;

        _grades = List<GradeEntity>.unmodifiable(grades);

        _emitCurrentState();
      },
    );
  }

  void _emitCurrentState() {
    final AppErrorModel? error = _examsError ?? _gradesError;

    if (error != null) {
      emit(ViewExamsError(error: error));
      return;
    }

    if (!_examsLoaded || !_gradesLoaded) {
      return;
    }

    if (_allExams.isEmpty) {
      emit(ViewExamsEmpty(grades: _grades));
      return;
    }

    final List<ExamEntity> filteredExams = _allExams
        .where((exam) {
          final bool matchesSearch =
              _searchQuery.isEmpty ||
              exam.examName.toLowerCase().contains(_searchQuery);

          final bool matchesGrade =
              _selectedGradeId.isEmpty || exam.gradeId == _selectedGradeId;

          final bool matchesStatus =
              _selectedStatus == null || exam.status == _selectedStatus;

          return matchesSearch && matchesGrade && matchesStatus;
        })
        .toList(growable: false);

    emit(
      ViewExamsSuccess(
        exams: List<ExamEntity>.unmodifiable(filteredExams),
        grades: _grades,
      ),
    );
  }

  @override
  Future<void> close() async {
    await Future.wait([
      _examsSubscription?.cancel() ?? Future<void>.value(),
      _gradesSubscription?.cancel() ?? Future<void>.value(),
    ]);

    return super.close();
  }
}
