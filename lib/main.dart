import 'package:alwaleed_admain/app/dependency_injection/service_locator.dart';
import 'package:alwaleed_admain/app/routes/app_routes.dart';
import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/core/widgets/app_network_status_listener.dart';
import 'package:alwaleed_admain/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupServiceLocator();
  await ScreenUtil.ensureScreenSize();
  getIt<NetworkStatusCubit>().startMonitoring();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NetworkStatusCubit>.value(
      value: getIt<NetworkStatusCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'الوليد',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Tajawal'),
            initialRoute: RouteNames.mainNavigationScreen,
            onGenerateRoute: AppRoutes.generateRoute,
            builder: (context, child) {
              return AppNetworkStatusListener(
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
