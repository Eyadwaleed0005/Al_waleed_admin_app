import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:firebase_core/firebase_core.dart';

abstract final class FirebaseStorageErrorHandler {
  const FirebaseStorageErrorHandler._();

  static AppErrorModel handle(FirebaseException error) {
    return handleCode(error.code);
  }

  static AppErrorModel handleCode(String code) {
    final normalizedCode = _normalizeCode(code);

    switch (normalizedCode) {
      case 'no-internet':
      case 'network-request-failed':
        return const AppErrorModel(
          code: 'no-internet',
          message: 'لا يوجد اتصال بالإنترنت. تحقق من الاتصال وحاول مرة أخرى.',
          type: AppErrorType.network,
          isRetryable: true,
        );

      case 'object-not-found':
        return const AppErrorModel(
          code: 'object-not-found',
          message: 'تعذر العثور على ملف المذكرة المطلوب.',
          type: AppErrorType.notFound,
          isRetryable: false,
        );

      case 'local-file-not-found':
        return const AppErrorModel(
          code: 'local-file-not-found',
          message:
              'ملف PDF المحدد لم يعد موجودًا على الجهاز. اختر الملف مرة أخرى.',
          type: AppErrorType.notFound,
          isRetryable: false,
        );

      case 'unauthenticated':
        return const AppErrorModel(
          code: 'unauthenticated',
          message: 'يجب تسجيل الدخول أولًا لتنفيذ هذه العملية.',
          type: AppErrorType.authentication,
          isRetryable: false,
        );

      case 'unauthorized':
        return const AppErrorModel(
          code: 'unauthorized',
          message: 'ليست لديك صلاحية لتنفيذ هذه العملية.',
          type: AppErrorType.authorization,
          isRetryable: false,
        );

      case 'quota-exceeded':
        return const AppErrorModel(
          code: 'quota-exceeded',
          message:
              'تم تجاوز الحد المتاح لخدمة تخزين الملفات. حاول لاحقًا أو تواصل مع الدعم.',
          type: AppErrorType.rateLimit,
          isRetryable: false,
        );

      case 'retry-limit-exceeded':
        return const AppErrorModel(
          code: 'retry-limit-exceeded',
          message: 'تعذر إكمال رفع الملف بسبب ضعف الاتصال. حاول مرة أخرى.',
          type: AppErrorType.timeout,
          isRetryable: true,
        );

      case 'invalid-checksum':
      case 'server-file-wrong-size':
        return const AppErrorModel(
          code: 'invalid-uploaded-file',
          message: 'لم يكتمل رفع الملف بصورة سليمة. حاول رفعه مرة أخرى.',
          type: AppErrorType.conflict,
          isRetryable: true,
        );

      case 'canceled':
        return const AppErrorModel(
          code: 'upload-canceled',
          message: 'تم إلغاء رفع ملف PDF.',
          type: AppErrorType.unknown,
          isRetryable: true,
        );

      case 'bucket-not-found':
      case 'project-not-found':
      case 'no-default-bucket':
        return const AppErrorModel(
          code: 'storage-not-configured',
          message: 'إعداد خدمة تخزين الملفات غير مكتمل. تواصل مع الدعم.',
          type: AppErrorType.server,
          isRetryable: false,
        );

      case 'invalid-argument':
      case 'invalid-url':
      case 'invalid-event-name':
      case 'invalid-storage-path':
      case 'invalid-local-file-path':
        return const AppErrorModel(
          code: 'invalid-pdf-file',
          message: 'بيانات ملف PDF غير صالحة. اختر الملف مرة أخرى.',
          type: AppErrorType.validation,
          isRetryable: false,
        );

      case 'cannot-slice-blob':
        return const AppErrorModel(
          code: 'local-file-changed',
          message: 'تم تغيير أو حذف ملف PDF بعد اختياره. اختر الملف مرة أخرى.',
          type: AppErrorType.validation,
          isRetryable: false,
        );

      default:
        return AppErrorModel(
          code: normalizedCode.isEmpty ? 'storage-unknown' : normalizedCode,
          message: 'تعذر التعامل مع ملف PDF. حاول مرة أخرى.',
          type: AppErrorType.unknown,
          isRetryable: true,
        );
    }
  }

  static String _normalizeCode(String code) {
    var normalizedCode = code.trim().toLowerCase();

    if (normalizedCode.startsWith('storage/')) {
      normalizedCode = normalizedCode.substring('storage/'.length);
    }

    if (normalizedCode.startsWith('firebase_storage/')) {
      normalizedCode = normalizedCode.substring('firebase_storage/'.length);
    }

    return normalizedCode;
  }
}
