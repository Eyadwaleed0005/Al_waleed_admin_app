import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/cache/dashboard_local_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/cache/shared_preferences_dashboard_local_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/remotely_data_base/dashboard_remote_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/remotely_data_base/firebase_dashboard_remote_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:alwaleed_admain/features/dashboard/domin/repositories/dashboard_repository.dart';
import 'package:alwaleed_admain/features/dashboard/domin/use_cases/get_dashboard_students_summary_use_case.dart';
import 'package:get_it/get_it.dart';

void registerDashboardDependencies(GetIt getIt) {
  getIt.registerLazySingleton<DashboardRemoteDataSource>(
    () => FirebaseDashboardRemoteDataSource(
      firebaseFirestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<DashboardLocalDataSource>(
    () => const SharedPreferencesDashboardLocalDataSource(),
  );

  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: getIt<DashboardRemoteDataSource>(),
      localDataSource: getIt<DashboardLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetDashboardStudentsSummaryUseCase>(
    () => GetDashboardStudentsSummaryUseCase(
      dashboardRepository: getIt<DashboardRepository>(),
    ),
  );
}
