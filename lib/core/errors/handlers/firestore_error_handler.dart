import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:firebase_core/firebase_core.dart';

abstract final class FirestoreErrorHandler {
  static AppErrorModel handle(FirebaseException error) {
    return handleCode(error.code);
  }

  static AppErrorModel handleCode(String errorCode) {
    final code = _normalizeCode(errorCode);

    switch (code) {
      case 'cancelled':
        return _error(
          code: code,
          message: 'تم إلغاء العملية.',
          type: AppErrorType.unknown,
        );

      case 'invalid-argument':
      case 'out-of-range':
        return _error(
          code: code,
          message: 'البيانات المدخلة غير صحيحة.',
          type: AppErrorType.validation,
        );

      case 'not-found':
        return _error(
          code: code,
          message: 'البيانات المطلوبة غير موجودة.',
          type: AppErrorType.notFound,
        );

      case 'already-exists':
        return _error(
          code: code,
          message: 'هذه البيانات موجودة بالفعل.',
          type: AppErrorType.conflict,
        );

      case 'permission-denied':
        return _error(
          code: code,
          message: 'ليس لديك صلاحية لتنفيذ هذه العملية.',
          type: AppErrorType.authorization,
        );

      case 'unauthenticated':
        return _error(
          code: code,
          message: 'انتهت صلاحية الجلسة، حاول مرة أخرى.',
          type: AppErrorType.authentication,
        );

      case 'deadline-exceeded':
        return _error(
          code: code,
          message: 'انتهت مهلة الاتصال، حاول مرة أخرى.',
          type: AppErrorType.timeout,
          isRetryable: true,
        );

      case 'unavailable':
        return _error(
          code: code,
          message: 'تعذر الاتصال بالخادم، تحقق من الإنترنت.',
          type: AppErrorType.network,
          isRetryable: true,
        );

      case 'resource-exhausted':
        return _error(
          code: code,
          message: 'الخدمة مشغولة حاليًا، حاول مرة أخرى لاحقًا.',
          type: AppErrorType.rateLimit,
          isRetryable: true,
        );

      case 'failed-precondition':
        return _error(
          code: code,
          message: 'لا يمكن تنفيذ العملية في الوقت الحالي.',
          type: AppErrorType.validation,
        );

      case 'aborted':
        return _error(
          code: code,
          message: 'حدث تعارض أثناء تنفيذ العملية، حاول مرة أخرى.',
          type: AppErrorType.conflict,
          isRetryable: true,
        );

      case 'internal':
        return _error(
          code: code,
          message: 'حدث خطأ في الخادم، حاول مرة أخرى.',
          type: AppErrorType.server,
          isRetryable: true,
        );

      case 'data-loss':
        return _error(
          code: code,
          message: 'تعذر معالجة البيانات بشكل صحيح.',
          type: AppErrorType.server,
        );

      case 'unimplemented':
        return _error(
          code: code,
          message: 'هذه العملية غير متاحة حاليًا.',
          type: AppErrorType.server,
        );

      case 'unknown':
        return _error(
          code: code,
          message: 'حدث خطأ غير متوقع، حاول مرة أخرى.',
          type: AppErrorType.unknown,
        );

      default:
        return _error(
          code: code,
          message: 'تعذر تحميل البيانات، حاول مرة أخرى.',
          type: AppErrorType.unknown,
        );
    }
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
    return code
        .toLowerCase()
        .replaceFirst('cloud_firestore/', '')
        .replaceFirst('firestore/', '')
        .replaceAll('_', '-');
  }
}