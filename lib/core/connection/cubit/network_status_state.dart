sealed class NetworkStatusState {
  const NetworkStatusState();
}

final class NetworkStatusInitial extends NetworkStatusState {
  const NetworkStatusInitial();
}

final class NetworkStatusConnected extends NetworkStatusState {
  const NetworkStatusConnected();
}

final class NetworkStatusDisconnected extends NetworkStatusState {
  const NetworkStatusDisconnected({this.showOfflineBanner = true});

  final bool showOfflineBanner;
}
