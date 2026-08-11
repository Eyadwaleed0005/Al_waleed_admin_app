import 'dart:async';
import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/view_notes_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewNotesCubit extends Cubit<ViewNotesState> {
  ViewNotesCubit({
    required StreamGradesUseCase streamGradesUseCase,
    required StreamStudyNotesUseCase streamStudyNotesUseCase,
  }) : _streamGradesUseCase = streamGradesUseCase,
       _streamStudyNotesUseCase = streamStudyNotesUseCase,
       super(const ViewNotesInitial());

  final StreamGradesUseCase _streamGradesUseCase;

  final StreamStudyNotesUseCase _streamStudyNotesUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  StreamSubscription<Either<AppErrorModel, List<StudyNoteEntity>>>?
  _notesSubscription;

  List<GradeEntity> _grades = const [];
  List<StudyNoteEntity> _notes = const [];

  bool _hasLoadedGrades = false;
  bool _hasLoadedNotes = false;
  bool _hasFailure = false;
  bool _isInitializing = false;

  Future<void> initialize() async {
    if (_isInitializing) return;

    _isInitializing = true;

    try {
      await _cancelSubscriptions();

      _resetData();

      if (isClosed) return;

      emit(const ViewNotesLoading());

      _watchGrades();
      _watchStudyNotes();
    } finally {
      _isInitializing = false;
    }
  }

  void searchNotes(String value) {
    final currentState = state;

    if (currentState is! ViewNotesDataSuccess) {
      return;
    }

    emit(currentState.copyWith(searchQuery: value));
  }

  void selectGrade(String gradeId) {
    final currentState = state;

    if (currentState is! ViewNotesDataSuccess) {
      return;
    }

    emit(currentState.copyWith(selectedGradeId: gradeId.trim()));
  }

  void selectPublicationFilter(NotePublicationFilter filter) {
    final currentState = state;

    if (currentState is! ViewNotesDataSuccess) {
      return;
    }

    emit(currentState.copyWith(selectedPublicationFilter: filter));
  }

  Future<void> retry() async {
    await initialize();
  }

  void _watchGrades() {
    _gradesSubscription = _streamGradesUseCase(
      activeOnly: true,
    ).listen(_onGradesResult);
  }

  void _watchStudyNotes() {
    _notesSubscription = _streamStudyNotesUseCase().listen(_onStudyNotesResult);
  }

  void _onGradesResult(Either<AppErrorModel, List<GradeEntity>> result) {
    if (isClosed) return;

    result.fold(_emitFailure, (grades) {
      _grades = List<GradeEntity>.unmodifiable(grades);

      _hasLoadedGrades = true;

      _emitDataSuccessIfReady();
    });
  }

  void _onStudyNotesResult(
    Either<AppErrorModel, List<StudyNoteEntity>> result,
  ) {
    if (isClosed) return;

    result.fold(_emitFailure, (notes) {
      _notes = List<StudyNoteEntity>.unmodifiable(notes);

      _hasLoadedNotes = true;

      _emitDataSuccessIfReady();
    });
  }

  void _emitDataSuccessIfReady() {
    if (isClosed || _hasFailure || !_hasLoadedGrades || !_hasLoadedNotes) {
      return;
    }

    final currentState = state;

    final searchQuery = currentState is ViewNotesDataSuccess
        ? currentState.searchQuery
        : '';

    final publicationFilter = currentState is ViewNotesDataSuccess
        ? currentState.selectedPublicationFilter
        : NotePublicationFilter.all;

    String selectedGradeId = currentState is ViewNotesDataSuccess
        ? currentState.selectedGradeId
        : '';

    final selectedGradeStillExists =
        selectedGradeId.isEmpty ||
        _grades.any((grade) => grade.gradeId == selectedGradeId);

    if (!selectedGradeStillExists) {
      selectedGradeId = '';
    }

    emit(
      ViewNotesDataSuccess(
        grades: _grades,
        notes: _notes,
        searchQuery: searchQuery,
        selectedGradeId: selectedGradeId,
        selectedPublicationFilter: publicationFilter,
      ),
    );
  }

  void _emitFailure(AppErrorModel error) {
    if (isClosed) return;

    _hasFailure = true;

    emit(ViewNotesFailure(error: error));
  }

  void _resetData() {
    _grades = const [];
    _notes = const [];

    _hasLoadedGrades = false;
    _hasLoadedNotes = false;
    _hasFailure = false;
  }

  Future<void> _cancelSubscriptions() async {
    await _gradesSubscription?.cancel();
    await _notesSubscription?.cancel();

    _gradesSubscription = null;
    _notesSubscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelSubscriptions();

    return super.close();
  }
}
