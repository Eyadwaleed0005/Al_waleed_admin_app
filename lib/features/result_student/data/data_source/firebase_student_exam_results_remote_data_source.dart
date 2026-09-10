import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student_exam_result_model.dart';
import '../models/student_exam_results_overview_model.dart';
import 'student_exam_results_remote_data_source.dart';

class FirebaseStudentExamResultsRemoteDataSource
    implements StudentExamResultsRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  const FirebaseStudentExamResultsRemoteDataSource({
    required this.firebaseFirestore,
  });

  @override
  Future<StudentExamResultsOverviewModel> getStudentExamResultsByStudentId({
    required String studentId,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final String normalizedStudentId = studentId.trim();

      if (normalizedStudentId.isEmpty) {
        FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
      }

      final DocumentSnapshot<Map<String, dynamic>> studentDocument =
          await firebaseFirestore
              .collection(FirestoreCollections.students)
              .doc(normalizedStudentId)
              .get();

      if (!studentDocument.exists || studentDocument.data() == null) {
        FirebaseErrorHandler.throwFirestoreCode('not-found');
      }

      final Map<String, dynamic> studentData = studentDocument.data()!;

      final String studentGradeId = _readRequiredString(
        data: studentData,
        fieldName: FirestoreFields.gradeId,
      );

      final Future<DocumentSnapshot<Map<String, dynamic>>>
      studentGradeDocumentFuture = firebaseFirestore
          .collection(FirestoreCollections.grades)
          .doc(studentGradeId)
          .get();

      final Future<QuerySnapshot<Map<String, dynamic>>>
      studentExamResultsSnapshotFuture = firebaseFirestore
          .collection(FirestoreCollections.examResults)
          .where(FirestoreFields.studentId, isEqualTo: normalizedStudentId)
          .get();

      final DocumentSnapshot<Map<String, dynamic>> studentGradeDocument =
          await studentGradeDocumentFuture;

      final QuerySnapshot<Map<String, dynamic>> studentExamResultsSnapshot =
          await studentExamResultsSnapshotFuture;

      if (!studentGradeDocument.exists || studentGradeDocument.data() == null) {
        FirebaseErrorHandler.throwFirestoreCode('not-found');
      }

      final String studentGradeName = _readRequiredString(
        data: studentGradeDocument.data()!,
        fieldName: FirestoreFields.name,
      );

      final List<QueryDocumentSnapshot<Map<String, dynamic>>>
      submittedExamResultDocuments = studentExamResultsSnapshot.docs
          .where(
            (resultDocument) =>
                resultDocument.data()[FirestoreFields.submittedAt] is Timestamp,
          )
          .toList();

      final Set<String> examIds = submittedExamResultDocuments
          .map(
            (resultDocument) => _readRequiredString(
              data: resultDocument.data(),
              fieldName: FirestoreFields.examId,
            ),
          )
          .toSet();

      final List<DocumentSnapshot<Map<String, dynamic>>> examDocuments =
          await Future.wait(
            examIds.map((examId) {
              return firebaseFirestore
                  .collection(FirestoreCollections.exams)
                  .doc(examId)
                  .get();
            }),
          );

      final Map<String, String> examNamesByExamId = {};

      for (final DocumentSnapshot<Map<String, dynamic>> examDocument
          in examDocuments) {
        if (!examDocument.exists || examDocument.data() == null) {
          FirebaseErrorHandler.throwFirestoreCode('not-found');
        }

        examNamesByExamId[examDocument.id] = _readRequiredString(
          data: examDocument.data()!,
          fieldName: FirestoreFields.examName,
        );
      }

      final List<StudentExamResultModel> studentExamResultModels =
          submittedExamResultDocuments.map((resultDocument) {
            final String examId = _readRequiredString(
              data: resultDocument.data(),
              fieldName: FirestoreFields.examId,
            );

            final String? examName = examNamesByExamId[examId];

            if (examName == null || examName.trim().isEmpty) {
              FirebaseErrorHandler.throwFirestoreCode('data-loss');
            }

            return StudentExamResultModel.fromFirestoreDocument(
              resultDocument: resultDocument,
              examName: examName,
            );
          }).toList();

      studentExamResultModels.sort((firstResult, secondResult) {
        return secondResult.examSubmittedAt.compareTo(
          firstResult.examSubmittedAt,
        );
      });

      return StudentExamResultsOverviewModel.fromFirestoreStudentDocument(
        studentDocument: studentDocument,
        studentGradeName: studentGradeName,
        studentExamResultModels: studentExamResultModels,
      );
    });
  }

  String _readRequiredString({
    required Map<String, dynamic> data,
    required String fieldName,
  }) {
    final Object? fieldValue = data[fieldName];

    if (fieldValue is! String || fieldValue.trim().isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('data-loss');
    }

    return fieldValue.trim();
  }
}
