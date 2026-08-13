import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/cubit/app_startup_cubit.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/screens/splash_screen.dart';
import 'package:alwaleed_admain/features/dashboard/domin/use_cases/get_dashboard_students_summary_use_case.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/cubit/home_dashboard_cubit.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/screens/home_screen.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/create_lesson_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/use_case/stream_lessons_use_case.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/add_lesson_pdf_picker_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/view_lessons_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/screens/add_lesson_screen.dart';
import 'package:alwaleed_admain/features/lessons/presentation/screens/view_lessons_screen.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/delete_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/get_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/save_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_cubit.dart';
import 'package:alwaleed_admain/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:alwaleed_admain/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/create_student_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/delete_student_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/get_student_by_id_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/stream_students_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_email_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_password_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_profile_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_subscription_use_case.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/student_management_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/add_student_screen.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/student_management_screen.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/update_student_screen.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/create_study_note_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/delete_study_note_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/get_study_note_by_id_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/domain/use_case/update_study_note_use_case.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/add_note_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/edit_note_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/view_notes_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/screens/add_note_screen.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/screens/content_management_screen.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/screens/edit_note_screen.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/screens/view_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'route_names.dart';

class AppRoutes {
  const AppRoutes._();

  static final GetIt getIt = GetIt.instance;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return BlocProvider<AppStartupCubit>(
              create: (_) => AppStartupCubit(),
              child: const SplashScreen(),
            );
          },
        );

      case RouteNames.contentManagementScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return const ContentManagementScreen();
          },
        );

      case RouteNames.viewNotesScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return _provideViewNotesCubit(child: const ViewNotesScreen());
          },
        );

      case RouteNames.addNoteScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return _provideAddNoteCubit(child: const AddNoteScreen());
          },
        );

      case RouteNames.editNoteScreen:
        final noteId = settings.arguments;

        if (noteId is! String || noteId.trim().isEmpty) {
          return null;
        }

        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return _provideEditNoteCubit(
              noteId: noteId,
              child: const EditNoteScreen(),
            );
          },
        );

      case RouteNames.viewLessonsScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (context) {
            return _provideViewLessonsCubit(
              child: ViewLessonsScreen(
                onAddLessonPressed: () {
                  Navigator.of(context).pushNamed(RouteNames.addLessonScreen);
                },
              ),
            );
          },
        );

      case RouteNames.addLessonScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return _provideAddLessonCubits(child: const AddLessonScreen());
          },
        );

      case RouteNames.homeScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return _provideHomeDashboardCubit(child: const HomeScreen());
          },
        );

      case RouteNames.mainNavigationScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return _provideMainNavigationCubits(
              child: const MainNavigationScreen(),
            );
          },
        );

      case RouteNames.studentManagementScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return _provideStudentManagementCubit(
              child: const StudentManagementScreen(),
            );
          },
        );

      case RouteNames.addStudentScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return BlocProvider<AddStudentCubit>(
              create: (_) {
                return AddStudentCubit(
                  createStudentUseCase: _getIt<CreateStudentUseCase>(),
                  streamGradesUseCase: _getIt<StreamGradesUseCase>(),
                )..watchGrades();
              },
              child: const AddStudentScreen(),
            );
          },
        );

      case RouteNames.updateStudentScreen:
        final studentId = settings.arguments;

        if (studentId is! String || studentId.trim().isEmpty) {
          return null;
        }

        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return BlocProvider<UpdateStudentCubit>(
              create: (_) {
                return UpdateStudentCubit(
                  studentId: studentId,
                  getStudentByIdUseCase: _getIt<GetStudentByIdUseCase>(),
                  streamGradesUseCase: _getIt<StreamGradesUseCase>(),
                  updateStudentProfileUseCase:
                      _getIt<UpdateStudentProfileUseCase>(),
                  updateStudentEmailUseCase:
                      _getIt<UpdateStudentEmailUseCase>(),
                  updateStudentPasswordUseCase:
                      _getIt<UpdateStudentPasswordUseCase>(),
                  updateStudentSubscriptionUseCase:
                      _getIt<UpdateStudentSubscriptionUseCase>(),
                  deleteStudentUseCase: _getIt<DeleteStudentUseCase>(),
                )..initialize();
              },
              child: const UpdateStudentScreen(),
            );
          },
        );

      case RouteNames.liveSession:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return BlocProvider<LiveSessionCubit>(
              create: (_) => _createLiveSessionCubit(),
              child: const LiveSessionScreen(),
            );
          },
        );

      default:
        return null;
    }
  }

  static T _getIt<T extends Object>() {
    return getIt.get<T>();
  }

  static HomeDashboardCubit _createHomeDashboardCubit() {
    return HomeDashboardCubit(
      getDashboardStudentsSummaryUseCase:
          _getIt<GetDashboardStudentsSummaryUseCase>(),
      networkStatusCubit: _getIt<NetworkStatusCubit>(),
    )..loadStudentsSummary();
  }

  static StudentManagementCubit _createStudentManagementCubit() {
    return StudentManagementCubit(
      streamStudentsUseCase: _getIt<StreamStudentsUseCase>(),
      streamGradesUseCase: _getIt<StreamGradesUseCase>(),
    )..watchStudentManagement();
  }

  static ViewNotesCubit _createViewNotesCubit() {
    return ViewNotesCubit(
      streamGradesUseCase: _getIt<StreamGradesUseCase>(),
      streamStudyNotesUseCase: _getIt<StreamStudyNotesUseCase>(),
    )..initialize();
  }

  static AddNoteCubit _createAddNoteCubit() {
    return AddNoteCubit(
      streamGradesUseCase: _getIt<StreamGradesUseCase>(),
      createStudyNoteUseCase: _getIt<CreateStudyNoteUseCase>(),
    )..initialize();
  }

  static EditNoteCubit _createEditNoteCubit({required String noteId}) {
    return EditNoteCubit(
      noteId: noteId,
      getStudyNoteByIdUseCase: _getIt<GetStudyNoteByIdUseCase>(),
      streamGradesUseCase: _getIt<StreamGradesUseCase>(),
      updateStudyNoteUseCase: _getIt<UpdateStudyNoteUseCase>(),
      deleteStudyNoteUseCase: _getIt<DeleteStudyNoteUseCase>(),
    )..initialize();
  }

  static ViewLessonsCubit _createViewLessonsCubit() {
    return ViewLessonsCubit(
      streamGradesUseCase: _getIt<StreamGradesUseCase>(),
      streamLessonsUseCase: _getIt<StreamLessonsUseCase>(),
    )..initialize();
  }

  static AddLessonCubit _createAddLessonCubit() {
    return AddLessonCubit(
      streamGradesUseCase: _getIt<StreamGradesUseCase>(),
      createLessonUseCase: _getIt<CreateLessonUseCase>(),
    )..initialize();
  }

  static LiveSessionCubit _createLiveSessionCubit() {
    return LiveSessionCubit(
      streamGradesUseCase: _getIt<StreamGradesUseCase>(),
      getLiveSessionUseCase: _getIt<GetLiveSessionUseCase>(),
      saveLiveSessionUseCase: _getIt<SaveLiveSessionUseCase>(),
      deleteLiveSessionUseCase: _getIt<DeleteLiveSessionUseCase>(),
      networkStatusCubit: _getIt<NetworkStatusCubit>(),
    )..initialize();
  }

  static Widget _provideMainNavigationCubits({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeDashboardCubit>(
          create: (_) => _createHomeDashboardCubit(),
        ),
        BlocProvider<StudentManagementCubit>(
          create: (_) => _createStudentManagementCubit(),
        ),
        BlocProvider<LiveSessionCubit>(
          create: (_) => _createLiveSessionCubit(),
        ),
      ],
      child: child,
    );
  }

  static Widget _provideHomeDashboardCubit({required Widget child}) {
    return BlocProvider<HomeDashboardCubit>(
      create: (_) => _createHomeDashboardCubit(),
      child: child,
    );
  }

  static Widget _provideStudentManagementCubit({required Widget child}) {
    return BlocProvider<StudentManagementCubit>(
      create: (_) => _createStudentManagementCubit(),
      child: child,
    );
  }

  static Widget _provideViewNotesCubit({required Widget child}) {
    return BlocProvider<ViewNotesCubit>(
      create: (_) => _createViewNotesCubit(),
      child: child,
    );
  }

  static Widget _provideAddNoteCubit({required Widget child}) {
    return BlocProvider<AddNoteCubit>(
      create: (_) => _createAddNoteCubit(),
      child: child,
    );
  }

  static Widget _provideEditNoteCubit({
    required String noteId,
    required Widget child,
  }) {
    return BlocProvider<EditNoteCubit>(
      create: (_) => _createEditNoteCubit(noteId: noteId),
      child: child,
    );
  }

  static Widget _provideViewLessonsCubit({required Widget child}) {
    return BlocProvider<ViewLessonsCubit>(
      create: (_) => _createViewLessonsCubit(),
      child: child,
    );
  }

  static Widget _provideAddLessonCubits({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddLessonCubit>(create: (_) => _createAddLessonCubit()),
        BlocProvider<AddLessonPdfPickerCubit>(
          create: (_) => AddLessonPdfPickerCubit(),
        ),
      ],
      child: child,
    );
  }
}
