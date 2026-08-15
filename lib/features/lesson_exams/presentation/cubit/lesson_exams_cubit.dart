import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/use_case/delete_lesson_exam_question_use_case.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/use_case/save_lesson_exam_answers_use_case.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/use_case/stream_lesson_exam_use_case.dart';
import 'package:alwaleed_admain/features/lesson_exams/presentation/cubit/lesson_exams_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonExamsCubit extends Cubit<LessonExamsState> {
  LessonExamsCubit({
    required String lessonId,
    required StreamLessonExamUseCase streamLessonExamUseCase,
    required DeleteLessonExamQuestionUseCase deleteLessonExamQuestionUseCase,
    required SaveLessonExamAnswersUseCase saveLessonExamAnswersUseCase,
  }) : _lessonId = lessonId.trim(),
       _streamLessonExamUseCase = streamLessonExamUseCase,
       _deleteLessonExamQuestionUseCase = deleteLessonExamQuestionUseCase,
       _saveLessonExamAnswersUseCase = saveLessonExamAnswersUseCase,
       super(LessonExamsState.initial(lessonId: lessonId.trim()));

  final String _lessonId;

  final StreamLessonExamUseCase _streamLessonExamUseCase;

  final DeleteLessonExamQuestionUseCase _deleteLessonExamQuestionUseCase;

  final SaveLessonExamAnswersUseCase _saveLessonExamAnswersUseCase;

  StreamSubscription<Either<AppErrorModel, LessonExamEntity>>?
  _examSubscription;

  void initialize() {
    watchExam();
  }

  void watchExam() {
    _examSubscription?.cancel();

    emit(
      state.copyWith(
        pageStatus: LessonExamsPageStatus.loading,
        clearPageError: true,
      ),
    );

    _examSubscription = _streamLessonExamUseCase(lessonId: _lessonId).listen((
      result,
    ) {
      result.fold(_handleStreamFailure, _handleStreamSuccess);
    });
  }

  void retry() {
    if (state.isPageLoading) {
      return;
    }

    watchExam();
  }

  void selectCorrectChoice({
    required String questionId,
    required int choiceIndex,
  }) {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    final normalizedQuestionId = questionId.trim();

    final question = state.questionById(normalizedQuestionId);

    if (question == null ||
        choiceIndex < 0 ||
        choiceIndex >= question.choices.length) {
      return;
    }

    final updatedSelections = Map<String, int>.from(
      state.selectedCorrectChoiceIndexes,
    );

    updatedSelections[normalizedQuestionId] = choiceIndex;

    emit(
      state.copyWith(
        selectedCorrectChoiceIndexes: updatedSelections,
        actionStatus: LessonExamsActionStatus.idle,
        actionType: LessonExamsActionType.none,
        clearActionError: true,
        clearDeletingQuestionId: true,
      ),
    );
  }

  Future<void> saveAnswers() async {
    if (!state.canSaveAnswers) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: LessonExamsActionStatus.savingAnswers,
        actionType: LessonExamsActionType.saveAnswers,
        clearActionError: true,
        clearDeletingQuestionId: true,
      ),
    );

    final answers = Map<String, int>.unmodifiable(
      state.selectedCorrectChoiceIndexes,
    );

    final result = await _saveLessonExamAnswersUseCase(
      lessonId: _lessonId,
      correctChoiceIndexes: answers,
    );

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(
            actionStatus: LessonExamsActionStatus.failure,
            actionType: LessonExamsActionType.saveAnswers,
            actionError: error,
            clearDeletingQuestionId: true,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            persistedCorrectChoiceIndexes: answers,
            actionStatus: LessonExamsActionStatus.success,
            actionType: LessonExamsActionType.saveAnswers,
            clearActionError: true,
            clearDeletingQuestionId: true,
          ),
        );
      },
    );
  }

  Future<void> deleteQuestion({required String questionId}) async {
    if (!state.isPageReady || state.isActionInProgress) {
      return;
    }

    final normalizedQuestionId = questionId.trim();

    if (normalizedQuestionId.isEmpty) {
      return;
    }

    final question = state.questionById(normalizedQuestionId);

    if (question == null) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: LessonExamsActionStatus.deletingQuestion,
        actionType: LessonExamsActionType.deleteQuestion,
        deletingQuestionId: normalizedQuestionId,
        clearActionError: true,
      ),
    );

    final result = await _deleteLessonExamQuestionUseCase(
      lessonId: _lessonId,
      questionId: normalizedQuestionId,
    );

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(
            actionStatus: LessonExamsActionStatus.failure,
            actionType: LessonExamsActionType.deleteQuestion,
            actionError: error,
            clearDeletingQuestionId: true,
          ),
        );
      },
      (_) {
        final updatedQuestions = state.exam.questions
            .where((currentQuestion) {
              return currentQuestion.questionId != normalizedQuestionId;
            })
            .toList(growable: false);

        final updatedSelections = Map<String, int>.from(
          state.selectedCorrectChoiceIndexes,
        )..remove(normalizedQuestionId);

        final updatedPersistedAnswers = Map<String, int>.from(
          state.persistedCorrectChoiceIndexes,
        )..remove(normalizedQuestionId);

        emit(
          state.copyWith(
            exam: state.exam.copyWith(
              questions: List<LessonExamQuestionEntity>.unmodifiable(
                updatedQuestions,
              ),
            ),
            selectedCorrectChoiceIndexes: updatedSelections,
            persistedCorrectChoiceIndexes: updatedPersistedAnswers,
            actionStatus: LessonExamsActionStatus.success,
            actionType: LessonExamsActionType.deleteQuestion,
            clearActionError: true,
            clearDeletingQuestionId: true,
          ),
        );
      },
    );
  }

  void clearActionFeedback() {
    if (state.isActionInProgress) {
      return;
    }

    emit(
      state.copyWith(
        actionStatus: LessonExamsActionStatus.idle,
        actionType: LessonExamsActionType.none,
        clearActionError: true,
        clearDeletingQuestionId: true,
      ),
    );
  }

  void _handleStreamFailure(AppErrorModel error) {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        pageStatus: LessonExamsPageStatus.failure,
        pageError: error,
      ),
    );
  }

  void _handleStreamSuccess(LessonExamEntity exam) {
    if (isClosed) {
      return;
    }

    final persistedAnswers = <String, int>{};
    final updatedSelections = <String, int>{};

    for (final question in exam.questions) {
      final questionId = question.questionId;
      final persistedIndex = question.correctChoiceIndex;

      if (_isValidChoiceIndex(
        question: question,
        choiceIndex: persistedIndex,
      )) {
        persistedAnswers[questionId] = persistedIndex!;
      }

      final localSelectedIndex = state.selectedCorrectChoiceIndexes[questionId];

      if (_isValidChoiceIndex(
        question: question,
        choiceIndex: localSelectedIndex,
      )) {
        updatedSelections[questionId] = localSelectedIndex!;
        continue;
      }

      if (_isValidChoiceIndex(
        question: question,
        choiceIndex: persistedIndex,
      )) {
        updatedSelections[questionId] = persistedIndex!;
      }
    }

    emit(
      state.copyWith(
        pageStatus: LessonExamsPageStatus.success,
        exam: exam,
        selectedCorrectChoiceIndexes: updatedSelections,
        persistedCorrectChoiceIndexes: persistedAnswers,
        clearPageError: true,
      ),
    );
  }

  bool _isValidChoiceIndex({
    required LessonExamQuestionEntity question,
    required int? choiceIndex,
  }) {
    if (choiceIndex == null) {
      return false;
    }

    return choiceIndex >= 0 && choiceIndex < question.choices.length;
  }

  @override
  Future<void> close() async {
    await _examSubscription?.cancel();

    return super.close();
  }
}
