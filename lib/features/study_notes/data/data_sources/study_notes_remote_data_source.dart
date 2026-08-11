import 'package:alwaleed_admain/features/study_notes/data/models/study_note_model.dart';

abstract class StudyNotesRemoteDataSource {
  Future<List<StudyNoteModel>> getStudyNotes({
    String? gradeId,
    bool? isPublished,
  });

  Future<StudyNoteModel> getStudyNoteById({
    required String noteId,
  });

  Stream<List<StudyNoteModel>> streamStudyNotes({
    String? gradeId,
    bool? isPublished,
  });

  Future<void> createStudyNote({
    required StudyNoteModel note,
  });

  Future<void> updateStudyNote({
    required StudyNoteModel note,
  });

  Future<void> deleteStudyNote({
    required String noteId,
  });
}