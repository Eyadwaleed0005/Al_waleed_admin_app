import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/cubit/app_startup_cubit.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/screens/splash_screen.dart';
import 'package:alwaleed_admain/features/dashboard/domin/use_cases/get_dashboard_students_summary_use_case.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/cubit/home_dashboard_cubit.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/screens/home_screen.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/create_student_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/stream_students_use_case.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/student_management_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/add_student_screen.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/student_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'route_names.dart';

class AppRoutes {
  AppRoutes._();
  static final GetIt _getIt = GetIt.instance;
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return BlocProvider<AppStartupCubit>(
              create: (_) => AppStartupCubit(),
              child: const SplashScreen(),
            );
          },
        );

      case RouteNames.homeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return _provideHomeDashboardCubit(child: const HomeScreen());
          },
        );

      case RouteNames.mainNavigationScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return _provideMainNavigationCubits(
              child: const MainNavigationScreen(),
            );
          },
        );

      case RouteNames.studentManagementScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return _provideStudentManagementCubit(
              child: const StudentManagementScreen(),
            );
          },
        );

      case RouteNames.addStudentScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return BlocProvider<AddStudentCubit>(
              create: (_) {
                return AddStudentCubit(
                  createStudentUseCase: GetIt.instance
                      .get<CreateStudentUseCase>(),
                  streamGradesUseCase: GetIt.instance
                      .get<StreamGradesUseCase>(),
                )..watchGrades();
              },
              child: const AddStudentScreen(),
            );
          },
        );

      default:
        return null;
    }
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

  static Widget _provideMainNavigationCubits({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeDashboardCubit>(
          create: (_) {
            return _createHomeDashboardCubit();
          },
        ),
        BlocProvider<StudentManagementCubit>(
          create: (_) {
            return _createStudentManagementCubit();
          },
        ),
      ],
      child: child,
    );
  }

  static Widget _provideHomeDashboardCubit({required Widget child}) {
    return BlocProvider<HomeDashboardCubit>(
      create: (_) {
        return _createHomeDashboardCubit();
      },
      child: child,
    );
  }

  static Widget _provideStudentManagementCubit({required Widget child}) {
    return BlocProvider<StudentManagementCubit>(
      create: (_) {
        return _createStudentManagementCubit();
      },
      child: child,
    );
  }
}
