import 'package:alwaleed_admain/features/app_startup/presentation/cubit/app_startup_cubit.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/screens/splash_screen.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/screens/home_screen.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/stream_students_use_case.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/student_management_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/student_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'route_names.dart';

class AppRoutes {
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
          builder: (_) => const HomeScreen(),
        );

      case RouteNames.mainNavigationScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return _provideStudentManagementCubit(
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

      default:
        return null;
    }
  }

  static Widget _provideStudentManagementCubit({required Widget child}) {
    return BlocProvider<StudentManagementCubit>(
      create: (_) {
        return StudentManagementCubit(
          streamStudentsUseCase: GetIt.instance<StreamStudentsUseCase>(),
          streamGradesUseCase: GetIt.instance<StreamGradesUseCase>(),
        )..watchStudentManagement();
      },
      child: child,
    );
  }
}
