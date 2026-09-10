import 'package:alwaleed_admin/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admin/features/exams/data/validation/core/constants/exam_feature_messages.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';

class ExamEditingPolicy {
  const ExamEditingPolicy();

  bool hasStudentStarted(ExamModel exam) {
    return exam.firstAttemptAt != null || exam.participantsCount > 0;
  }

  bool canEditSettings(ExamModel exam) {
    return !exam.isEnded && !hasStudentStarted(exam);
  }

  bool canEditQuestions(ExamModel exam) {
    return !exam.isEnded && !hasStudentStarted(exam);
  }

  bool canChangePublicationStatus(ExamModel exam) {
    return !exam.isEnded && !hasStudentStarted(exam);
  }

  bool canCloseExam(ExamModel exam) {
    return exam.status == ExamStatus.published;
  }

  void ensureSettingsCanBeUpdated({
    required ExamModel currentExam,
    required ExamModel updatedExam,
  }) {
    _ensureExamNotEnded(currentExam);

    if (!hasStudentStarted(currentExam)) {
      return;
    }

    final bool settingsChanged =
        currentExam.gradeId.trim() != updatedExam.gradeId.trim() ||
        currentExam.examName.trim() != updatedExam.examName.trim() ||
        currentExam.durationMinutes != updatedExam.durationMinutes;

    final bool publicationStatusChanged =
        currentExam.status != updatedExam.status;

    final bool isClosingExam =
        currentExam.status != ExamStatus.ended &&
        updatedExam.status == ExamStatus.ended;

    final bool isCloseOnly = isClosingExam && !settingsChanged;

    if (isCloseOnly) {
      return;
    }

    if (settingsChanged) {
      _throwEditingLocked(ExamFeatureMessages.settingsEditingLocked);
    }

    if (publicationStatusChanged) {
      _throwEditingLocked(ExamFeatureMessages.unpublishingLocked);
    }

    _throwEditingLocked(ExamFeatureMessages.closeExamOnly);
  }

  void ensureQuestionsCanBeEdited(ExamModel exam) {
    _ensureExamNotEnded(exam);

    if (hasStudentStarted(exam)) {
      _throwEditingLocked(ExamFeatureMessages.questionsEditingLocked);
    }
  }

  void ensureCanCreateQuestion(ExamModel exam) {
    ensureQuestionsCanBeEdited(exam);
  }

  void ensureCanUpdateQuestion(ExamModel exam) {
    ensureQuestionsCanBeEdited(exam);
  }

  void ensureCanDeleteQuestion(ExamModel exam) {
    ensureQuestionsCanBeEdited(exam);
  }

  void ensureExamCanBeDeleted(ExamModel exam) {
    if (exam.isEnded) {
      return;
    }

    if (hasStudentStarted(exam)) {
      _throwEditingLocked(ExamFeatureMessages.deletionLocked);
    }
  }

  void _ensureExamNotEnded(ExamModel exam) {
    if (exam.isEnded) {
      _throwEditingLocked(ExamFeatureMessages.endedExamEditingLocked);
    }
  }

  Never _throwEditingLocked(String message) {
    FirebaseErrorHandler.throwFirestoreCode(
      'failed-precondition',
      message: message,
    );
  }
}
