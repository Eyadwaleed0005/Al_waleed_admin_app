import 'package:alwaleed_admain/app/routes/app_route_observer.dart';
import 'package:get_it/get_it.dart';

void registerAppDependencies(GetIt getIt) {
  getIt.registerLazySingleton<AppRouteObserver>(() => AppRouteObserver());
}
