import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';

class FirebaseRemoteException implements Exception {
  final AppErrorModel errorModel;

  const FirebaseRemoteException({
    required this.errorModel,
  });
}