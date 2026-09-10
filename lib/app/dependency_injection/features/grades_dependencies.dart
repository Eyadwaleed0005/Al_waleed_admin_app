import 'package:alwaleed_admin/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admin/features/grades/data/data_sources/firebase_grades_remote_data_source.dart';
import 'package:alwaleed_admin/features/grades/data/data_sources/grades_remote_data_source.dart';
import 'package:alwaleed_admin/features/grades/data/repositories/grades_repository_impl.dart';
import 'package:alwaleed_admin/features/grades/domain/repositories/grades_repository.dart';
import 'package:alwaleed_admin/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:get_it/get_it.dart';

void registerGradesDependencies(GetIt getIt) {
  getIt.registerLazySingleton<GradesRemoteDataSource>(
    () => FirebaseGradesRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<GradesRepository>(
    () =>
        GradesRepositoryImpl(remoteDataSource: getIt<GradesRemoteDataSource>()),
  );

  getIt.registerLazySingleton<StreamGradesUseCase>(
    () => StreamGradesUseCase(gradesRepository: getIt<GradesRepository>()),
  );
}
