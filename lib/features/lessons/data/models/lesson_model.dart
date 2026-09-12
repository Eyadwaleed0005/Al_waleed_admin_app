import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/features/lessons/domain/entities/lesson_entity.dart';
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
      youtubeUrl: _readNullableString(map[FirestoreFields.youtubeUrl]),
      pdfFileName: _readNullableString(map[FirestoreFields.pdfFileName]),
      pdfFileSize: _readNullablePositiveInt(map[FirestoreFields.pdfFileSize]),
      pdfStoragePath: _readNullableString(map[FirestoreFields.pdfStoragePath]),
      isPublished: _readBool(map[FirestoreFields.isPublished]),
      createdAt: _readDateTime(map[FirestoreFields.createdAt]),
      updatedAt: _readDateTime(map[FirestoreFields.updatedAt]),
    );
  }

  Map<String, dynamic> toCreateMap() {
    final map = <String, dynamic>{
      FirestoreFields.gradeId: gradeId.trim(),
      FirestoreFields.title: title.trim(),
      FirestoreFields.description: subtitle.trim(),
      FirestoreFields.youtubeUrl: youtubeUrl?.trim() ?? '',
      FirestoreFields.isPublished: isPublished,
      FirestoreFields.createdAt: FieldValue.serverTimestamp(),
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };

    _addPdfFieldsIfAvailable(map);

    return map;
  }

  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{
      FirestoreFields.gradeId: gradeId.trim(),
      FirestoreFields.title: title.trim(),
      FirestoreFields.description: subtitle.trim(),
      FirestoreFields.youtubeUrl: youtubeUrl?.trim() ?? '',
      FirestoreFields.isPublished: isPublished,
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };

    _addPdfFieldsIfAvailable(map);

    return map;
  }

  void _addPdfFieldsIfAvailable(Map<String, dynamic> map) {
    final normalizedStoragePath = pdfStoragePath?.trim();
    final normalizedFileName = pdfFileName?.trim();
    final normalizedFileSize = pdfFileSize;

    final hasValidPdf =
        normalizedStoragePath != null &&
        normalizedStoragePath.isNotEmpty &&
        normalizedFileName != null &&
        normalizedFileName.isNotEmpty &&
        normalizedFileSize != null &&
        normalizedFileSize > 0;

    if (!hasValidPdf) {
      return;
    }

    map[FirestoreFields.pdfFileName] = normalizedFileName;
    map[FirestoreFields.pdfFileSize] = normalizedFileSize;
    map[FirestoreFields.pdfStoragePath] = normalizedStoragePath;
  }

  static String _readString(dynamic value) {
    return value is String ? value.trim() : '';
  }

  static String? _readNullableString(dynamic value) {
    if (value is! String) {
      return null;
    }

    final normalizedValue = value.trim();

    return normalizedValue.isEmpty ? null : normalizedValue;
  }

  static int? _readNullablePositiveInt(dynamic value) {
    final intValue = value is int
        ? value
        : value is num
        ? value.toInt()
        : null;

    if (intValue == null || intValue <= 0) {
      return null;
    }

    return intValue;
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
