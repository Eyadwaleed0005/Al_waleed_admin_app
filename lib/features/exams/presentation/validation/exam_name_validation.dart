import 'package:alwaleed_admin/features/exams/presentation/validation/add_exam_validation_handler.dart';

class ExamNameValidation extends AddExamValidationHandler {
  String? validateField(String? value) {
    final String examName = value?.trim() ?? '';

    if (examName.isEmpty) {
      return 'يرجى إدخال اسم الاختبار';
    }

    return null;
  }

  @override
  String? validate(AddExamValidationData data) {
    final String? error = validateField(data.examName);

    if (error != null) {
      return error;
    }

    return super.validate(data);
  }
}