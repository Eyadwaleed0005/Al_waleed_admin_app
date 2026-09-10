import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/features/dashboard/domin/use_cases/get_dashboard_students_summary_use_case.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/cubit/home_dashboard_cubit.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class DashboardRoutes {
  const DashboardRoutes._();

  static final GetIt _getIt = GetIt.instance;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name != RouteNames.homeScreen) {
      return null;
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
        return BlocProvider<HomeDashboardCubit>(
          create: (_) => _createHomeDashboardCubit(),
          child: const HomeScreen(),
        );
      },
    );
  }

  static HomeDashboardCubit _createHomeDashboardCubit() {
    return HomeDashboardCubit(
      getDashboardStudentsSummaryUseCase:
          _get<GetDashboardStudentsSummaryUseCase>(),
      networkStatusCubit: _get<NetworkStatusCubit>(),
    )..loadStudentsSummary();
  }

  static T _get<T extends Object>() {
    return _getIt.get<T>();
  }
}