import 'package:alwaleed_admain/app/routes/app_route_observer.dart';
import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
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
import 'package:alwaleed_admain/features/live_session/data/data_source/firebase_live_sessions_remote_data_source.dart';
import 'package:alwaleed_admain/features/live_session/data/data_source/live_sessions_remote_data_source.dart';
import 'package:alwaleed_admain/features/live_session/data/repository/live_sessions_repository_impl.dart';
import 'package:alwaleed_admain/features/live_session/domain/repository/live_sessions_repository.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/delete_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/get_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/save_live_session_use_case.dart';
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

  getIt.registerLazySingleton<NetworkInfo>(
    () => InternetConnectionNetworkInfo(),
  );

  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(networkInfo: getIt<NetworkInfo>()),
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
    ),
  );

  // Live sessions remote data source

  getIt.registerLazySingleton<LiveSessionsRemoteDataSource>(
    () => FirebaseLiveSessionsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Live sessions repository

  getIt.registerLazySingleton<LiveSessionsRepository>(
    () => LiveSessionsRepositoryImpl(
      remoteDataSource: getIt<LiveSessionsRemoteDataSource>(),
    ),
  );

  // Live sessions use cases

  getIt.registerLazySingleton<GetLiveSessionUseCase>(
    () => GetLiveSessionUseCase(repository: getIt<LiveSessionsRepository>()),
  );

  getIt.registerLazySingleton<SaveLiveSessionUseCase>(
    () => SaveLiveSessionUseCase(repository: getIt<LiveSessionsRepository>()),
  );

  getIt.registerLazySingleton<DeleteLiveSessionUseCase>(
    () => DeleteLiveSessionUseCase(repository: getIt<LiveSessionsRepository>()),
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

  // Dashboard local data source

  getIt.registerLazySingleton<DashboardLocalDataSource>(
    () => const SharedPreferencesDashboardLocalDataSource(),
  );

  // Dashboard repository

  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: getIt<DashboardRemoteDataSource>(),
      localDataSource: getIt<DashboardLocalDataSource>(),
    ),
  );

  // Dashboard use cases

  getIt.registerLazySingleton<GetDashboardStudentsSummaryUseCase>(
    () => GetDashboardStudentsSummaryUseCase(
      dashboardRepository: getIt<DashboardRepository>(),
    ),
  );

  // Network status cubit

  getIt.registerLazySingleton<NetworkStatusCubit>(
    () => NetworkStatusCubit(networkInfo: getIt<NetworkInfo>()),
  );

  // Study notes remote data source

  getIt.registerLazySingleton<StudyNotesRemoteDataSource>(
    () => FirebaseStudyNotesRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  // Study notes repository

  getIt.registerLazySingleton<StudyNotesRepository>(
    () => StudyNotesRepositoryImpl(
      remoteDataSource: getIt<StudyNotesRemoteDataSource>(),
    ),
  );

  // Study notes use cases

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

  // App route observer

  getIt.registerLazySingleton<AppRouteObserver>(() => AppRouteObserver());
}
