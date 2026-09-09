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

  Future<bool>? _activeConnectionCheck;

  bool _isDisposed = false;

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
    if (_isDisposed) {
      return false;
    }

    final Future<bool>? activeCheck = _activeConnectionCheck;

    if (activeCheck != null) {
      return activeCheck;
    }

    final Future<bool> newCheck = _performConnectionCheck();

    _activeConnectionCheck = newCheck;

    try {
      return await newCheck;
    } finally {
      if (identical(_activeConnectionCheck, newCheck)) {
        _activeConnectionCheck = null;
      }
    }
  }

  Future<bool> _performConnectionCheck() async {
    for (int attempt = 0; attempt < _maximumCheckAttempts; attempt++) {
      if (_isDisposed) {
        return false;
      }

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
    if (_isDisposed) {
      return false;
    }

    try {
      return await _internetConnection.hasInternetAccess;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectionChanged {
    if (_isDisposed) {
      return Stream<bool>.value(false);
    }

    return _connectionChanges().distinct();
  }

  Stream<bool> _connectionChanges() async* {
    await for (final InternetStatus status
        in _internetConnection.onStatusChange) {
      if (_isDisposed) {
        return;
      }

      if (status == InternetStatus.connected) {
        yield true;
        continue;
      }

      await Future<void>.delayed(_offlineConfirmationDelay);

      if (_isDisposed) {
        return;
      }

      final bool connectionAfterRecheck = await isConnected;

      yield connectionAfterRecheck;
    }
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    _activeConnectionCheck = null;

    if (!_ownsInternetConnection) {
      return;
    }

    await _internetConnection.dispose();
  }
}
