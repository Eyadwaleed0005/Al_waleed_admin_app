sealed class AppStartupState {
  const AppStartupState();
}

final class AppStartupInitial extends AppStartupState {
  const AppStartupInitial();
}

final class AppStartupCompleted extends AppStartupState {
  const AppStartupCompleted();
}