abstract interface class NetworkInfo {
  Future<bool> get isConnected;

  Stream<bool> get onConnectionChanged;

  Future<void> dispose();
}