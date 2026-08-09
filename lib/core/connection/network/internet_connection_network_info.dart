import 'package:alwaleed_admain/core/connection/network/network_info.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionNetworkInfo implements NetworkInfo {
  InternetConnectionNetworkInfo({InternetConnection? internetConnection})
    : _ownsInternetConnection = internetConnection == null,
      _internetConnection = internetConnection ?? _createInternetConnection();

  static const int _maximumCheckAttempts = 2;

  static const Duration _retryDelay = Duration(milliseconds: 600);

  static const Duration _offlineConfirmationDelay = Duration(seconds: 2);

  final InternetConnection _internetConnection;
  final bool _ownsInternetConnection;

  static InternetConnection _createInternetConnection() {
    return InternetConnection.createInstance(
      useDefaultOptions: false,
      enableStrictCheck: false,
      checkInterval: const Duration(seconds: 5),
      customCheckOptions: [
        InternetCheckOption(
          uri: Uri.parse('https://firestore.googleapis.com/'),
          timeout: const Duration(seconds: 4),
          responseStatusFn: (response) {
            return response.statusCode >= 200 && response.statusCode < 500;
          },
        ),
        InternetCheckOption(
          uri: Uri.parse('https://www.google.com/generate_204'),
          timeout: const Duration(seconds: 4),
          responseStatusFn: (response) {
            return response.statusCode == 204;
          },
        ),
      ],
    );
  }

  @override
  Future<bool> get isConnected async {
    for (int attempt = 0; attempt < _maximumCheckAttempts; attempt++) {
      final bool hasInternet = await _checkConnectionSafely();

      if (hasInternet) {
        return true;
      }

      final bool canRetry = attempt < _maximumCheckAttempts - 1;

      if (canRetry) {
        await Future<void>.delayed(_retryDelay);
      }
    }

    return false;
  }

  Future<bool> _checkConnectionSafely() async {
    try {
      return await _internetConnection.hasInternetAccess;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectionChanged {
    return _connectionChanges().distinct();
  }

  Stream<bool> _connectionChanges() async* {
    yield await isConnected;

    await for (final InternetStatus status
        in _internetConnection.onStatusChange) {
      if (status == InternetStatus.connected) {
        yield true;
        continue;
      }
      await Future<void>.delayed(_offlineConfirmationDelay);

      final bool connectionAfterRecheck = await isConnected;

      yield connectionAfterRecheck;
    }
  }

  @override
  Future<void> dispose() async {
    if (!_ownsInternetConnection) {
      return;
    }

    await _internetConnection.dispose();
  }
}
