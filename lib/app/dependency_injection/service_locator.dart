import 'package:alwaleed_admain/core/connection/network/internet_connection_network_info.dart';
import 'package:alwaleed_admain/core/connection/network/network_info.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/cache/dashboard_local_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/cache/shared_preferences_dashboard_local_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/remotely_data_base/dashboard_remote_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/remotely_data_base/firebase_dashboard_remote_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:alwaleed_admain/features/dashboard/domin/repositories/dashboard_repository.dart';
import 'package:alwaleed_admain/features/dashboard/domin/use_cases/get_dashboard_students_summary_use_case.dart';
import 'package:alwaleed_admain/features/grades/data/data_sources/firebase_grades_remote_data_source.dart';
import 'package:alwaleed_admain/features/grades/data/data_sources/grades_remote_data_source.dart';
import 'package:alwaleed_admain/features/grades/data/repositories/grades_repository_impl.dart';
import 'package:alwaleed_admain/features/grades/domain/repositories/grades_repository.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/students/data/data_sources/auth/firebase_student_auth_remote_data_source.dart';
import 'package:alwaleed_admain/features/students/data/data_sources/auth/student_auth_remote_data_source.dart';
import 'package:alwaleed_admain/features/students/data/data_sources/firestore/firebase_students_remote_data_source.dart';
import 'package:alwaleed_admain/features/students/data/data_sources/firestore/students_remote_data_source.dart';
import 'package:alwaleed_admain/features/students/data/repositories/student_auth_repository_impl.dart';
import 'package:alwaleed_admain/features/students/data/repositories/students_repository_impl.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/student_auth_repository.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/create_student_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/delete_student_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/get_student_by_id_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/get_students_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/stream_students_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_email_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_password_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_profile_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_status_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_subscription_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Firebase instances

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<FirebaseFunctions>(
    () => FirebaseFunctions.instanceFor(region: 'us-central1'),
  );

  // Core services

  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );

  // Students remote data sources

  getIt.registerLazySingleton<StudentsRemoteDataSource>(
    () => FirebaseStudentsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<StudentAuthRemoteDataSource>(
    () => FirebaseStudentAuthRemoteDataSource(
      firebaseFunctions: getIt<FirebaseFunctions>(),
    ),
  );

  // Students repositories

  getIt.registerLazySingleton<StudentsRepository>(
    () => StudentsRepositoryImpl(
      remoteDataSource: getIt<StudentsRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<StudentAuthRepository>(
    () => StudentAuthRepositoryImpl(
      remoteDataSource: getIt<StudentAuthRemoteDataSource>(),
    ),
  );

  // Students use cases

  getIt.registerLazySingleton<CreateStudentUseCase>(
    () => CreateStudentUseCase(
      studentAuthRepository: getIt<StudentAuthRepository>(),
      studentsRepository: getIt<StudentsRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetStudentsUseCase>(
    () => GetStudentsUseCase(studentsRepository: getIt<StudentsRepository>()),
  );

  getIt.registerLazySingleton<GetStudentByIdUseCase>(
    () =>
        GetStudentByIdUseCase(studentsRepository: getIt<StudentsRepository>()),
  );

  getIt.registerLazySingleton<StreamStudentsUseCase>(
    () =>
        StreamStudentsUseCase(studentsRepository: getIt<StudentsRepository>()),
  );

  getIt.registerLazySingleton<UpdateStudentProfileUseCase>(
    () => UpdateStudentProfileUseCase(
      studentsRepository: getIt<StudentsRepository>(),
    ),
  );

  getIt.registerLazySingleton<UpdateStudentEmailUseCase>(
    () => UpdateStudentEmailUseCase(
      studentAuthRepository: getIt<StudentAuthRepository>(),
      studentsRepository: getIt<StudentsRepository>(),
    ),
  );

  getIt.registerLazySingleton<UpdateStudentPasswordUseCase>(
    () => UpdateStudentPasswordUseCase(
      studentAuthRepository: getIt<StudentAuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<UpdateStudentStatusUseCase>(
    () => UpdateStudentStatusUseCase(
      studentAuthRepository: getIt<StudentAuthRepository>(),
      studentsRepository: getIt<StudentsRepository>(),
    ),
  );

  getIt.registerLazySingleton<UpdateStudentSubscriptionUseCase>(
    () => UpdateStudentSubscriptionUseCase(
      studentAuthRepository: getIt<StudentAuthRepository>(),
      studentsRepository: getIt<StudentsRepository>(),
    ),
  );

  getIt.registerLazySingleton<DeleteStudentUseCase>(
    () => DeleteStudentUseCase(
      studentAuthRepository: getIt<StudentAuthRepository>(),
      studentsRepository: getIt<StudentsRepository>(),
    ),
  );

  // Grades remote data source

  getIt.registerLazySingleton<GradesRemoteDataSource>(
    () => FirebaseGradesRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  // Grades repository

  getIt.registerLazySingleton<GradesRepository>(
    () =>
        GradesRepositoryImpl(remoteDataSource: getIt<GradesRemoteDataSource>()),
  );

  // Grades use cases

  getIt.registerLazySingleton<StreamGradesUseCase>(
    () => StreamGradesUseCase(gradesRepository: getIt<GradesRepository>()),
  );

  // Dashboard remote data source

  getIt.registerLazySingleton<DashboardRemoteDataSource>(
    () => FirebaseDashboardRemoteDataSource(
      firebaseFirestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Dashboard repository

  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: getIt<DashboardRemoteDataSource>(),
      localDataSource: getIt<DashboardLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<DashboardLocalDataSource>(
    () => const SharedPreferencesDashboardLocalDataSource(),
  );

  // Dashboard use cases

  getIt.registerLazySingleton<GetDashboardStudentsSummaryUseCase>(
    () => GetDashboardStudentsSummaryUseCase(
      dashboardRepository: getIt<DashboardRepository>(),
    ),
  );
}
