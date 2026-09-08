import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';

enum ExamQuestionsOperation {
  createExam,
  updateQuestion,
  deleteQuestion,
  saveQuestionChanges,
}

sealed class ExamQuestionsState {
  const ExamQuestionsState();
}

final class ExamQuestionsLoading extends ExamQuestionsState {
  const ExamQuestionsLoading();
}

final class ExamQuestionsEmpty extends ExamQuestionsState {
  const ExamQuestionsEmpty();
}

final class ExamQuestionsSuccess extends ExamQuestionsState {
  ExamQuestionsSuccess({
    required List<ExamQuestionEntity> questions,
    required Map<String, int> selectedChoiceIndexes,
    required Map<String, ExamQuestionImageFile> questionImages,
    required this.isCreatingExam,
    required this.canEdit,
    required this.hasUnsavedChanges,
    this.isOperating = false,
    this.operation,
    this.operationSucceeded = false,
    this.operationError,
    this.operatingQuestionId,
    this.savedExamId,
  }) : questions = List<ExamQuestionEntity>.unmodifiable(questions),
       selectedChoiceIndexes = Map<String, int>.unmodifiable(
         selectedChoiceIndexes,
       ),
       questionImages = Map<String, ExamQuestionImageFile>.unmodifiable(
         questionImages,
       );

  final List<ExamQuestionEntity> questions;
  final Map<String, int> selectedChoiceIndexes;
  final Map<String, ExamQuestionImageFile> questionImages;

  final bool isCreatingExam;
  final bool canEdit;
   final bool hasUnsavedChanges;

  final bool isOperating;
  final ExamQuestionsOperation? operation;
  final bool operationSucceeded;
  final AppErrorModel? operationError;
  final String? operatingQuestionId;
  final String? savedExamId;

  bool get isSavingExam {
    return isOperating &&
        operation == ExamQuestionsOperation.createExam;
  }

  bool get isSavingChanges {
    return isOperating &&
        operation == ExamQuestionsOperation.saveQuestionChanges;
  }

  bool get isUpdatingQuestion {
    return isOperating &&
        operation == ExamQuestionsOperation.updateQuestion;
  }

  bool get isDeletingQuestion {
    return isOperating &&
        operation == ExamQuestionsOperation.deleteQuestion;
  }

  bool get canAddQuestion {
    return canEdit &&
        !isOperating &&
        savedExamId == null;
  }

  int get totalDegrees {
    return questions.fold<int>(
      0,
      (
        int total,
        ExamQuestionEntity question,
      ) {
        return total + question.degree;
      },
    );
  }

  bool get allQuestionsHaveCorrectChoice {
    if (questions.isEmpty) {
      return false;
    }

    return questions.every(
      (ExamQuestionEntity question) {
        final int? choiceIndex =
            selectedChoiceIndexes[question.questionId];

        return choiceIndex != null &&
            choiceIndex >= 0 &&
            choiceIndex < question.choices.length;
      },
    );
  }

  bool get canSaveExam {
    return isCreatingExam &&
        canEdit &&
        !isOperating &&
        savedExamId == null &&
        allQuestionsHaveCorrectChoice;
  }

  bool get canSaveChanges {
    return !isCreatingExam &&
        canEdit &&
        !isOperating &&
        hasUnsavedChanges &&
        allQuestionsHaveCorrectChoice;
  }
}

final class ExamQuestionsError extends ExamQuestionsState {
  const ExamQuestionsError({
    required this.error,
  });

  final AppErrorModel error;
}