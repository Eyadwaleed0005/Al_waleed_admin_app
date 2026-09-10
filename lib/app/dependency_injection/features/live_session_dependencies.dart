import 'package:alwaleed_admin/core/connection/network/network_info.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admin/features/live_session/data/data_source/firebase_live_sessions_remote_data_source.dart';
import 'package:alwaleed_admin/features/live_session/data/data_source/live_sessions_remote_data_source.dart';
import 'package:alwaleed_admin/features/live_session/data/repository/live_sessions_repository_impl.dart';
import 'package:alwaleed_admin/features/live_session/domain/repository/live_sessions_repository.dart';
import 'package:alwaleed_admin/features/live_session/domain/use_case/delete_live_session_use_case.dart';
import 'package:alwaleed_admin/features/live_session/domain/use_case/get_live_session_use_case.dart';
import 'package:alwaleed_admin/features/live_session/domain/use_case/save_live_session_use_case.dart';
import 'package:get_it/get_it.dart';

void registerLiveSessionDependencies(GetIt getIt) {
  getIt.registerLazySingleton<LiveSessionsRemoteDataSource>(
    () => FirebaseLiveSessionsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<LiveSessionsRepository>(
    () => LiveSessionsRepositoryImpl(
      remoteDataSource: getIt<LiveSessionsRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetLiveSessionUseCase>(
    () => GetLiveSessionUseCase(repository: getIt<LiveSessionsRepository>()),
  );

  getIt.registerLazySingleton<SaveLiveSessionUseCase>(
    () => SaveLiveSessionUseCase(repository: getIt<LiveSessionsRepository>()),
  );

  getIt.registerLazySingleton<DeleteLiveSessionUseCase>(
    () => DeleteLiveSessionUseCase(repository: getIt<LiveSessionsRepository>()),
  );
}
