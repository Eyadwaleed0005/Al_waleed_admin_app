import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_service.dart';
import 'package:alwaleed_admain/features/study_notes/data/data_sources/firebase_study_notes_remote_data_source.dart';
import 'package:alwaleed_admain/features/study_notes/data/data_sources/study_notes_remote_data_source.dart';
import 'package:alwaleed_admain/features/study_notes/data/repositories/study_notes_repository_impl.dart';
import 'package:alwaleed_admain/features/study_notes/domain/repositories/study_notes_repository.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/create_study_note_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/delete_study_note_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/get_study_note_by_id_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/get_study_notes_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/update_study_note_use_case.dart';
import 'package:get_it/get_it.dart';

void registerStudyNotesDependencies(GetIt getIt) {
  getIt.registerLazySingleton<StudyNotesRemoteDataSource>(
    () => FirebaseStudyNotesRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
      storageService: getIt<StorageService>(),
    ),
  );

  getIt.registerLazySingleton<StudyNotesRepository>(
    () => StudyNotesRepositoryImpl(
      remoteDataSource: getIt<StudyNotesRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetStudyNotesUseCase>(
    () => GetStudyNotesUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<GetStudyNoteByIdUseCase>(
    () => GetStudyNoteByIdUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<StreamStudyNotesUseCase>(
    () => StreamStudyNotesUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<CreateStudyNoteUseCase>(
    () => CreateStudyNoteUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<UpdateStudyNoteUseCase>(
    () => UpdateStudyNoteUseCase(repository: getIt<StudyNotesRepository>()),
  );

  getIt.registerLazySingleton<DeleteStudyNoteUseCase>(
    () => DeleteStudyNoteUseCase(repository: getIt<StudyNotesRepository>()),
  );
}
