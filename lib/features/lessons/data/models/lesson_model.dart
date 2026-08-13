import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.lessonId,
    required super.gradeId,
    required super.title,
    required super.subtitle,
    required super.isPublished,
    super.youtubeUrl,
    super.pdfFileName,
    super.pdfFileSize,
    super.pdfStoragePath,
    this.createdAt,
    this.updatedAt,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory LessonModel.fromEntity(LessonEntity lesson) {
    return LessonModel(
      lessonId: lesson.lessonId,
      gradeId: lesson.gradeId,
      title: lesson.title,
      subtitle: lesson.subtitle,
      youtubeUrl: lesson.youtubeUrl,
      pdfFileName: lesson.pdfFileName,
      pdfFileSize: lesson.pdfFileSize,
      pdfStoragePath: lesson.pdfStoragePath,
      isPublished: lesson.isPublished,
    );
  }

  factory LessonModel.fromMap({
    required String documentId,
    required Map<String, dynamic> map,
  }) {
    return LessonModel(
      lessonId: documentId,
      gradeId: _readString(map[FirestoreFields.gradeId]),
      title: _readString(map[FirestoreFields.title]),
      subtitle: _readString(map[FirestoreFields.description]),
      youtubeUrl: _readString(map[FirestoreFields.youtubeUrl]),
      pdfFileName: _readString(map[FirestoreFields.pdfFileName]),
      pdfFileSize: _readInt(map[FirestoreFields.pdfFileSize]),
      pdfStoragePath: _readString(map[FirestoreFields.pdfStoragePath]),
      isPublished: _readBool(map[FirestoreFields.isPublished]),
      createdAt: _readDateTime(map[FirestoreFields.createdAt]),
      updatedAt: _readDateTime(map[FirestoreFields.updatedAt]),
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      FirestoreFields.gradeId: gradeId.trim(),
      FirestoreFields.title: title.trim(),
      FirestoreFields.description: subtitle.trim(),
      FirestoreFields.youtubeUrl: youtubeUrl?.trim() ?? '',
      FirestoreFields.pdfFileName: pdfFileName?.trim() ?? '',
      FirestoreFields.pdfFileSize: pdfFileSize ?? 0,
      FirestoreFields.pdfStoragePath: pdfStoragePath?.trim() ?? '',
      FirestoreFields.isPublished: isPublished,
      FirestoreFields.createdAt: FieldValue.serverTimestamp(),
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      FirestoreFields.gradeId: gradeId.trim(),
      FirestoreFields.title: title.trim(),
      FirestoreFields.description: subtitle.trim(),
      FirestoreFields.youtubeUrl: youtubeUrl?.trim() ?? '',
      FirestoreFields.pdfFileName: pdfFileName?.trim() ?? '',
      FirestoreFields.pdfFileSize: pdfFileSize ?? 0,
      FirestoreFields.pdfStoragePath: pdfStoragePath?.trim() ?? '',
      FirestoreFields.isPublished: isPublished,
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  static String _readString(dynamic value) {
    return value is String ? value.trim() : '';
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return 0;
  }

  static bool _readBool(dynamic value) {
    return value is bool ? value : false;
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
