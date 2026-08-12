import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/create_study_note_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/add_note_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit({
    required StreamGradesUseCase streamGradesUseCase,
    required CreateStudyNoteUseCase createStudyNoteUseCase,
  }) : _streamGradesUseCase = streamGradesUseCase,
       _createStudyNoteUseCase = createStudyNoteUseCase,
       super(const AddNoteState());

  final StreamGradesUseCase _streamGradesUseCase;
  final CreateStudyNoteUseCase _createStudyNoteUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  Future<void> initialize() {
    return watchGrades();
  }

  Future<void> watchGrades() async {
    await _gradesSubscription?.cancel();

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        pageStatus: AddNotePageStatus.loading,
        submissionStatus: AddNoteSubmissionStatus.idle,
        grades: const [],
        selectedGradeId: '',
        clearError: true,
      ),
    );

    _gradesSubscription = _streamGradesUseCase(
      activeOnly: true,
    ).listen(_handleGradesResult);
  }

  void _handleGradesResult(Either<AppErrorModel, List<GradeEntity>> result) {
    if (isClosed) {
      return;
    }

    result.fold(_handleGradesFailure, _handleGradesSuccess);
  }

  void _handleGradesFailure(AppErrorModel error) {
    if (isClosed) {
      return;
    }

    if (state.grades.isNotEmpty) {
      return;
    }

    emit(state.copyWith(pageStatus: AddNotePageStatus.failure, error: error));
  }

  void _handleGradesSuccess(List<GradeEntity> grades) {
    if (isClosed) {
      return;
    }

    final availableGrades = List<GradeEntity>.unmodifiable(grades);

    final selectedGradeExists = availableGrades.any((grade) {
      return grade.gradeId == state.selectedGradeId;
    });

    emit(
      state.copyWith(
        pageStatus: AddNotePageStatus.ready,
        grades: availableGrades,
        selectedGradeId: selectedGradeExists ? state.selectedGradeId : '',
        clearError: true,
      ),
    );
  }

  void changeTitle(String value) {
    if (state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        title: value,
        submissionStatus: AddNoteSubmissionStatus.idle,
        clearError: true,
      ),
    );
  }

  void changeDescription(String value) {
    if (state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        description: value,
        submissionStatus: AddNoteSubmissionStatus.idle,
        clearError: true,
      ),
    );
  }

  void selectGrade(String gradeId) {
    if (state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        selectedGradeId: gradeId.trim(),
        submissionStatus: AddNoteSubmissionStatus.idle,
        clearError: true,
      ),
    );
  }

  void changePublicationStatus(bool isPublished) {
    if (state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        isPublished: isPublished,
        submissionStatus: AddNoteSubmissionStatus.idle,
        clearError: true,
      ),
    );
  }

  void selectPdf(AddNotePdfFile pdfFile) {
    if (state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        selectedPdf: pdfFile,
        submissionStatus: AddNoteSubmissionStatus.idle,
        clearError: true,
      ),
    );
  }

  void removePdf() {
    if (state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        clearSelectedPdf: true,
        submissionStatus: AddNoteSubmissionStatus.idle,
        clearError: true,
      ),
    );
  }

  Future<void> createNote() async {
    final currentState = state;
    final selectedPdf = currentState.selectedPdf;

    if (!currentState.canSubmit || selectedPdf == null) {
      return;
    }

    emit(
      currentState.copyWith(
        submissionStatus: AddNoteSubmissionStatus.loading,
        clearError: true,
      ),
    );

    final note = StudyNoteEntity(
      noteId: _generateNoteId(),
      name: currentState.title.trim(),
      description: currentState.description.trim(),
      gradeId: currentState.selectedGradeId.trim(),
      isPublished: currentState.isPublished,
      pdfStoragePath: '',
      pdfFileName: selectedPdf.name.trim(),
      pdfFileSize: selectedPdf.sizeInBytes,
    );

    final result = await _createStudyNoteUseCase(
      note: note,
      localPdfFilePath: selectedPdf.path,
    );

    if (isClosed) {
      return;
    }

    result.fold(_emitSubmissionFailure, (_) => _emitSubmissionSuccess());
  }

  void _emitSubmissionFailure(AppErrorModel error) {
    emit(
      state.copyWith(
        submissionStatus: AddNoteSubmissionStatus.failure,
        error: error,
      ),
    );
  }

  void _emitSubmissionSuccess() {
    emit(
      state.copyWith(
        submissionStatus: AddNoteSubmissionStatus.success,
        clearError: true,
      ),
    );
  }

  void consumeSubmissionResult() {
    if (state.submissionStatus == AddNoteSubmissionStatus.idle) {
      return;
    }

    emit(
      state.copyWith(
        submissionStatus: AddNoteSubmissionStatus.idle,
        clearError: true,
      ),
    );
  }

  Future<void> retry() {
    return watchGrades();
  }

  String _generateNoteId() {
    final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;

    return 'note_$timestamp';
  }

  @override
  Future<void> close() async {
    await _gradesSubscription?.cancel();

    return super.close();
  }
}
