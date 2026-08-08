import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';

abstract final class DateValidationHelper {
  static bool isValidDateRange({
    required DateTime startAt,
    required DateTime endAt,
  }) {
    return endAt.isAfter(startAt);
  }

  static bool isEndDateInFuture({
    required DateTime endAt,
  }) {
    return endAt.isAfter(DateTime.now());
  }

  static AppErrorModel invalidDateRangeError() {
    return const AppErrorModel(
      code: 'invalid-date-range',
      message: 'تاريخ الانتهاء يجب أن يكون بعد تاريخ البداية.',
      type: AppErrorType.validation,
      isRetryable: false,
    );
  }

  static AppErrorModel expiredEndDateError() {
    return const AppErrorModel(
      code: 'expired-end-date',
      message: 'تاريخ انتهاء الاشتراك يجب أن يكون في المستقبل.',
      type: AppErrorType.validation,
      isRetryable: false,
    );
  }
  static AppErrorModel cannotActivateExpiredSubscriptionError() {
  return const AppErrorModel(
    code: 'expired-subscription',
    message: 'لا يمكن تفعيل الحساب قبل تجديد الاشتراك.',
    type: AppErrorType.validation,
    isRetryable: false,
  );
}
}