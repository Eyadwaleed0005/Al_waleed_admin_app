import 'package:alwaleed_admain/features/exams/data/validation/core/validation_handler.dart';

class ValidationChain<T> {
  ValidationChain({required List<ValidationHandler<T>> handlers})
    : _handlers = List<ValidationHandler<T>>.unmodifiable(handlers);

  final List<ValidationHandler<T>> _handlers;

  void validate(T data) {
    if (_handlers.isEmpty) {
      return;
    }

    for (int index = 0; index < _handlers.length - 1; index++) {
      _handlers[index].setNext(_handlers[index + 1]);
    }

    _handlers.first.handle(data);
  }
}
