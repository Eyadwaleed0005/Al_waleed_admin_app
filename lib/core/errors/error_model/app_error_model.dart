enum AppErrorType {
  validation,
  authentication,
  authorization,
  notFound,
  conflict,
  network,
  timeout,
  rateLimit,
  server,
  unknown,
}

class AppErrorModel {
  final String code;
  final String message;
  final AppErrorType type;
  final bool isRetryable;

  const AppErrorModel({
    required this.code,
    required this.message,
    required this.type,
    required this.isRetryable,
  });
}