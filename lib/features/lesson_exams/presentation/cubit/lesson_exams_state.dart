import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';

enum LessonExamsPageStatus { initial, loading, success, failure }

enum LessonExamsActionStatus {
  idle,
  savingAnswers,
  deletingQuestion,
  success,
  failure,
}

enum LessonExamsActionType { none, saveAnswers, deleteQuestion }

class LessonExamsState {
  LessonExamsState({
    required this.pageStatus,
    required this.exam,
    required Map<String, int> selectedCorrectChoiceIndexes,
    required Map<String, int> persistedCorrectChoiceIndexes,
    this.actionStatus = LessonExamsActionStatus.idle,
    this.actionType = LessonExamsActionType.none,
    this.pageError,
    this.actionError,
    this.deletingQuestionId,
  }) : selectedCorrectChoiceIndexes = Map<String, int>.unmodifiable(
         selectedCorrectChoiceIndexes,
       ),
       persistedCorrectChoiceIndexes = Map<String, int>.unmodifiable(
         persistedCorrectChoiceIndexes,
       );

  factory LessonExamsState.initial({required String lessonId}) {
    return LessonExamsState(
      pageStatus: LessonExamsPageStatus.initial,
      exam: LessonExamEntity.empty(lessonId: lessonId),
      selectedCorrectChoiceIndexes: const {},
      persistedCorrectChoiceIndexes: const {},
    );
  }

  final LessonExamsPageStatus pageStatus;
  final LessonExamEntity exam;

  final Map<String, int> selectedCorrectChoiceIndexes;

  final Map<String, int> persistedCorrectChoiceIndexes;

  final LessonExamsActionStatus actionStatus;
  final LessonExamsActionType actionType;

  final AppErrorModel? pageError;
  final AppErrorModel? actionError;

  final String? deletingQuestionId;

  bool get isInitial {
    return pageStatus == LessonExamsPageStatus.initial;
  }

  bool get isPageLoading {
    return pageStatus == LessonExamsPageStatus.loading;
  }

  bool get isPageReady {
    return pageStatus == LessonExamsPageStatus.success;
  }

  bool get hasPageFailure {
    return pageStatus == LessonExamsPageStatus.failure;
  }

  bool get isSavingAnswers {
    return actionStatus == LessonExamsActionStatus.savingAnswers;
  }

  bool get isDeletingQuestion {
    return actionStatus == LessonExamsActionStatus.deletingQuestion;
  }

  bool get isActionInProgress {
    return isSavingAnswers || isDeletingQuestion;
  }

  bool get hasActionSuccess {
    return actionStatus == LessonExamsActionStatus.success;
  }

  bool get hasActionFailure {
    return actionStatus == LessonExamsActionStatus.failure;
  }

  bool get hasQuestions {
    return exam.questions.isNotEmpty;
  }

  int get totalDegrees {
    return exam.totalDegrees;
  }

  int get questionsCount {
    return exam.questionsCount;
  }

  bool get allQuestionsHaveSelectedAnswers {
    if (exam.questions.isEmpty) {
      return false;
    }

    for (final question in exam.questions) {
      final selectedIndex = selectedCorrectChoiceIndexes[question.questionId];

      if (selectedIndex == null ||
          selectedIndex < 0 ||
          selectedIndex >= question.choices.length) {
        return false;
      }
    }

    return true;
  }

  bool get hasUnsavedChanges {
    return !_areMapsEqual(
      selectedCorrectChoiceIndexes,
      persistedCorrectChoiceIndexes,
    );
  }

  bool get canSaveAnswers {
    return isPageReady &&
        !isActionInProgress &&
        allQuestionsHaveSelectedAnswers &&
        hasUnsavedChanges;
  }

  int? selectedChoiceIndexFor(String questionId) {
    return selectedCorrectChoiceIndexes[questionId];
  }

  bool isQuestionDeleting(String questionId) {
    return isDeletingQuestion && deletingQuestionId == questionId;
  }

  LessonExamQuestionEntity? questionById(String questionId) {
    for (final question in exam.questions) {
      if (question.questionId == questionId) {
        return question;
      }
    }

    return null;
  }

  LessonExamsState copyWith({
    LessonExamsPageStatus? pageStatus,
    LessonExamEntity? exam,
    Map<String, int>? selectedCorrectChoiceIndexes,
    Map<String, int>? persistedCorrectChoiceIndexes,
    LessonExamsActionStatus? actionStatus,
    LessonExamsActionType? actionType,
    AppErrorModel? pageError,
    bool clearPageError = false,
    AppErrorModel? actionError,
    bool clearActionError = false,
    String? deletingQuestionId,
    bool clearDeletingQuestionId = false,
  }) {
    return LessonExamsState(
      pageStatus: pageStatus ?? this.pageStatus,
      exam: exam ?? this.exam,
      selectedCorrectChoiceIndexes:
          selectedCorrectChoiceIndexes ?? this.selectedCorrectChoiceIndexes,
      persistedCorrectChoiceIndexes:
          persistedCorrectChoiceIndexes ?? this.persistedCorrectChoiceIndexes,
      actionStatus: actionStatus ?? this.actionStatus,
      actionType: actionType ?? this.actionType,
      pageError: clearPageError ? null : pageError ?? this.pageError,
      actionError: clearActionError ? null : actionError ?? this.actionError,
      deletingQuestionId: clearDeletingQuestionId
          ? null
          : deletingQuestionId ?? this.deletingQuestionId,
    );
  }

  static bool _areMapsEqual(Map<String, int> first, Map<String, int> second) {
    if (first.length != second.length) {
      return false;
    }

    for (final entry in first.entries) {
      if (second[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }
}
