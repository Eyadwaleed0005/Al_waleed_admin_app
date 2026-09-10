import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamModel extends ExamEntity {
  const ExamModel({
    required super.examId,
    required super.gradeId,
    required super.examName,
    required super.durationMinutes,
    required super.questionCount,
    required super.totalScore,
    required super.status,
    super.participantsCount = 0,
    super.questions = const [],
    super.firstAttemptAt,
    super.closedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory ExamModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final Map<String, dynamic> data = document.data() ?? <String, dynamic>{};

    return ExamModel.fromMap(examId: document.id, data: data);
  }

  factory ExamModel.fromMap({
    required String examId,
    required Map<String, dynamic> data,
  }) {
    return ExamModel(
      examId: examId,
      gradeId: _readString(data[FirestoreFields.gradeId]),
      examName: _readString(data[FirestoreFields.examName]),
      durationMinutes: _readInt(data[FirestoreFields.durationMinutes]),
      questionCount: _readInt(data[FirestoreFields.questionCount]),
      totalScore: _readInt(data[FirestoreFields.totalScore]),
      participantsCount: _readInt(data[FirestoreFields.participantsCount]),
      status: statusFromJson(data[FirestoreFields.examStatus]),
      firstAttemptAt: _readDateTime(data[FirestoreFields.firstAttemptAt]),
      closedAt: _readDateTime(data[FirestoreFields.closedAt]),
      createdAt: _readDateTime(data[FirestoreFields.createdAt]),
      updatedAt: _readDateTime(data[FirestoreFields.updatedAt]),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirestoreFields.gradeId: gradeId,
      FirestoreFields.examName: examName,
      FirestoreFields.durationMinutes: durationMinutes,
      FirestoreFields.questionCount: questionCount,
      FirestoreFields.totalScore: totalScore,
      FirestoreFields.participantsCount: participantsCount,
      FirestoreFields.examStatus: statusToJson(status),
      FirestoreFields.firstAttemptAt: firstAttemptAt == null
          ? null
          : Timestamp.fromDate(firstAttemptAt!),
      FirestoreFields.closedAt: closedAt == null
          ? null
          : Timestamp.fromDate(closedAt!),
      FirestoreFields.createdAt: createdAt == null
          ? null
          : Timestamp.fromDate(createdAt!),
      FirestoreFields.updatedAt: updatedAt == null
          ? null
          : Timestamp.fromDate(updatedAt!),
    };
  }

  ExamEntity toEntity() {
    return ExamEntity(
      examId: examId,
      gradeId: gradeId,
      examName: examName,
      durationMinutes: durationMinutes,
      questionCount: questionCount,
      totalScore: totalScore,
      participantsCount: participantsCount,
      status: status,
      questions: List.unmodifiable(questions),
      firstAttemptAt: firstAttemptAt,
      closedAt: closedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ExamStatus statusFromJson(dynamic value) {
    return switch (value?.toString().trim().toLowerCase()) {
      'published' => ExamStatus.published,
      'ended' => ExamStatus.ended,
      _ => ExamStatus.unpublished,
    };
  }

  static String statusToJson(ExamStatus status) {
    return switch (status) {
      ExamStatus.unpublished => 'unpublished',
      ExamStatus.published => 'published',
      ExamStatus.ended => 'ended',
    };
  }

  static String _readString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static int _readInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
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
