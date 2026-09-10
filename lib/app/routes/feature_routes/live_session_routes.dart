import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/delete_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/get_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/save_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_cubit.dart';
import 'package:alwaleed_admain/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class LiveSessionRoutes {
  const LiveSessionRoutes._();

  static final GetIt _getIt = GetIt.instance;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name != RouteNames.liveSession) {
      return null;
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
        return BlocProvider<LiveSessionCubit>(
          create: (_) => _createLiveSessionCubit(),
          child: const LiveSessionScreen(),
        );
      },
    );
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