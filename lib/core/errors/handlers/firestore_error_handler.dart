import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:firebase_core/firebase_core.dart';

abstract final class FirestoreErrorHandler {
  const FirestoreErrorHandler._();

  static AppErrorModel handle(FirebaseException error) {
    return handleCode(error.code);
  }

  static AppErrorModel handleCode(String errorCode) {
    final String code = _normalizeCode(errorCode);

    return switch (code) {
      'cancelled' => _error(
        code: code,
        message: 'تم إلغاء العملية.',
        type: AppErrorType.unknown,
      ),

      'invalid-argument' || 'out-of-range' => _error(
        code: code,
        message: 'البيانات المدخلة غير صحيحة.',
        type: AppErrorType.validation,
      ),

      'not-found' => _error(
        code: code,
        message: 'البيانات المطلوبة غير موجودة.',
        type: AppErrorType.notFound,
      ),

      'already-exists' => _error(
        code: code,
        message: 'هذه البيانات موجودة بالفعل.',
        type: AppErrorType.conflict,
      ),

      'permission-denied' => _error(
        code: code,
        message: 'ليس لديك صلاحية لتنفيذ هذه العملية.',
        type: AppErrorType.authorization,
      ),

      'unauthenticated' => _error(
        code: code,
        message: 'انتهت صلاحية الجلسة، سجل الدخول وحاول مرة أخرى.',
        type: AppErrorType.authentication,
      ),

      'no-internet' ||
      'network-error' ||
      'network-request-failed' ||
      'unavailable' =>
        _networkError(code),

      'deadline-exceeded' => _error(
        code: code,
        message:
            'انتهت مهلة الاتصال بالخادم. '
            'تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
        type: AppErrorType.timeout,
        isRetryable: true,
      ),

      'resource-exhausted' => _error(
        code: code,
        message: 'الخدمة مشغولة حاليًا، حاول مرة أخرى لاحقًا.',
        type: AppErrorType.rateLimit,
        isRetryable: true,
      ),

      'failed-precondition' => _error(
        code: code,
        message: 'لا يمكن تنفيذ العملية في الوقت الحالي.',
        type: AppErrorType.validation,
      ),

      'aborted' => _error(
        code: code,
        message: 'حدث تعارض أثناء تنفيذ العملية، حاول مرة أخرى.',
        type: AppErrorType.conflict,
        isRetryable: true,
      ),

      'internal' => _error(
        code: code,
        message: 'حدث خطأ في الخادم، حاول مرة أخرى.',
        type: AppErrorType.server,
        isRetryable: true,
      ),

      'data-loss' => _error(
        code: code,
        message: 'تعذر معالجة البيانات بصورة صحيحة.',
        type: AppErrorType.server,
      ),

      'unimplemented' => _error(
        code: code,
        message: 'هذه العملية غير متاحة حاليًا.',
        type: AppErrorType.server,
      ),

      'unknown' => _error(
        code: code,
        message: 'حدث خطأ غير متوقع، حاول مرة أخرى.',
        type: AppErrorType.unknown,
      ),

      _ => _error(
        code: code,
        message: 'تعذر تحميل البيانات، حاول مرة أخرى.',
        type: AppErrorType.unknown,
        isRetryable: true,
      ),
    };
  }

  static AppErrorModel _networkError(String code) {
    return _error(
      code: code,
      message:
          'تعذر الاتصال بالخادم. '
          'تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
      type: AppErrorType.network,
      isRetryable: true,
    );
  }

  static AppErrorModel _error({
    required String code,
    required String message,
    required AppErrorType type,
    bool isRetryable = false,
  }) {
    return AppErrorModel(
      code: code,
      message: message,
      type: type,
      isRetryable: isRetryable,
    );
  }

  static String _normalizeCode(String code) {
    final String normalizedCode = code
        .trim()
        .toLowerCase()
        .replaceFirst('cloud_firestore/', '')
        .replaceFirst('firestore/', '')
        .replaceAll('_', '-');

    if (normalizedCode.isEmpty) {
      return 'unknown';
    }

    return normalizedCode;
  }
}