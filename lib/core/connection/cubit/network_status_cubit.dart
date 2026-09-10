import 'dart:async';

import 'package:alwaleed_admin/core/connection/network/network_info.dart';
import 'package:alwaleed_admin/core/connection/cubit/network_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkStatusCubit extends Cubit<NetworkStatusState> {
  NetworkStatusCubit({
    required NetworkInfo networkInfo,
  }) : _networkInfo = networkInfo,
       super(const NetworkStatusInitial());

  final NetworkInfo _networkInfo;

  StreamSubscription<bool>? _connectionSubscription;

  bool _isStartingMonitoring = false;

  Future<void> startMonitoring() async {
    if (isClosed || _isStartingMonitoring) {
      return;
    }

    _isStartingMonitoring = true;

    try {
      await _connectionSubscription?.cancel();
      _connectionSubscription = null;

      if (isClosed) {
        return;
      }

      await checkConnection();

      if (isClosed) {
        return;
      }

      _connectionSubscription =
          _networkInfo.onConnectionChanged.listen(
        _handleConnectionChanged,
        onError: _handleConnectionError,
      );
    } finally {
      _isStartingMonitoring = false;
    }
  }

  Future<void> checkConnection({
    bool forceShowOfflineBanner = false,
  }) async {
    if (isClosed) {
      return;
    }

    try {
      final bool isConnected =
          await _networkInfo.isConnected;

      if (isClosed) {
        return;
      }

      _emitConnectionStatus(
        isConnected,
        forceShowOfflineBanner:
            forceShowOfflineBanner,
      );
    } catch (_) {
      if (isClosed) {
        return;
      }

      _emitDisconnectedStatus(
        forceShowOfflineBanner:
            forceShowOfflineBanner,
      );
    }
  }

  void hideOfflineBanner() {
    if (isClosed) {
      return;
    }

    final NetworkStatusState currentState = state;

    if (currentState is! NetworkStatusDisconnected ||
        !currentState.showOfflineBanner) {
      return;
    }

    emit(
      const NetworkStatusDisconnected(
        showOfflineBanner: false,
      ),
    );
  }

  void _handleConnectionChanged(bool isConnected) {
    if (isClosed) {
      return;
    }

    _emitConnectionStatus(isConnected);
  }

  void _handleConnectionError(
    Object error,
    StackTrace stackTrace,
  ) {
    if (isClosed) {
      return;
    }

    _emitDisconnectedStatus();
  }

  void _emitConnectionStatus(
    bool isConnected, {
    bool forceShowOfflineBanner = false,
  }) {
    if (isClosed) {
      return;
    }

    if (isConnected) {
      if (state is NetworkStatusConnected) {
        return;
      }

      emit(const NetworkStatusConnected());
      return;
    }

    _emitDisconnectedStatus(
      forceShowOfflineBanner:
          forceShowOfflineBanner,
    );
  }

  void _emitDisconnectedStatus({
    bool forceShowOfflineBanner = false,
  }) {
    if (isClosed) {
      return;
    }

    final NetworkStatusState currentState = state;

    if (currentState is NetworkStatusDisconnected) {
      if (!forceShowOfflineBanner ||
          currentState.showOfflineBanner) {
        return;
      }

      emit(
        const NetworkStatusDisconnected(
          showOfflineBanner: true,
        ),
      );

      return;
    }

    emit(
      const NetworkStatusDisconnected(
        showOfflineBanner: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _connectionSubscription?.cancel();
    _connectionSubscription = null;

    return super.close();
  }
}