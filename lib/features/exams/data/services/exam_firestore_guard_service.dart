import 'package:alwaleed_admin/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admin/features/exams/data/validation/core/constants/exam_feature_messages.dart';
import 'package:alwaleed_admin/features/exams/data/validation/policy/exam_editing_policy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamFirestoreGuardService {
  const ExamFirestoreGuardService({
    required this._examEditingPolicy,
  });

  final ExamEditingPolicy _examEditingPolicy;

  static const String isDeletingField = 'isDeleting';

  ExamModel requireExistingExam(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    _requireDocumentData(snapshot);

    return ExamModel.fromFirestore(snapshot);
  }

  ExamModel requireAvailableExam(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic> data = _requireDocumentData(snapshot);

    ensureExamIsNotDeleting(data);

    return ExamModel.fromFirestore(snapshot);
  }

  ExamModel requireQuestionsEditableExam(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final ExamModel exam = requireAvailableExam(snapshot);

    _examEditingPolicy.ensureQuestionsCanBeEdited(exam);

    return exam;
  }

  ExamQuestionModel requireExamQuestion(
    DocumentSnapshot<Map<String, dynamic>> snapshot, {
    required String examId,
  }) {
    final Map<String, dynamic> data = _requireDocumentData(snapshot);

    ensureQuestionBelongsToExam(questionData: data, examId: examId);

    return ExamQuestionModel.fromFirestore(snapshot);
  }

  void ensureSettingsCanBeUpdated({
    required DocumentSnapshot<Map<String, dynamic>> currentSnapshot,
    required ExamModel updatedExam,
  }) {
    final ExamModel currentExam = requireAvailableExam(currentSnapshot);

    _examEditingPolicy.ensureSettingsCanBeUpdated(
      currentExam: currentExam,
      updatedExam: updatedExam,
    );
  }

  void ensureExamCanBeDeleted(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final ExamModel exam = requireExistingExam(snapshot);

    _examEditingPolicy.ensureExamCanBeDeleted(exam);
  }

  void ensureExamIsNotDeleting(Map<String, dynamic> examData) {
    if (examData[isDeletingField] == true) {
      FirebaseErrorHandler.throwFirestoreCode(
        'failed-precondition',
        message: ExamFeatureMessages.deletionInProgress,
      );
    }
  }

  void ensureQuestionBelongsToExam({
    required Map<String, dynamic> questionData,
    required String examId,
  }) {
    final String storedExamId =
        questionData[FirestoreFields.examId]?.toString().trim() ?? '';

    if (storedExamId != examId.trim()) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }

  void ensureQuestionsLimitNotReached({
    required ExamModel exam,
    required int maximumQuestions,
  }) {
    if (exam.questionCount >= maximumQuestions) {
      FirebaseErrorHandler.throwFirestoreCode(
        'failed-precondition',
        message: ExamFeatureMessages.questionsLimitReached,
      );
    }
  }

  Map<String, dynamic> _requireDocumentData(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic>? data = snapshot.data();

    if (!snapshot.exists || data == null) {
      FirebaseErrorHandler.throwFirestoreCode('not-found');
    }

    return data;
  }
}
