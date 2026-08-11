import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';

class StudyNoteModel extends StudyNoteEntity {
  const StudyNoteModel({
    required super.noteId,
    required super.name,
    required super.description,
    required super.gradeId,
    required super.isPublished,
  });

  factory StudyNoteModel.fromMap({
    required String documentId,
    required Map<String, dynamic> map,
  }) {
    return StudyNoteModel(
      noteId: documentId,
      name: map[FirestoreFields.name] as String? ?? '',
      description: map[FirestoreFields.description] as String? ?? '',
      gradeId: map[FirestoreFields.gradeId] as String? ?? '',
      isPublished: map[FirestoreFields.isPublished] as bool? ?? false,
    );
  }

  factory StudyNoteModel.fromEntity(StudyNoteEntity entity) {
    return StudyNoteModel(
      noteId: entity.noteId,
      name: entity.name,
      description: entity.description,
      gradeId: entity.gradeId,
      isPublished: entity.isPublished,
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      FirestoreFields.name: name.trim(),
      FirestoreFields.description: description.trim(),
      FirestoreFields.gradeId: gradeId.trim(),
      FirestoreFields.isPublished: isPublished,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      FirestoreFields.name: name.trim(),
      FirestoreFields.description: description.trim(),
      FirestoreFields.gradeId: gradeId.trim(),
      FirestoreFields.isPublished: isPublished,
    };
  }
}
