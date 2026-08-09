import 'dart:async';

import 'package:alwaleed_admain/core/connection/network/network_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'network_status_state.dart';

class NetworkStatusCubit
    extends Cubit<NetworkStatusState> {
  NetworkStatusCubit({
    required NetworkInfo networkInfo,
  }) : _networkInfo = networkInfo,
       super(const NetworkStatusInitial());

  final NetworkInfo _networkInfo;

  StreamSubscription<bool>?
  _connectionSubscription;

  Future<void> startMonitoring() async {
    await _connectionSubscription?.cancel();

    _connectionSubscription =
        _networkInfo.onConnectionChanged.listen(
      (isConnected) {
        unawaited(
          _emitConnectionStatus(isConnected),
        );
      },
      onError: (_) {
        unawaited(
          _emitDisconnectedStatus(),
        );
      },
    );

    await checkConnection();
  }

  Future<void> checkConnection({
    bool forceShowOfflineBanner = false,
  }) async {
    try {
      final isConnected =
          await _networkInfo.isConnected;

      await _emitConnectionStatus(
        isConnected,
        forceShowOfflineBanner:
            forceShowOfflineBanner,
      );
    } catch (_) {
      await _emitDisconnectedStatus(
        forceShowOfflineBanner:
            forceShowOfflineBanner,
      );
    }
  }

  Future<void> _emitConnectionStatus(
    bool isConnected, {
    bool forceShowOfflineBanner = false,
  }) async {
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

    await _emitDisconnectedStatus(
      forceShowOfflineBanner:
          forceShowOfflineBanner,
    );
  }

  Future<void> _emitDisconnectedStatus({
    bool forceShowOfflineBanner = false,
  }) async {
    if (isClosed) {
      return;
    }

    if (state is NetworkStatusDisconnected) {
      if (!forceShowOfflineBanner) {
        return;
      }

      emit(const NetworkStatusInitial());

      await Future<void>.delayed(
        Duration.zero,
      );

      if (isClosed) {
        return;
      }
    }

    emit(const NetworkStatusDisconnected());
  }

  @override
  Future<void> close() async {
    await _connectionSubscription?.cancel();
    return super.close();
  }
}