import 'package:cloud_functions/cloud_functions.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_service.dart';
import 'package:alwaleed_admin/features/students/data/data_sources/auth/firebase_student_auth_remote_data_source.dart';
import 'package:alwaleed_admin/features/students/data/data_sources/auth/student_auth_remote_data_source.dart';
import 'package:alwaleed_admin/features/students/data/data_sources/firestore/firebase_students_remote_data_source.dart';
import 'package:alwaleed_admin/features/students/data/data_sources/firestore/students_remote_data_source.dart';
import 'package:alwaleed_admin/features/students/data/repositories/student_auth_repository_impl.dart';
import 'package:alwaleed_admin/features/students/data/repositories/students_repository_impl.dart';
import 'package:alwaleed_admin/features/students/domain/repositories/student_auth_repository.dart';
import 'package:alwaleed_admin/features/students/domain/repositories/students_repository.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/create_student_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/delete_student_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/get_student_by_id_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/get_students_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/stream_students_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/update_student_email_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/update_student_password_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/update_student_profile_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/update_student_status_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/update_student_subscription_use_case.dart';
import 'package:get_it/get_it.dart';

void registerStudentsDependencies(GetIt getIt) {
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
}
