import 'package:alwaleed_admain/features/exams/presentation/validation/add_exam_validation_handler.dart';

class ExamGradeValidation extends AddExamValidationHandler {
  String? validateField(String? value) {
    final String selectedGradeId = value?.trim() ?? '';

    if (selectedGradeId.isEmpty) {
      return 'يرجى اختيار الصف الدراسي';
    }

    return null;
  }

  @override
  String? validate(AddExamValidationData data) {
    final String? error = validateField(
      data.selectedGradeId,
    );

    if (error != null) {
      return error;
    }

    return super.validate(data);
  }
}