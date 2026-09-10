import 'package:alwaleed_admin/app/routes/route_names.dart';
import 'package:alwaleed_admin/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admin/features/dashboard/domin/use_cases/get_dashboard_students_summary_use_case.dart';
import 'package:alwaleed_admin/features/dashboard/presentation/cubit/home_dashboard_cubit.dart';
import 'package:alwaleed_admin/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admin/features/live_session/domain/use_case/delete_live_session_use_case.dart';
import 'package:alwaleed_admin/features/live_session/domain/use_case/get_live_session_use_case.dart';
import 'package:alwaleed_admin/features/live_session/domain/use_case/save_live_session_use_case.dart';
import 'package:alwaleed_admin/features/live_session/presentation/cubit/live_session_cubit.dart';
import 'package:alwaleed_admin/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/stream_students_use_case.dart';
import 'package:alwaleed_admin/features/students/presentation/cubit/student_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class MainNavigationRoutes {
  const MainNavigationRoutes._();

  static final GetIt _getIt = GetIt.instance;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name != RouteNames.mainNavigationScreen) {
      return null;
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
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
          child: const MainNavigationScreen(),
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

  static StudentManagementCubit _createStudentManagementCubit() {
    return StudentManagementCubit(
      streamStudentsUseCase: _get<StreamStudentsUseCase>(),
      streamGradesUseCase: _get<StreamGradesUseCase>(),
    )..watchStudentManagement();
  }

  static LiveSessionCubit _createLiveSessionCubit() {
    return LiveSessionCubit(
      streamGradesUseCase: _get<StreamGradesUseCase>(),
      getLiveSessionUseCase: _get<GetLiveSessionUseCase>(),
      saveLiveSessionUseCase: _get<SaveLiveSessionUseCase>(),
      deleteLiveSessionUseCase: _get<DeleteLiveSessionUseCase>(),
      networkStatusCubit: _get<NetworkStatusCubit>(),
    )..initialize();
  }

  static T _get<T extends Object>() {
    return _getIt.get<T>();
  }
}