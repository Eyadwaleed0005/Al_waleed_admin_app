import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/functions/firebase_function_keys.dart';
import 'package:alwaleed_admain/core/firebase/functions/firebase_function_names.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'student_auth_remote_data_source.dart';

class FirebaseStudentAuthRemoteDataSource
    implements StudentAuthRemoteDataSource {
  final FirebaseFunctions _firebaseFunctions;

  const FirebaseStudentAuthRemoteDataSource({
    required FirebaseFunctions firebaseFunctions,
  }) : _firebaseFunctions = firebaseFunctions;

  @override
  Future<String> createStudentAccount({
    required String email,
    required String password,
  }) {
    return _execute(() async {
      final callable = _firebaseFunctions.httpsCallable(
        FirebaseFunctionNames.createStudentAccount,
      );

      final result = await callable.call<Map<String, dynamic>>({
        FirebaseFunctionKeys.email: email.trim(),
        FirebaseFunctionKeys.password: password,
      });

      final studentId = result.data[
        FirebaseFunctionKeys.studentId
      ];

      if (studentId is! String || studentId.isEmpty) {
        throw FirebaseRemoteException(
          errorModel: FirebaseErrorHandler.handleFunctionsCode(
            'invalid-response',
          ),
        );
      }

      return studentId;
    });
  }

  @override
  Future<void> updateStudentPassword({
    required String studentId,
    required String newPassword,
  }) {
    return _execute(() async {
      final callable = _firebaseFunctions.httpsCallable(
        FirebaseFunctionNames.updateStudentPassword,
      );

      await callable.call<Object?>({
        FirebaseFunctionKeys.studentId: studentId,
        FirebaseFunctionKeys.newPassword: newPassword,
      });
    });
  }

  @override
  Future<void> updateStudentEmail({
    required String studentId,
    required String newEmail,
  }) {
    return _execute(() async {
      final callable = _firebaseFunctions.httpsCallable(
        FirebaseFunctionNames.updateStudentEmail,
      );

      await callable.call<Object?>({
        FirebaseFunctionKeys.studentId: studentId,
        FirebaseFunctionKeys.newEmail: newEmail.trim(),
      });
    });
  }

  @override
  Future<void> updateStudentAccountStatus({
    required String studentId,
    required bool isActive,
  }) {
    return _execute(() async {
      final callable = _firebaseFunctions.httpsCallable(
        FirebaseFunctionNames.updateStudentAccountStatus,
      );

      await callable.call<Object?>({
        FirebaseFunctionKeys.studentId: studentId,
        FirebaseFunctionKeys.isActive: isActive,
      });
    });
  }

  @override
  Future<void> deleteStudentAccount({
    required String studentId,
  }) {
    return _execute(() async {
      final callable = _firebaseFunctions.httpsCallable(
        FirebaseFunctionNames.deleteStudentAccount,
      );

      await callable.call<Object?>({
        FirebaseFunctionKeys.studentId: studentId,
      });
    });
  }

  Future<T> _execute<T>(
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      if (error is FirebaseRemoteException) {
        Error.throwWithStackTrace(
          error,
          stackTrace,
        );
      }

      final remoteException = FirebaseRemoteException(
        errorModel: FirebaseErrorHandler.handle(error),
      );

      Error.throwWithStackTrace(
        remoteException,
        stackTrace,
      );
    }
  }
}