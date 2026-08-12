import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/delete_study_note_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/get_study_note_by_id_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/update_study_note_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/edit_note_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditNoteCubit extends Cubit<EditNoteState> {
  EditNoteCubit({
    required String noteId,
    required GetStudyNoteByIdUseCase getStudyNoteByIdUseCase,
    required StreamGradesUseCase streamGradesUseCase,
    required UpdateStudyNoteUseCase updateStudyNoteUseCase,
    required DeleteStudyNoteUseCase deleteStudyNoteUseCase,
  }) : _noteId = noteId.trim(),
       _getStudyNoteByIdUseCase = getStudyNoteByIdUseCase,
       _streamGradesUseCase = streamGradesUseCase,
       _updateStudyNoteUseCase = updateStudyNoteUseCase,
       _deleteStudyNoteUseCase = deleteStudyNoteUseCase,
       super(const EditNoteState());

  final String _noteId;

  final GetStudyNoteByIdUseCase _getStudyNoteByIdUseCase;

  final StreamGradesUseCase _streamGradesUseCase;

  final UpdateStudyNoteUseCase _updateStudyNoteUseCase;

  final DeleteStudyNoteUseCase _deleteStudyNoteUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  List<GradeEntity> _grades = const [];

  StudyNoteEntity? _loadedNote;

  bool _hasLoadedGrades = false;
  bool _hasLoadedNote = false;
  bool _hasPageFailure = false;
  bool _isInitializing = false;

  Future<void> initialize() async {
    if (_isInitializing || isClosed) {
      return;
    }

    _isInitializing = true;

    try {
      await _cancelSubscriptions();

      _resetLoadedData();

      if (isClosed) {
        return;
      }

      emit(const EditNoteState(pageStatus: EditNotePageStatus.loading));

      _watchGrades();

      final noteResult = await _getStudyNoteByIdUseCase(noteId: _noteId);

      _onNoteResult(noteResult);
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() {
    return initialize();
  }

  void changeTitle(String value) {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    emit(
      state.copyWith(
        title: value,
        actionStatus: EditNoteActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void changeDescription(String value) {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    emit(
      state.copyWith(
        description: value,
        actionStatus: EditNoteActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void selectGrade(String gradeId) {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    emit(
      state.copyWith(
        selectedGradeId: gradeId.trim(),
        actionStatus: EditNoteActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void changePublicationStatus(bool isPublished) {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    emit(
      state.copyWith(
        isPublished: isPublished,
        actionStatus: EditNoteActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void selectReplacementPdf(EditNotePdfFile file) {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    final normalizedName = file.name.trim();
    final normalizedPath = file.path.trim();

    if (normalizedName.isEmpty ||
        normalizedPath.isEmpty ||
        file.sizeInBytes <= 0) {
      return;
    }

    emit(
      state.copyWith(
        replacementPdf: EditNotePdfFile(
          name: normalizedName,
          path: normalizedPath,
          sizeInBytes: file.sizeInBytes,
        ),
        actionStatus: EditNoteActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void removeReplacementPdf() {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    emit(
      state.copyWith(
        clearReplacementPdf: true,
        actionStatus: EditNoteActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  Future<void> updateNote() async {
    if (!state.canUpdate) {
      return;
    }

    final currentNote = state.note;

    if (currentNote == null) {
      return;
    }

    final replacementPdf = state.replacementPdf;

    final updatedNote = StudyNoteEntity(
      noteId: currentNote.noteId,
      name: state.title.trim(),
      description: state.description.trim(),
      gradeId: state.selectedGradeId.trim(),
      isPublished: state.isPublished,
      pdfStoragePath: currentNote.pdfStoragePath,
      pdfFileName: replacementPdf?.name ?? currentNote.pdfFileName,
      pdfFileSize: replacementPdf?.sizeInBytes ?? currentNote.pdfFileSize,
      createdAt: currentNote.createdAt,
      updatedAt: currentNote.updatedAt,
    );

    emit(
      state.copyWith(
        actionStatus: EditNoteActionStatus.updating,
        clearActionError: true,
      ),
    );

    final result = await _updateStudyNoteUseCase(
      note: updatedNote,
      replacementPdfFilePath: replacementPdf?.path,
    );

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(
            actionStatus: EditNoteActionStatus.updateFailure,
            actionError: error,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            actionStatus: EditNoteActionStatus.updateSuccess,
            clearActionError: true,
          ),
        );
      },
    );
  }

  Future<void> deleteNote() async {
    if (!state.canDelete) {
      return;
    }

    final currentNote = state.note;

    if (currentNote == null) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: EditNoteActionStatus.deleting,
        clearActionError: true,
      ),
    );

    final result = await _deleteStudyNoteUseCase(noteId: currentNote.noteId);

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(
            actionStatus: EditNoteActionStatus.deleteFailure,
            actionError: error,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            actionStatus: EditNoteActionStatus.deleteSuccess,
            clearActionError: true,
          ),
        );
      },
    );
  }

  void consumeActionResult() {
    if (state.isActionInProgress) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: EditNoteActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void _watchGrades() {
    _gradesSubscription = _streamGradesUseCase(
      activeOnly: false,
    ).listen(_onGradesResult, onError: (_) {});
  }

  void _onGradesResult(Either<AppErrorModel, List<GradeEntity>> result) {
    if (isClosed) {
      return;
    }

    result.fold(_emitPageFailure, (grades) {
      _grades = List<GradeEntity>.unmodifiable(grades);

      _hasLoadedGrades = true;

      _emitReadyIfPossible();
    });
  }

  void _onNoteResult(Either<AppErrorModel, StudyNoteEntity> result) {
    if (isClosed) {
      return;
    }

    result.fold(_emitPageFailure, (note) {
      _loadedNote = note;
      _hasLoadedNote = true;

      _emitReadyIfPossible();
    });
  }

  void _emitReadyIfPossible() {
    if (isClosed || _hasPageFailure || !_hasLoadedGrades || !_hasLoadedNote) {
      return;
    }

    final note = _loadedNote;

    if (note == null) {
      return;
    }

    final currentState = state;

    if (currentState.isPageReady) {
      emit(currentState.copyWith(grades: _grades));

      return;
    }

    emit(
      EditNoteState(
        pageStatus: EditNotePageStatus.ready,
        actionStatus: EditNoteActionStatus.idle,
        note: note,
        grades: _grades,
        title: note.name,
        description: note.description,
        selectedGradeId: note.gradeId,
        isPublished: note.isPublished,
      ),
    );
  }

  void _emitPageFailure(AppErrorModel error) {
    if (isClosed) {
      return;
    }

    _hasPageFailure = true;

    emit(
      EditNoteState(pageStatus: EditNotePageStatus.failure, pageError: error),
    );
  }

  void _resetLoadedData() {
    _grades = const [];
    _loadedNote = null;

    _hasLoadedGrades = false;
    _hasLoadedNote = false;
    _hasPageFailure = false;
  }

  Future<void> _cancelSubscriptions() async {
    await _gradesSubscription?.cancel();

    _gradesSubscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelSubscriptions();

    return super.close();
  }
}
