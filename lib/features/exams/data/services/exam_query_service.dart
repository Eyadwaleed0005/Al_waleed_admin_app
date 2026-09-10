import 'package:alwaleed_admin/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admin/features/exams/data/services/exam_firestore_guard_service.dart';
import 'package:alwaleed_admin/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamQueryService {
  const ExamQueryService({
    required this._firestoreService,
    required this._examsDataValidator,
    required this._examFirestoreGuardService,
  });

  final FirestoreService _firestoreService;
  final ExamsDataValidator _examsDataValidator;
  final ExamFirestoreGuardService _examFirestoreGuardService;

  Future<List<ExamModel>> getExams({
    String? gradeId,
    ExamStatus? status,
  }) async {
    final String? normalizedGradeId = _normalizeGradeId(gradeId);

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestoreService.getCollection(
          collectionPath: FirestoreCollections.exams,
          queryBuilder: _buildExamsQuery(
            gradeId: normalizedGradeId,
            status: status,
          ),
        );

    return _mapExams(snapshot);
  }

  Stream<List<ExamModel>> streamExams({
    String? gradeId,
    ExamStatus? status,
  }) {
    final String? normalizedGradeId = _normalizeGradeId(gradeId);

    return _firestoreService
        .streamCollection(
          collectionPath: FirestoreCollections.exams,
          queryBuilder: _buildExamsQuery(
            gradeId: normalizedGradeId,
            status: status,
          ),
        )
        .map(_mapExams);
  }

  Future<ExamModel> getExamById({
    required String examId,
  }) async {
    final String normalizedExamId = _examsDataValidator.validateId(examId);

    final DocumentSnapshot<Map<String, dynamic>> examSnapshot =
        await _firestoreService.getDocument(
          collectionPath: FirestoreCollections.exams,
          documentId: normalizedExamId,
        );

    final ExamModel exam = _examFirestoreGuardService.requireAvailableExam(
      examSnapshot,
    );

    final QuerySnapshot<Map<String, dynamic>> questionsSnapshot =
        await _firestoreService.getCollection(
          collectionPath: FirestoreCollections.examQuestions,
          queryBuilder: (
            CollectionReference<Map<String, dynamic>> collection,
          ) {
            return collection.where(
              FirestoreFields.examId,
              isEqualTo: normalizedExamId,
            );
          },
        );

    final List<ExamQuestionModel> questions = questionsSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
          return _examFirestoreGuardService.requireExamQuestion(
            document,
            examId: normalizedExamId,
          );
        })
        .toList(growable: false);

    questions.sort(_compareQuestions);

    return ExamModel(
      examId: exam.examId,
      gradeId: exam.gradeId,
      examName: exam.examName,
      durationMinutes: exam.durationMinutes,
      questionCount: exam.questionCount,
      totalScore: exam.totalScore,
      status: exam.status,
      questions: List<ExamQuestionModel>.unmodifiable(questions),
      firstAttemptAt: exam.firstAttemptAt,
      closedAt: exam.closedAt,
      createdAt: exam.createdAt,
      updatedAt: exam.updatedAt,
    );
  }

  FirestoreQueryBuilder _buildExamsQuery({
    required String? gradeId,
    required ExamStatus? status,
  }) {
    return (
      CollectionReference<Map<String, dynamic>> collection,
    ) {
      Query<Map<String, dynamic>> query = collection;

      if (gradeId != null) {
        query = query.where(
          FirestoreFields.gradeId,
          isEqualTo: gradeId,
        );
      }

      if (status != null) {
        query = query.where(
          FirestoreFields.examStatus,
          isEqualTo: ExamModel.statusToJson(status),
        );
      }

      return query;
    };
  }

  List<ExamModel> _mapExams(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final List<ExamModel> exams = snapshot.docs
        .where((QueryDocumentSnapshot<Map<String, dynamic>> document) {
          final Map<String, dynamic> data = document.data();

          return data[FirestoreFields.isDeleting] != true;
        })
        .map(ExamModel.fromFirestore)
        .toList(growable: false);

    exams.sort(_compareExams);

    return List<ExamModel>.unmodifiable(exams);
  }

  String? _normalizeGradeId(String? gradeId) {
    final String normalizedGradeId = gradeId?.trim() ?? '';

    if (normalizedGradeId.isEmpty) {
      return null;
    }

    return _examsDataValidator.validateId(normalizedGradeId);
  }

  int _compareExams(
    ExamModel first,
    ExamModel second,
  ) {
    final DateTime? firstDate = first.updatedAt ?? first.createdAt;
    final DateTime? secondDate = second.updatedAt ?? second.createdAt;

    if (firstDate == null && secondDate == null) {
      return first.examId.compareTo(second.examId);
    }

    if (firstDate == null) {
      return 1;
    }

    if (secondDate == null) {
      return -1;
    }

    final int dateComparison = secondDate.compareTo(firstDate);

    if (dateComparison != 0) {
      return dateComparison;
    }

    return first.examId.compareTo(second.examId);
  }

  int _compareQuestions(
    ExamQuestionModel first,
    ExamQuestionModel second,
  ) {
    final DateTime? firstDate = first.createdAt ?? first.updatedAt;
    final DateTime? secondDate = second.createdAt ?? second.updatedAt;

    if (firstDate == null && secondDate == null) {
      return first.questionId.compareTo(second.questionId);
    }

    if (firstDate == null) {
      return 1;
    }

    if (secondDate == null) {
      return -1;
    }

    final int dateComparison = firstDate.compareTo(secondDate);

    if (dateComparison != 0) {
      return dateComparison;
    }

    return first.questionId.compareTo(second.questionId);
  }
}