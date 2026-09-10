import 'package:alwaleed_admin/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admin/features/exams/data/services/exam_question_image_service.dart';
import 'package:alwaleed_admin/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admin/features/exams/data/validation/policy/exam_editing_policy.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamDeletionService {
  const ExamDeletionService({
    required this._firebaseFirestore,
    required this._examsDataValidator,
    required this._examEditingPolicy,
    required this._examQuestionImageService,
  });

  final FirebaseFirestore _firebaseFirestore;
  final ExamsDataValidator _examsDataValidator;
  final ExamEditingPolicy _examEditingPolicy;
  final ExamQuestionImageService _examQuestionImageService;

  static const int _deleteBatchSize = 100;

  CollectionReference<Map<String, dynamic>> get _exams {
    return _firebaseFirestore.collection(FirestoreCollections.exams);
  }

  CollectionReference<Map<String, dynamic>> get _questions {
    return _firebaseFirestore.collection(FirestoreCollections.examQuestions);
  }

  CollectionReference<Map<String, dynamic>> get _results {
    return _firebaseFirestore.collection(FirestoreCollections.examResults);
  }

  CollectionReference<Map<String, dynamic>> get _attemptAnswers {
    return _firebaseFirestore.collection(
      FirestoreCollections.examAttemptAnswers,
    );
  }

  Future<void> deleteExam({required String examId}) async {
    final String normalizedExamId = _examsDataValidator.validateId(examId);

    final DocumentReference<Map<String, dynamic>> examReference = _exams.doc(
      normalizedExamId,
    );

    final bool shouldContinue = await _markExamAsDeleting(
      examReference: examReference,
    );

    if (!shouldContinue) {
      return;
    }

    await _deleteExamAttemptAnswers(examId: normalizedExamId);

    await _deleteExamResults(examId: normalizedExamId);

    await _deleteExamQuestions(examId: normalizedExamId);

    await examReference.delete();
  }

  Future<void> deleteQuestion({
    required String examId,
    required String questionId,
  }) async {
    final String normalizedExamId = _examsDataValidator.validateId(examId);

    final String normalizedQuestionId = _examsDataValidator.validateId(
      questionId,
    );

    final DocumentReference<Map<String, dynamic>> examReference = _exams.doc(
      normalizedExamId,
    );

    final DocumentReference<Map<String, dynamic>> questionReference = _questions
        .doc(normalizedQuestionId);

    final String? imageStoragePath = await _firebaseFirestore
        .runTransaction<String?>((Transaction transaction) async {
          final DocumentSnapshot<Map<String, dynamic>> examSnapshot =
              await transaction.get(examReference);

          if (!examSnapshot.exists || examSnapshot.data() == null) {
            FirebaseErrorHandler.throwFirestoreCode('not-found');
          }

          final ExamModel exam = ExamModel.fromFirestore(examSnapshot);

          _examEditingPolicy.ensureQuestionsCanBeEdited(exam);

          final DocumentSnapshot<Map<String, dynamic>> questionSnapshot =
              await transaction.get(questionReference);

          if (!questionSnapshot.exists || questionSnapshot.data() == null) {
            return null;
          }

          final ExamQuestionModel question = ExamQuestionModel.fromFirestore(
            questionSnapshot,
          );

          if (question.examId.trim() != normalizedExamId) {
            FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
          }

          final int updatedQuestionCount = exam.questionCount - 1;

          final int updatedTotalScore = exam.totalScore - question.degree;

          if (updatedQuestionCount < 0 || updatedTotalScore < 0) {
            FirebaseErrorHandler.throwFirestoreCode('failed-precondition');
          }

          transaction.delete(questionReference);

          transaction.update(examReference, <String, dynamic>{
            FirestoreFields.questionCount: updatedQuestionCount,
            FirestoreFields.totalScore: updatedTotalScore,
            if (updatedQuestionCount == 0)
              FirestoreFields.examStatus: ExamModel.statusToJson(
                ExamStatus.unpublished,
              ),
            FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
          });

          return question.imageStoragePath;
        });

    await _examQuestionImageService.deleteImage(storagePath: imageStoragePath);
  }

  Future<bool> _markExamAsDeleting({
    required DocumentReference<Map<String, dynamic>> examReference,
  }) {
    return _firebaseFirestore.runTransaction<bool>((
      Transaction transaction,
    ) async {
      final DocumentSnapshot<Map<String, dynamic>> examSnapshot =
          await transaction.get(examReference);

      final Map<String, dynamic>? examData = examSnapshot.data();

      if (!examSnapshot.exists || examData == null) {
        return false;
      }

      if (examData[FirestoreFields.isDeleting] == true) {
        return true;
      }

      final ExamModel exam = ExamModel.fromFirestore(examSnapshot);

      _examEditingPolicy.ensureExamCanBeDeleted(exam);

      transaction.update(examReference, <String, dynamic>{
        FirestoreFields.isDeleting: true,
        FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
      });

      return true;
    });
  }

  Future<void> _deleteExamAttemptAnswers({required String examId}) {
    return _deleteDocumentsByExamId(
      collection: _attemptAnswers,
      examId: examId,
    );
  }

  Future<void> _deleteExamResults({required String examId}) {
    return _deleteDocumentsByExamId(collection: _results, examId: examId);
  }

  Future<void> _deleteDocumentsByExamId({
    required CollectionReference<Map<String, dynamic>> collection,
    required String examId,
  }) async {
    while (true) {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await collection
          .where(FirestoreFields.examId, isEqualTo: examId)
          .limit(_deleteBatchSize)
          .get(const GetOptions(source: Source.server));

      if (snapshot.docs.isEmpty) {
        return;
      }

      final WriteBatch batch = _firebaseFirestore.batch();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        batch.delete(document.reference);
      }

      await batch.commit();
    }
  }

  Future<void> _deleteExamQuestions({required String examId}) async {
    while (true) {
      final QuerySnapshot<Map<String, dynamic>> questionsSnapshot =
          await _questions
              .where(FirestoreFields.examId, isEqualTo: examId)
              .limit(_deleteBatchSize)
              .get(const GetOptions(source: Source.server));

      if (questionsSnapshot.docs.isEmpty) {
        return;
      }

      for (final QueryDocumentSnapshot<Map<String, dynamic>> questionDocument
          in questionsSnapshot.docs) {
        final ExamQuestionModel question = ExamQuestionModel.fromFirestore(
          questionDocument,
        );

        await _examQuestionImageService.deleteImage(
          storagePath: question.imageStoragePath,
        );
      }

      final WriteBatch batch = _firebaseFirestore.batch();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> questionDocument
          in questionsSnapshot.docs) {
        batch.delete(questionDocument.reference);
      }

      await batch.commit();
    }
  }
}
