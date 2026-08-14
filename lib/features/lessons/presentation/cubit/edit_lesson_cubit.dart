import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/delete_lesson_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/get_lesson_by_id_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/update_lesson_use_case.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/edit_lesson_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLessonCubit extends Cubit<EditLessonState> {
  EditLessonCubit({
    required String lessonId,
    required GetLessonByIdUseCase getLessonByIdUseCase,
    required StreamGradesUseCase streamGradesUseCase,
    required UpdateLessonUseCase updateLessonUseCase,
    required DeleteLessonUseCase deleteLessonUseCase,
  }) : _lessonId = lessonId.trim(),
       _getLessonByIdUseCase = getLessonByIdUseCase,
       _streamGradesUseCase = streamGradesUseCase,
       _updateLessonUseCase = updateLessonUseCase,
       _deleteLessonUseCase = deleteLessonUseCase,
       super(const EditLessonState());

  final String _lessonId;

  final GetLessonByIdUseCase _getLessonByIdUseCase;
  final StreamGradesUseCase _streamGradesUseCase;
  final UpdateLessonUseCase _updateLessonUseCase;
  final DeleteLessonUseCase _deleteLessonUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  List<GradeEntity> _grades = const [];
  LessonEntity? _loadedLesson;

  bool _hasLoadedGrades = false;
  bool _hasLoadedLesson = false;
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

      emit(const EditLessonState(pageStatus: EditLessonPageStatus.loading));

      _watchGrades();

      final lessonResult = await _getLessonByIdUseCase(lessonId: _lessonId);

      _onLessonResult(lessonResult);
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> retry() => initialize();

  void changeTitle(String value) {
    _updateForm((currentState) => currentState.copyWith(title: value));
  }

  void changeSubtitle(String value) {
    _updateForm((currentState) => currentState.copyWith(subtitle: value));
  }

  void changeYoutubeUrl(String value) {
    _updateForm((currentState) => currentState.copyWith(youtubeUrl: value));
  }

  void selectGrade(String gradeId) {
    _updateForm(
      (currentState) => currentState.copyWith(selectedGradeId: gradeId.trim()),
    );
  }

  void changePublicationStatus(bool isPublished) {
    _updateForm(
      (currentState) => currentState.copyWith(isPublished: isPublished),
    );
  }

  void selectReplacementPdf(EditLessonPdfFile file) {
    if (!_canEditForm) {
      return;
    }

    final validationError = AppValidator.lessonPdfFile(
      fileName: file.name,
      extension: null,
      sizeInBytes: file.sizeInBytes,
      path: file.path,
    );

    if (validationError != null) {
      return;
    }

    _updateForm(
      (currentState) => currentState.copyWith(
        replacementPdf: EditLessonPdfFile(
          name: file.name.trim(),
          path: file.path.trim(),
          sizeInBytes: file.sizeInBytes,
        ),
      ),
    );
  }

  void removeReplacementPdf() {
    _updateForm(
      (currentState) => currentState.copyWith(clearReplacementPdf: true),
    );
  }

  void _updateForm(
    EditLessonState Function(EditLessonState currentState) update,
  ) {
    if (!_canEditForm) {
      return;
    }

    final updatedState = update(state);

    emit(
      updatedState.copyWith(
        actionStatus: EditLessonActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  bool get _canEditForm {
    return !isClosed && state.isPageReady && !state.isActionInProgress;
  }

  Future<void> updateLesson() async {
    final currentState = state;

    if (!currentState.canUpdate) {
      return;
    }

    final currentLesson = currentState.lesson;

    if (currentLesson == null) {
      return;
    }

    final replacementPdf = currentState.replacementPdf;

    final updatedLesson = LessonEntity(
      lessonId: currentLesson.lessonId,
      gradeId: currentState.selectedGradeId.trim(),
      title: currentState.title.trim(),
      subtitle: currentState.subtitle.trim(),
      youtubeUrl: currentState.youtubeUrl.trim(),
      pdfStoragePath: currentLesson.pdfStoragePath,
      pdfFileName: replacementPdf?.name ?? currentLesson.pdfFileName,
      pdfFileSize: replacementPdf?.sizeInBytes ?? currentLesson.pdfFileSize,
      isPublished: currentState.isPublished,
    );

    emit(
      currentState.copyWith(
        actionStatus: EditLessonActionStatus.updating,
        clearActionError: true,
      ),
    );

    final result = await _updateLessonUseCase(
      lesson: updatedLesson,
      replacementPdfFilePath: replacementPdf?.path,
    );

    if (isClosed) {
      return;
    }

    result.fold(_emitUpdateFailure, (_) => _emitUpdateSuccess(updatedLesson));
  }

  Future<void> deleteLesson() async {
    final currentState = state;

    if (!currentState.canDelete) {
      return;
    }

    final currentLesson = currentState.lesson;

    if (currentLesson == null) {
      return;
    }

    emit(
      currentState.copyWith(
        actionStatus: EditLessonActionStatus.deleting,
        clearActionError: true,
      ),
    );

    final result = await _deleteLessonUseCase(lessonId: currentLesson.lessonId);

    if (isClosed) {
      return;
    }

    result.fold(_emitDeleteFailure, (_) => _emitDeleteSuccess());
  }

  void consumeActionResult() {
    if (isClosed || state.isActionInProgress || state.isActionIdle) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: EditLessonActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void _emitUpdateFailure(AppErrorModel error) {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: EditLessonActionStatus.updateFailure,
        actionError: error,
      ),
    );
  }

  void _emitUpdateSuccess(LessonEntity updatedLesson) {
    if (isClosed) {
      return;
    }

    _loadedLesson = updatedLesson;

    emit(
      state.copyWith(
        actionStatus: EditLessonActionStatus.updateSuccess,
        lesson: updatedLesson,
        clearReplacementPdf: true,
        clearActionError: true,
      ),
    );
  }

  void _emitDeleteFailure(AppErrorModel error) {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: EditLessonActionStatus.deleteFailure,
        actionError: error,
      ),
    );
  }

  void _emitDeleteSuccess() {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: EditLessonActionStatus.deleteSuccess,
        clearActionError: true,
      ),
    );
  }

  void _watchGrades() {
    _gradesSubscription = _streamGradesUseCase(
      activeOnly: false,
    ).listen(_onGradesResult);
  }

  void _onGradesResult(Either<AppErrorModel, List<GradeEntity>> result) {
    if (isClosed) {
      return;
    }

    result.fold(_onGradesFailure, _onGradesSuccess);
  }

  void _onGradesFailure(AppErrorModel error) {
    if (isClosed) {
      return;
    }

    if (_hasLoadedGrades || state.isPageReady) {
      return;
    }

    _emitPageFailure(error);
  }

  void _onGradesSuccess(List<GradeEntity> grades) {
    if (isClosed) {
      return;
    }

    _grades = List<GradeEntity>.unmodifiable(grades);
    _hasLoadedGrades = true;

    _emitReadyIfPossible();
  }

  void _onLessonResult(Either<AppErrorModel, LessonEntity> result) {
    if (isClosed) {
      return;
    }

    result.fold(_emitPageFailure, (lesson) {
      _loadedLesson = lesson;
      _hasLoadedLesson = true;

      _emitReadyIfPossible();
    });
  }

  void _emitReadyIfPossible() {
    if (isClosed || _hasPageFailure || !_hasLoadedGrades || !_hasLoadedLesson) {
      return;
    }

    final lesson = _loadedLesson;

    if (lesson == null) {
      return;
    }

    final currentState = state;

    if (currentState.isPageReady) {
      emit(currentState.copyWith(grades: _grades));

      return;
    }

    emit(
      EditLessonState(
        pageStatus: EditLessonPageStatus.ready,
        actionStatus: EditLessonActionStatus.idle,
        lesson: lesson,
        grades: _grades,
        title: lesson.title,
        subtitle: lesson.subtitle,
        youtubeUrl: lesson.youtubeUrl ?? '',
        selectedGradeId: lesson.gradeId,
        isPublished: lesson.isPublished,
      ),
    );
  }

  void _emitPageFailure(AppErrorModel error) {
    if (isClosed || _hasPageFailure) {
      return;
    }

    _hasPageFailure = true;

    emit(
      EditLessonState(
        pageStatus: EditLessonPageStatus.failure,
        pageError: error,
      ),
    );
  }

  void _resetLoadedData() {
    _grades = const [];
    _loadedLesson = null;

    _hasLoadedGrades = false;
    _hasLoadedLesson = false;
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
