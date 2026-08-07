import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:cloud_functions/cloud_functions.dart';

abstract final class FirebaseFunctionsErrorHandler {
  static AppErrorModel handle(FirebaseFunctionsException error) {
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
        return _error(
          code: code,
          message: 'البيانات المدخلة غير صحيحة.',
          type: AppErrorType.validation,
        );

      case 'not-found':
        return _error(
          code: code,
          message: 'الحساب المطلوب غير موجود.',
          type: AppErrorType.notFound,
        );

      case 'already-exists':
        return _error(
          code: code,
          message: 'يوجد حساب مسجل بالفعل بهذه البيانات.',
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

      case 'resource-exhausted':
        return _error(
          code: code,
          message: 'تم تنفيذ عمليات كثيرة، حاول مرة أخرى لاحقًا.',
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

      case 'out-of-range':
        return _error(
          code: code,
          message: 'إحدى القيم المدخلة غير صحيحة.',
          type: AppErrorType.validation,
        );

      case 'unavailable':
        return _error(
          code: code,
          message: 'تعذر الاتصال بالخادم، تحقق من الإنترنت.',
          type: AppErrorType.network,
          isRetryable: true,
        );

      case 'internal':
      case 'data-loss':
      case 'unimplemented':
        return _error(
          code: code,
          message: 'حدث خطأ في الخادم، حاول مرة أخرى.',
          type: AppErrorType.server,
          isRetryable: code == 'internal',
        );

      case 'invalid-response':
        return _error(
          code: code,
          message: 'تعذر معالجة استجابة الخادم.',
          type: AppErrorType.server,
          isRetryable: true,
        );

      default:
        return _error(
          code: code,
          message: 'تعذر إتمام العملية، حاول مرة أخرى.',
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
        .replaceFirst('cloud-functions/', '')
        .replaceFirst('functions/', '')
        .replaceAll('_', '-');
  }
}