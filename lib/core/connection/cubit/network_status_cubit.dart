import 'dart:async';
import 'package:alwaleed_admain/core/connection/network/network_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'network_status_state.dart';

class NetworkStatusCubit extends Cubit<NetworkStatusState> {
  final NetworkInfo _networkInfo;

  StreamSubscription<bool>? _connectionSubscription;

  NetworkStatusCubit({required NetworkInfo networkInfo})
    : _networkInfo = networkInfo,
      super(const NetworkStatusInitial());

  Future<void> startMonitoring() async {
    await _connectionSubscription?.cancel();

    _connectionSubscription = _networkInfo.onConnectionChanged.listen(
      _emitConnectionStatus,
      onError: (_) {
        if (isClosed) return;

        emit(const NetworkStatusDisconnected());
      },
    );

    await checkConnection();
  }

  Future<void> checkConnection() async {
    try {
      final bool isConnected = await _networkInfo.isConnected;

      _emitConnectionStatus(isConnected);
    } catch (_) {
      if (isClosed) return;

      emit(const NetworkStatusDisconnected());
    }
  }

  void _emitConnectionStatus(bool isConnected) {
    if (isClosed) return;

    if (isConnected) {
      if (state is NetworkStatusConnected) {
        return;
      }

      emit(const NetworkStatusConnected());

      return;
    }

    if (state is NetworkStatusDisconnected) {
      return;
    }

    emit(const NetworkStatusDisconnected());
  }

  @override
  Future<void> close() async {
    await _connectionSubscription?.cancel();

    return super.close();
  }
}
