class AddExamValidationData {
  const AddExamValidationData({
    required this.examName,
    required this.selectedGradeId,
    required this.examDurationText,
  });

  final String examName;
  final String selectedGradeId;
  final String examDurationText;
}

abstract class AddExamValidationHandler {
  AddExamValidationHandler? _nextHandler;

  AddExamValidationHandler setNext(
    AddExamValidationHandler nextHandler,
  ) {
    _nextHandler = nextHandler;
    return nextHandler;
  }

  String? validate(AddExamValidationData data) {
    return _nextHandler?.validate(data);
  }
}