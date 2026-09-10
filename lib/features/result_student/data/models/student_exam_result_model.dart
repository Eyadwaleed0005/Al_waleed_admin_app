import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/features/result_student/domain/entities/student_exam_result_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentExamResultModel extends StudentExamResultEntity {
  const StudentExamResultModel({
    required super.resultId,
    required super.examId,
    required super.examName,
    required super.studentObtainedScore,
    required super.examTotalScore,
    required super.examSubmittedAt,
  });

  factory StudentExamResultModel.fromFirestoreDocument({
    required DocumentSnapshot<Map<String, dynamic>> resultDocument,
    required String examName,
  }) {
    final Map<String, dynamic> resultData =
        resultDocument.data() ?? <String, dynamic>{};

    final Timestamp examSubmittedAtTimestamp =
        resultData[FirestoreFields.submittedAt] as Timestamp;

    return StudentExamResultModel(
      resultId:
          resultData[FirestoreFields.resultId] as String? ?? resultDocument.id,
      examId: resultData[FirestoreFields.examId] as String,
      examName: examName,
      studentObtainedScore: (resultData[FirestoreFields.score] as num)
          .toDouble(),
      examTotalScore: (resultData[FirestoreFields.totalScore] as num)
          .toDouble(),
      examSubmittedAt: examSubmittedAtTimestamp.toDate(),
    );
  }
}
