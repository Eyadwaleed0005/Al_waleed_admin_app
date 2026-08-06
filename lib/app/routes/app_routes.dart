import 'package:alwaleed_admain/features/app_startup/presentation/cubit/app_startup_cubit.dart';
import 'package:alwaleed_admain/features/app_startup/presentation/screens/splash_screen.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/screens/home_screen.dart';
import 'package:alwaleed_admain/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/student_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'route_names.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => AppStartupCubit(),
            child: const SplashScreen(),
          ),
        );

      case RouteNames.homeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );

      case RouteNames.mainNavigationScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainNavigationScreen(),
        );

      case RouteNames.studentManagementScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const StudentManagementScreen(),
        );

      default:
        return null;
    }
  }
}
