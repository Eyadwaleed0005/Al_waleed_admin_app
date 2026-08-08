import 'package:alwaleed_admain/core/connection/network/network_info.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionNetworkInfo
    implements NetworkInfo {
  final InternetConnection _internetConnection;

  InternetConnectionNetworkInfo({
    InternetConnection? internetConnection,
  }) : _internetConnection =
           internetConnection ??
           InternetConnection();

  @override
  Future<bool> get isConnected {
    return _internetConnection.hasInternetAccess;
  }

  @override
  Stream<bool> get onConnectionChanged {
    return _internetConnection.onStatusChange
        .map(
          (status) {
            return status ==
                InternetStatus.connected;
          },
        )
        .distinct();
  }
}