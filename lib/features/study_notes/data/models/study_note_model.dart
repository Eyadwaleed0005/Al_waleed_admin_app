import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudyNoteModel extends StudyNoteEntity {
  const StudyNoteModel({
    required super.noteId,
    required super.name,
    required super.description,
    required super.gradeId,
    required super.isPublished,
    required super.pdfStoragePath,
    required super.pdfFileName,
    required super.pdfFileSize,
    super.createdAt,
    super.updatedAt,
  });

  factory StudyNoteModel.fromMap({
    required String documentId,
    required Map<String, dynamic> map,
  }) {
    return StudyNoteModel(
      noteId: documentId,
      name: map[FirestoreFields.name] as String? ?? '',
      description:
          map[FirestoreFields.description] as String? ?? '',
      gradeId: map[FirestoreFields.gradeId] as String? ?? '',
      isPublished:
          map[FirestoreFields.isPublished] as bool? ?? false,
      pdfStoragePath:
          map[FirestoreFields.pdfStoragePath] as String? ?? '',
      pdfFileName:
          map[FirestoreFields.pdfFileName] as String? ?? '',
      pdfFileSize: _readFileSize(
        map[FirestoreFields.pdfFileSize],
      ),
      createdAt: _readDateTime(
        map[FirestoreFields.createdAt],
      ),
      updatedAt: _readDateTime(
        map[FirestoreFields.updatedAt],
      ),
    );
  }

  factory StudyNoteModel.fromEntity(
    StudyNoteEntity entity,
  ) {
    return StudyNoteModel(
      noteId: entity.noteId,
      name: entity.name,
      description: entity.description,
      gradeId: entity.gradeId,
      isPublished: entity.isPublished,
      pdfStoragePath: entity.pdfStoragePath,
      pdfFileName: entity.pdfFileName,
      pdfFileSize: entity.pdfFileSize,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      FirestoreFields.name: name.trim(),
      FirestoreFields.description: description.trim(),
      FirestoreFields.gradeId: gradeId.trim(),
      FirestoreFields.isPublished: isPublished,
      FirestoreFields.pdfStoragePath: pdfStoragePath.trim(),
      FirestoreFields.pdfFileName: pdfFileName.trim(),
      FirestoreFields.pdfFileSize: pdfFileSize,
      FirestoreFields.createdAt: FieldValue.serverTimestamp(),
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      FirestoreFields.name: name.trim(),
      FirestoreFields.description: description.trim(),
      FirestoreFields.gradeId: gradeId.trim(),
      FirestoreFields.isPublished: isPublished,
      FirestoreFields.pdfStoragePath: pdfStoragePath.trim(),
      FirestoreFields.pdfFileName: pdfFileName.trim(),
      FirestoreFields.pdfFileSize: pdfFileSize,
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  static int _readFileSize(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return 0;
  }

  static DateTime? _readDateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate().toUtc();
    }

    if (value is DateTime) {
      return value.toUtc();
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(
        value,
        isUtc: true,
      );
    }

    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        value.toInt(),
        isUtc: true,
      );
    }

    if (value is String) {
      return DateTime.tryParse(value)?.toUtc();
    }

    return null;
  }
}