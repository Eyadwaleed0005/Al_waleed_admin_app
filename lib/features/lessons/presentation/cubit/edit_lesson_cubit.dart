import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
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
        actionStatus: EditLessonActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void changeSubtitle(String value) {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    emit(
      state.copyWith(
        subtitle: value,
        actionStatus: EditLessonActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void changeYoutubeUrl(String value) {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    emit(
      state.copyWith(
        youtubeUrl: value,
        actionStatus: EditLessonActionStatus.idle,
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
        actionStatus: EditLessonActionStatus.idle,
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
        actionStatus: EditLessonActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  void selectReplacementPdf(EditLessonPdfFile file) {
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
        replacementPdf: EditLessonPdfFile(
          name: normalizedName,
          path: normalizedPath,
          sizeInBytes: file.sizeInBytes,
        ),
        actionStatus: EditLessonActionStatus.idle,
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
        actionStatus: EditLessonActionStatus.idle,
        clearActionError: true,
      ),
    );
  }

  Future<void> updateLesson() async {
    if (!state.canUpdate) {
      return;
    }

    final currentLesson = state.lesson;

    if (currentLesson == null) {
      return;
    }

    final replacementPdf = state.replacementPdf;

    final updatedLesson = LessonEntity(
      lessonId: currentLesson.lessonId,
      gradeId: state.selectedGradeId.trim(),
      title: state.title.trim(),
      subtitle: state.subtitle.trim(),
      youtubeUrl: state.youtubeUrl.trim(),
      pdfStoragePath: currentLesson.pdfStoragePath,
      pdfFileName: replacementPdf?.name ?? currentLesson.pdfFileName,
      pdfFileSize: replacementPdf?.sizeInBytes ?? currentLesson.pdfFileSize,
      isPublished: state.isPublished,
    );

    emit(
      state.copyWith(
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

    result.fold(
      (error) {
        emit(
          state.copyWith(
            actionStatus: EditLessonActionStatus.updateFailure,
            actionError: error,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            actionStatus: EditLessonActionStatus.updateSuccess,
            clearActionError: true,
          ),
        );
      },
    );
  }

  Future<void> deleteLesson() async {
    if (!state.canDelete) {
      return;
    }

    final currentLesson = state.lesson;

    if (currentLesson == null) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: EditLessonActionStatus.deleting,
        clearActionError: true,
      ),
    );

    final result = await _deleteLessonUseCase(lessonId: currentLesson.lessonId);

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(
            actionStatus: EditLessonActionStatus.deleteFailure,
            actionError: error,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            actionStatus: EditLessonActionStatus.deleteSuccess,
            clearActionError: true,
          ),
        );
      },
    );
  }

  void consumeActionResult() {
    if (state.isActionInProgress ||
        state.actionStatus == EditLessonActionStatus.idle) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: EditLessonActionStatus.idle,
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

    result.fold(_emitPageFailure, (grades) {
      _grades = List<GradeEntity>.unmodifiable(grades);

      _hasLoadedGrades = true;

      _emitReadyIfPossible();
    });
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
