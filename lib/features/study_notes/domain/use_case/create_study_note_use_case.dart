import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:alwaleed_admain/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:dartz/dartz.dart';

class CreateStudyNoteUseCase {
  const CreateStudyNoteUseCase({required StudyNotesRepository repository})
    : _repository = repository;

  final StudyNotesRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required StudyNoteEntity note,
    required String localPdfFilePath,
  }) {
    return _repository.createStudyNote(
      note: note,
      localPdfFilePath: localPdfFilePath,
    );
  }
}
