import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/storage/storage_service.dart';
import 'package:alwaleed_admain/features/lessons/data/data_sources/firebase_lessons_remote_data_source.dart';
import 'package:alwaleed_admain/features/lessons/data/data_sources/lessons_remote_data_source.dart';
import 'package:alwaleed_admain/features/lessons/data/repositories/lessons_repository_impl.dart';
import 'package:alwaleed_admain/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/create_lesson_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/delete_lesson_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/get_lesson_by_id_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/get_lessons_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/stream_lessons_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/update_lesson_use_case.dart';
import 'package:get_it/get_it.dart';

void registerLessonsDependencies(GetIt getIt) {
  getIt.registerLazySingleton<LessonsRemoteDataSource>(
    () => FirebaseLessonsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
      storageService: getIt<StorageService>(),
    ),
  );

  getIt.registerLazySingleton<LessonsRepository>(
    () => LessonsRepositoryImpl(
      remoteDataSource: getIt<LessonsRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetLessonsUseCase>(
    () => GetLessonsUseCase(repository: getIt<LessonsRepository>()),
  );

  getIt.registerLazySingleton<GetLessonByIdUseCase>(
    () => GetLessonByIdUseCase(repository: getIt<LessonsRepository>()),
  );

  getIt.registerLazySingleton<StreamLessonsUseCase>(
    () => StreamLessonsUseCase(repository: getIt<LessonsRepository>()),
  );

  getIt.registerLazySingleton<CreateLessonUseCase>(
    () => CreateLessonUseCase(repository: getIt<LessonsRepository>()),
  );

  getIt.registerLazySingleton<UpdateLessonUseCase>(
    () => UpdateLessonUseCase(repository: getIt<LessonsRepository>()),
  );

  getIt.registerLazySingleton<DeleteLessonUseCase>(
    () => DeleteLessonUseCase(repository: getIt<LessonsRepository>()),
  );
}
