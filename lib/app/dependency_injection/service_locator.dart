import 'package:alwaleed_admain/core/firebase/firestore/firebase_firestore_service.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admain/features/students/data/data_sources/auth/firebase_student_auth_remote_data_source.dart';
import 'package:alwaleed_admain/features/students/data/data_sources/auth/student_auth_remote_data_source.dart';
import 'package:alwaleed_admain/features/students/data/data_sources/firestore/firebase_students_remote_data_source.dart';
import 'package:alwaleed_admain/features/students/data/data_sources/firestore/students_remote_data_source.dart';
import 'package:alwaleed_admain/features/students/data/repositories/student_auth_repository_impl.dart';
import 'package:alwaleed_admain/features/students/data/repositories/students_repository_impl.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/student_auth_repository.dart';
import 'package:alwaleed_admain/features/students/domain/repositories/students_repository.dart';
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
    () => FirebaseFunctions.instance,
  );

  // Core Firestore service
  getIt.registerLazySingleton<FirestoreService>(
    () => FirebaseFirestoreService(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Students Firestore data source
  getIt.registerLazySingleton<StudentsRemoteDataSource>(
    () => FirebaseStudentsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );

  // Student Authentication data source
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

  
}