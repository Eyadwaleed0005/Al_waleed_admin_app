import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/stream_lessons_use_case.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/view_lessons_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewLessonsCubit extends Cubit<ViewLessonsState> {
  ViewLessonsCubit({
    required StreamGradesUseCase streamGradesUseCase,
    required StreamLessonsUseCase streamLessonsUseCase,
  }) : _streamGradesUseCase = streamGradesUseCase,
       _streamLessonsUseCase = streamLessonsUseCase,
       super(const ViewLessonsInitial());

  final StreamGradesUseCase _streamGradesUseCase;
  final StreamLessonsUseCase _streamLessonsUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  StreamSubscription<Either<AppErrorModel, List<LessonEntity>>>?
  _lessonsSubscription;

  List<GradeEntity> _grades = const [];
  List<LessonEntity> _lessons = const [];

  bool _hasLoadedGrades = false;
  bool _hasLoadedLessons = false;
  bool _hasFailure = false;
  bool _isInitializing = false;

  Future<void> initialize() async {
    if (_isInitializing) {
      return;
    }

    _isInitializing = true;

    try {
      await _cancelSubscriptions();

      _resetData();

      if (isClosed) {
        return;
      }

      emit(const ViewLessonsLoading());

      _watchGrades();
      _watchLessons();
    } finally {
      _isInitializing = false;
    }
  }

  void searchLessons(String value) {
    final currentState = state;

    if (currentState is! ViewLessonsDataSuccess) {
      return;
    }

    emit(currentState.copyWith(searchQuery: value));
  }

  void selectGrade(String gradeId) {
    final currentState = state;

    if (currentState is! ViewLessonsDataSuccess) {
      return;
    }

    emit(currentState.copyWith(selectedGradeId: gradeId.trim()));
  }

  void selectPublicationFilter(LessonPublicationFilter filter) {
    final currentState = state;

    if (currentState is! ViewLessonsDataSuccess) {
      return;
    }

    emit(currentState.copyWith(selectedPublicationFilter: filter));
  }

  Future<void> retry() {
    return initialize();
  }

  void _watchGrades() {
    _gradesSubscription = _streamGradesUseCase(
      activeOnly: true,
    ).listen(_onGradesResult);
  }

  void _watchLessons() {
    _lessonsSubscription = _streamLessonsUseCase().listen(_onLessonsResult);
  }

  void _onGradesResult(Either<AppErrorModel, List<GradeEntity>> result) {
    if (isClosed) {
      return;
    }

    result.fold(_emitFailure, (grades) {
      _grades = List<GradeEntity>.unmodifiable(grades);

      _hasLoadedGrades = true;

      _emitDataSuccessIfReady();
    });
  }

  void _onLessonsResult(Either<AppErrorModel, List<LessonEntity>> result) {
    if (isClosed) {
      return;
    }

    result.fold(_emitFailure, (lessons) {
      _lessons = List<LessonEntity>.unmodifiable(lessons);

      _hasLoadedLessons = true;

      _emitDataSuccessIfReady();
    });
  }

  void _emitDataSuccessIfReady() {
    if (isClosed || _hasFailure || !_hasLoadedGrades || !_hasLoadedLessons) {
      return;
    }

    final currentState = state;

    final searchQuery = currentState is ViewLessonsDataSuccess
        ? currentState.searchQuery
        : '';

    final publicationFilter = currentState is ViewLessonsDataSuccess
        ? currentState.selectedPublicationFilter
        : LessonPublicationFilter.all;

    var selectedGradeId = currentState is ViewLessonsDataSuccess
        ? currentState.selectedGradeId
        : '';

    final selectedGradeStillExists =
        selectedGradeId.isEmpty ||
        _grades.any((grade) => grade.gradeId == selectedGradeId);

    if (!selectedGradeStillExists) {
      selectedGradeId = '';
    }

    emit(
      ViewLessonsDataSuccess(
        grades: _grades,
        lessons: _lessons,
        searchQuery: searchQuery,
        selectedGradeId: selectedGradeId,
        selectedPublicationFilter: publicationFilter,
      ),
    );
  }

  void _emitFailure(AppErrorModel error) {
    if (isClosed || _hasFailure) {
      return;
    }

    _hasFailure = true;

    emit(ViewLessonsFailure(error: error));
  }

  void _resetData() {
    _grades = const [];
    _lessons = const [];

    _hasLoadedGrades = false;
    _hasLoadedLessons = false;
    _hasFailure = false;
  }

  Future<void> _cancelSubscriptions() async {
    await _gradesSubscription?.cancel();
    await _lessonsSubscription?.cancel();

    _gradesSubscription = null;
    _lessonsSubscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelSubscriptions();

    return super.close();
  }
}
