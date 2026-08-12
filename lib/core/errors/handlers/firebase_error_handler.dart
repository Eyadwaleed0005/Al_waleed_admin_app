import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_functions_error_handler.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_storage_error_handler.dart';
import 'package:alwaleed_admain/core/errors/handlers/firestore_error_handler.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

abstract final class FirebaseErrorHandler {
  const FirebaseErrorHandler._();

  static const Duration _operationTimeout = Duration(seconds: 9);

  static Future<T> execute<T>(
    Future<T> Function() operation, {
    Duration? timeout = _operationTimeout,
  }) async {
    try {
      if (timeout == null) {
        return await operation();
      }

      return await operation().timeout(timeout);
    } catch (error, stackTrace) {
      if (error is FirebaseRemoteException) {
        Error.throwWithStackTrace(error, stackTrace);
      }

      final remoteException = FirebaseRemoteException(
        errorModel: handle(error),
      );

      Error.throwWithStackTrace(remoteException, stackTrace);
    }
  }

  static AppErrorModel handle(Object error) {
    if (error is FirebaseRemoteException) {
      return error.errorModel;
    }

    if (error is FirebaseFunctionsException) {
      return FirebaseFunctionsErrorHandler.handle(error);
    }

    if (error is FirebaseException && _isFirestoreError(error)) {
      return FirestoreErrorHandler.handle(error);
    }

    if (error is FirebaseException && _isStorageError(error)) {
      return FirebaseStorageErrorHandler.handle(error);
    }

    if (error is TimeoutException) {
      return _timeoutError();
    }

    if (error is FirebaseException) {
      return _serverError(code: error.code);
    }

    return _unknownError();
  }

  static AppErrorModel handleFirestoreCode(String code) {
    return FirestoreErrorHandler.handleCode(code);
  }

  static AppErrorModel handleFunctionsCode(String code) {
    return FirebaseFunctionsErrorHandler.handleCode(code);
  }

  static AppErrorModel handleStorageCode(String code) {
    return FirebaseStorageErrorHandler.handleCode(code);
  }

  static bool _isFirestoreError(FirebaseException error) {
    final plugin = error.plugin.trim().toLowerCase();

    return plugin.contains('cloud_firestore') || plugin == 'firestore';
  }

  static bool _isStorageError(FirebaseException error) {
    final plugin = error.plugin.trim().toLowerCase();

    return plugin.contains('firebase_storage') || plugin == 'storage';
  }

  static AppErrorModel _timeoutError() {
    return const AppErrorModel(
      code: 'timeout',
      message:
          'استغرق تنفيذ الطلب وقتًا أطول من المتوقع. تحقق من اتصالك وحاول مرة أخرى.',
      type: AppErrorType.timeout,
      isRetryable: true,
    );
  }

  static AppErrorModel _serverError({required String code}) {
    return AppErrorModel(
      code: code.trim().isEmpty ? 'server-error' : code,
      message: 'حدث خطأ في الخادم، حاول مرة أخرى.',
      type: AppErrorType.server,
      isRetryable: true,
    );
  }

  static AppErrorModel _unknownError() {
    return const AppErrorModel(
      code: 'unknown',
      message: 'حدث خطأ غير متوقع، حاول مرة أخرى.',
      type: AppErrorType.unknown,
      isRetryable: true,
    );
  }
}
