import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import '../exceptions/firebase_remote_exception.dart';
import 'firebase_functions_error_handler.dart';
import 'firestore_error_handler.dart';

abstract final class FirebaseErrorHandler {
  // Temporary workaround. Firestore may keep the request pending when
  // there is no internet instead of returning an error.
  // This 9-second timeout stops the loading state and returns a failure.
  // Move this logic to a dedicated Firebase execution layer later.
  // By MeEyad
  static const Duration _operationTimeout = Duration(seconds: 9);

  static Future<T> execute<T>(Future<T> Function() operation) async {
    try {
      return await operation().timeout(_operationTimeout);
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

  static bool _isFirestoreError(FirebaseException error) {
    return error.plugin.contains('cloud_firestore') ||
        error.plugin.contains('firestore');
  }

  static AppErrorModel _timeoutError() {
    return const AppErrorModel(
      code: 'timeout',
      message:
          'تعذر تأكيد تنفيذ الطلب حاليًا بسبب انقطاع الاتصال. تم حفظ الطلب وسيتم تنفيذه تلقائيًا عند عودة الإنترنت.',
      type: AppErrorType.timeout,
      isRetryable: false,
    );
  }

  static AppErrorModel _serverError({required String code}) {
    return AppErrorModel(
      code: code,
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
      isRetryable: false,
    );
  }
}
