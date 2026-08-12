import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';

class CreateStudyNoteParams {
  const CreateStudyNoteParams({
    required this.note,
    required this.localPdfFilePath,
  });

  final StudyNoteEntity note;
  final String localPdfFilePath;
}
