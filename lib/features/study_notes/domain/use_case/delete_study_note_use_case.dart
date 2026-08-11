import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteStudyNoteUseCase {
  const DeleteStudyNoteUseCase({
    required StudyNotesRepository repository,
  }) : _repository = repository;

  final StudyNotesRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required String noteId,
  }) {
    return _repository.deleteStudyNote(
      noteId: noteId,
    );
  }
}