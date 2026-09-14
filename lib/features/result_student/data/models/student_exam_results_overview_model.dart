import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/student_exam_results_overview_entity.dart';
import 'student_exam_result_model.dart';

class StudentExamResultsOverviewModel extends StudentExamResultsOverviewEntity {
  const StudentExamResultsOverviewModel({
    required super.studentId,
    required super.studentFullName,
    required super.studentGradeId,
    required super.studentGradeName,
    required super.isStudentAccountActive,
    required super.completedExamsCount,
    required super.totalExamsCount,
    required super.studentExamResults,
  });

  factory StudentExamResultsOverviewModel.fromFirestoreStudentDocument({
    required DocumentSnapshot<Map<String, dynamic>> studentDocument,
    required String studentGradeName,
    required int completedExamsCount,
    required int totalExamsCount,
    required List<StudentExamResultModel> studentExamResultModels,
  }) {
    final Map<String, dynamic> studentData =
        studentDocument.data() ?? <String, dynamic>{};

    return StudentExamResultsOverviewModel(
      studentId:
          studentData[FirestoreFields.studentId] as String? ??
          studentDocument.id,
      studentFullName: studentData[FirestoreFields.name] as String,
      studentGradeId: studentData[FirestoreFields.gradeId] as String,
      studentGradeName: studentGradeName,
      isStudentAccountActive:
          studentData[FirestoreFields.isActive] as bool? ?? false,
      completedExamsCount: completedExamsCount,
      totalExamsCount: totalExamsCount,
      studentExamResults: List.unmodifiable(studentExamResultModels),
    );
  }
}