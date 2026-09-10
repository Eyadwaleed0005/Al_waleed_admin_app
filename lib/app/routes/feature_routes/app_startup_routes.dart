import 'package:alwaleed_admin/app/routes/route_names.dart';
import 'package:alwaleed_admin/features/app_startup/presentation/cubit/app_startup_cubit.dart';
import 'package:alwaleed_admin/features/app_startup/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract final class AppStartupRoutes {
  const AppStartupRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name != RouteNames.splashScreen) {
      return null;
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
        return BlocProvider<AppStartupCubit>(
          create: (_) => AppStartupCubit(),
          child: const SplashScreen(),
        );
      },
    );
  }
}