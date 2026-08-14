import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/create_lesson_use_case.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLessonCubit extends Cubit<AddLessonState> {
  AddLessonCubit({
    required StreamGradesUseCase streamGradesUseCase,
    required CreateLessonUseCase createLessonUseCase,
  }) : _streamGradesUseCase = streamGradesUseCase,
       _createLessonUseCase = createLessonUseCase,
       super(const AddLessonState());

  final StreamGradesUseCase _streamGradesUseCase;
  final CreateLessonUseCase _createLessonUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  Future<void> initialize() => watchGrades();

  Future<void> watchGrades() async {
    await _gradesSubscription?.cancel();

    _gradesSubscription = null;

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        pageStatus: AddLessonPageStatus.loading,
        submissionStatus: AddLessonSubmissionStatus.idle,
        grades: const [],
        selectedGradeId: '',
        clearError: true,
      ),
    );

    _gradesSubscription = _streamGradesUseCase(
      activeOnly: true,
    ).listen(_handleGradesResult);
  }

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

  void selectPdf(AddLessonPdfFile pdfFile) {
    _updateForm((currentState) => currentState.copyWith(selectedPdf: pdfFile));
  }

  void removePdf() {
    _updateForm(
      (currentState) => currentState.copyWith(clearSelectedPdf: true),
    );
  }

  void _updateForm(
    AddLessonState Function(AddLessonState currentState) update,
  ) {
    if (isClosed || state.isSubmitting) {
      return;
    }

    final updatedState = update(state);

    emit(
      updatedState.copyWith(
        submissionStatus: AddLessonSubmissionStatus.idle,
        clearError: true,
      ),
    );
  }

  Future<void> createLesson() async {
    final currentState = state;

    if (!currentState.canSubmit) {
      return;
    }

    final selectedPdf = currentState.selectedPdf;

    if (selectedPdf == null) {
      return;
    }

    emit(
      currentState.copyWith(
        submissionStatus: AddLessonSubmissionStatus.loading,
        clearError: true,
      ),
    );

    final lesson = LessonEntity(
      lessonId: _generateLessonId(),
      gradeId: currentState.selectedGradeId.trim(),
      title: currentState.title.trim(),
      subtitle: currentState.subtitle.trim(),
      youtubeUrl: currentState.youtubeUrl.trim(),
      pdfFileName: selectedPdf.name.trim(),
      pdfFileSize: selectedPdf.sizeInBytes,
      isPublished: currentState.isPublished,
    );

    final result = await _createLessonUseCase(
      lesson: lesson,
      localPdfFilePath: selectedPdf.path,
    );

    if (isClosed) {
      return;
    }

    result.fold(_emitSubmissionFailure, (_) => _emitSubmissionSuccess());
  }

  void consumeSubmissionResult() {
    if (isClosed || state.submissionStatus == AddLessonSubmissionStatus.idle) {
      return;
    }

    emit(
      state.copyWith(
        submissionStatus: AddLessonSubmissionStatus.idle,
        clearError: true,
      ),
    );
  }

  Future<void> retry() => watchGrades();

  void _handleGradesResult(Either<AppErrorModel, List<GradeEntity>> result) {
    if (isClosed) {
      return;
    }

    result.fold(_handleGradesFailure, _handleGradesSuccess);
  }

  void _handleGradesFailure(AppErrorModel error) {
    if (isClosed || state.grades.isNotEmpty) {
      return;
    }

    emit(state.copyWith(pageStatus: AddLessonPageStatus.failure, error: error));
  }

  void _handleGradesSuccess(List<GradeEntity> grades) {
    if (isClosed) {
      return;
    }

    final availableGrades = List<GradeEntity>.unmodifiable(grades);

    final selectedGradeExists = availableGrades.any(
      (grade) => grade.gradeId == state.selectedGradeId,
    );

    emit(
      state.copyWith(
        pageStatus: AddLessonPageStatus.ready,
        grades: availableGrades,
        selectedGradeId: selectedGradeExists ? state.selectedGradeId : '',
        clearError: true,
      ),
    );
  }

  void _emitSubmissionFailure(AppErrorModel error) {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        submissionStatus: AddLessonSubmissionStatus.failure,
        error: error,
      ),
    );
  }

  void _emitSubmissionSuccess() {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        submissionStatus: AddLessonSubmissionStatus.success,
        clearError: true,
      ),
    );
  }

  String _generateLessonId() {
    final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;

    return 'lesson_$timestamp';
  }

  @override
  Future<void> close() async {
    await _gradesSubscription?.cancel();

    _gradesSubscription = null;

    return super.close();
  }
}
