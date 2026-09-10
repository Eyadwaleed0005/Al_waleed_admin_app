import 'package:alwaleed_admin/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_result_model.dart';
import 'package:alwaleed_admin/features/exams/data/services/exam_firestore_guard_service.dart';
import 'package:alwaleed_admin/features/exams/data/validation/core/constants/exam_feature_messages.dart';
import 'package:alwaleed_admin/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_attempt_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamResultsQueryService {
  const ExamResultsQueryService({
    required this._firestoreService,
    required this._examsDataValidator,
    required this._examFirestoreGuardService,
  });

  final FirestoreService _firestoreService;
  final ExamsDataValidator _examsDataValidator;
  final ExamFirestoreGuardService _examFirestoreGuardService;

  Future<List<ExamResultModel>> getExamResults({
    required String examId,
    ExamAttemptStatus? status,
  }) async {
    final String normalizedExamId = _examsDataValidator.validateId(examId);

    await _ensureResultsAreAvailable(examId: normalizedExamId);

    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestoreService
        .getCollection(
          collectionPath: FirestoreCollections.examResults,
          queryBuilder: (CollectionReference<Map<String, dynamic>> collection) {
            return collection.where(
              FirestoreFields.examId,
              isEqualTo: normalizedExamId,
            );
          },
        );

    return _mapResults(
      snapshot: snapshot,
      examId: normalizedExamId,
      status: status,
    );
  }

  Stream<List<ExamResultModel>> streamExamResults({
    required String examId,
    ExamAttemptStatus? status,
  }) async* {
    final String normalizedExamId = _examsDataValidator.validateId(examId);

    await _ensureResultsAreAvailable(examId: normalizedExamId);

    yield* _firestoreService
        .streamCollection(
          collectionPath: FirestoreCollections.examResults,
          queryBuilder: (CollectionReference<Map<String, dynamic>> collection) {
            return collection.where(
              FirestoreFields.examId,
              isEqualTo: normalizedExamId,
            );
          },
        )
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
          return _mapResults(
            snapshot: snapshot,
            examId: normalizedExamId,
            status: status,
          );
        });
  }

  Future<void> _ensureResultsAreAvailable({required String examId}) async {
    final DocumentSnapshot<Map<String, dynamic>> examSnapshot =
        await _firestoreService.getDocument(
          collectionPath: FirestoreCollections.exams,
          documentId: examId,
        );

    final ExamModel exam = _examFirestoreGuardService.requireAvailableExam(
      examSnapshot,
    );

    if (!exam.isEnded) {
      FirebaseErrorHandler.throwFirestoreCode(
        'failed-precondition',
        message: ExamFeatureMessages.resultsAvailableAfterClosing,
      );
    }
  }

  List<ExamResultModel> _mapResults({
    required QuerySnapshot<Map<String, dynamic>> snapshot,
    required String examId,
    required ExamAttemptStatus? status,
  }) {
    final List<ExamResultModel> results = snapshot.docs
        .map(ExamResultModel.fromFirestore)
        .where((ExamResultModel result) {
          if (result.examId.trim() != examId) {
            return false;
          }

          if (status != null && result.status != status) {
            return false;
          }

          return true;
        })
        .toList(growable: false);

    results.sort(_compareResults);

    return List<ExamResultModel>.unmodifiable(results);
  }

  int _compareResults(ExamResultModel first, ExamResultModel second) {
    if (first.isSubmitted != second.isSubmitted) {
      return first.isSubmitted ? -1 : 1;
    }

    if (first.isSubmitted && second.isSubmitted) {
      final int firstScore = first.score ?? 0;
      final int secondScore = second.score ?? 0;

      final int scoreComparison = secondScore.compareTo(firstScore);

      if (scoreComparison != 0) {
        return scoreComparison;
      }

      final int percentageComparison = second.percentage.compareTo(
        first.percentage,
      );

      if (percentageComparison != 0) {
        return percentageComparison;
      }
    }

    final DateTime firstDate = first.submittedAt ?? first.startedAt;

    final DateTime secondDate = second.submittedAt ?? second.startedAt;

    final int dateComparison = secondDate.compareTo(firstDate);

    if (dateComparison != 0) {
      return dateComparison;
    }

    return first.studentName.compareTo(second.studentName);
  }
}
