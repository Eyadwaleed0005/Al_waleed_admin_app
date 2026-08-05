import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_startup_state.dart';

class AppStartupCubit extends Cubit<AppStartupState> {
  AppStartupCubit() : super(const AppStartupInitial());

  void completeStartup() {
    if (state is AppStartupCompleted) return;
    emit(const AppStartupCompleted());
  }
}