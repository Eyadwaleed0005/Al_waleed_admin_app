import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_attempt_status.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_result_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamResultModel extends ExamResultEntity {
  const ExamResultModel({
    required super.resultId,
    required super.examId,
    required super.studentId,
    required super.studentName,
    required super.gradeId,
    required super.gradeName,
    required super.totalScore,
    required super.status,
    required super.startedAt,
    required super.expiresAt,
    super.score,
    super.submittedAt,
  });

  factory ExamResultModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final Map<String, dynamic> data =
        document.data() ?? <String, dynamic>{};

    return ExamResultModel.fromMap(
      resultId: document.id,
      data: data,
    );
  }

  factory ExamResultModel.fromMap({
    required String resultId,
    required Map<String, dynamic> data,
  }) {
    final int? score = _readNullableInt(
      data[FirestoreFields.score] ??
          data[FirestoreFields.studentScore],
    );

    final DateTime? submittedAt = _readDateTime(
      data[FirestoreFields.submittedAt],
    );

    return ExamResultModel(
      resultId: resultId,
      examId: _readString(
        data[FirestoreFields.examId],
      ),
      studentId: _readString(
        data[FirestoreFields.studentId],
      ),
      studentName: _readString(
        data[FirestoreFields.studentName],
      ),
      gradeId: _readString(
        data[FirestoreFields.gradeId],
      ),
      gradeName: _readString(
        data[FirestoreFields.gradeName],
      ),
      score: score,
      totalScore: _readInt(
        data[FirestoreFields.totalScore],
      ),
      status: statusFromJson(
        data[FirestoreFields.resultStatus],
        score: score,
        submittedAt: submittedAt,
      ),
      startedAt: _readRequiredDateTime(
        data[FirestoreFields.startedAt],
        fieldName: FirestoreFields.startedAt,
      ),
      expiresAt: _readRequiredDateTime(
        data[FirestoreFields.expiresAt],
        fieldName: FirestoreFields.expiresAt,
      ),
      submittedAt: submittedAt,
    );
  }

  factory ExamResultModel.fromEntity(
    ExamResultEntity entity,
  ) {
    return ExamResultModel(
      resultId: entity.resultId,
      examId: entity.examId,
      studentId: entity.studentId,
      studentName: entity.studentName,
      gradeId: entity.gradeId,
      gradeName: entity.gradeName,
      score: entity.score,
      totalScore: entity.totalScore,
      status: entity.status,
      startedAt: entity.startedAt,
      expiresAt: entity.expiresAt,
      submittedAt: entity.submittedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirestoreFields.examId: examId.trim(),
      FirestoreFields.studentId: studentId.trim(),
      FirestoreFields.studentName: studentName.trim(),
      FirestoreFields.gradeId: gradeId.trim(),
      FirestoreFields.gradeName: gradeName.trim(),
      FirestoreFields.score: score,
      FirestoreFields.totalScore: totalScore,
      FirestoreFields.resultStatus: statusToJson(status),
      FirestoreFields.startedAt: Timestamp.fromDate(
        startedAt,
      ),
      FirestoreFields.expiresAt: Timestamp.fromDate(
        expiresAt,
      ),
      FirestoreFields.submittedAt: submittedAt == null
          ? null
          : Timestamp.fromDate(submittedAt!),
    };
  }

  ExamResultEntity toEntity() {
    return ExamResultEntity(
      resultId: resultId,
      examId: examId,
      studentId: studentId,
      studentName: studentName,
      gradeId: gradeId,
      gradeName: gradeName,
      score: score,
      totalScore: totalScore,
      status: status,
      startedAt: startedAt,
      expiresAt: expiresAt,
      submittedAt: submittedAt,
    );
  }

  static ExamAttemptStatus statusFromJson(
    dynamic value, {
    int? score,
    DateTime? submittedAt,
  }) {
    final String normalizedValue =
        value?.toString().trim().toLowerCase() ?? '';

    if (normalizedValue == 'submitted' ||
        submittedAt != null ||
        score != null) {
      return ExamAttemptStatus.submitted;
    }

    return ExamAttemptStatus.inProgress;
  }

  static String statusToJson(
    ExamAttemptStatus status,
  ) {
    return switch (status) {
      ExamAttemptStatus.inProgress => 'inProgress',
      ExamAttemptStatus.submitted => 'submitted',
    };
  }

  static String createResultId({
    required String examId,
    required String studentId,
  }) {
    return '${examId.trim()}_${studentId.trim()}';
  }

  static String _readString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static int _readInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static int? _readNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  static DateTime _readRequiredDateTime(
    dynamic value, {
    required String fieldName,
  }) {
    final DateTime? dateTime = _readDateTime(value);

    if (dateTime == null) {
      throw FormatException(
        'Invalid or missing $fieldName.',
      );
    }

    return dateTime;
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}