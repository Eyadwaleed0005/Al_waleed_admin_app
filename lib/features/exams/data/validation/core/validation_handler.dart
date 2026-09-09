abstract class ValidationHandler<T> {
  ValidationHandler<T>? _next;

  ValidationHandler<T> setNext(ValidationHandler<T> next) {
    _next = next;
    return next;
  }

  void handle(T data) {
    validate(data);
    _next?.handle(data);
  }

  void validate(T data);
}
