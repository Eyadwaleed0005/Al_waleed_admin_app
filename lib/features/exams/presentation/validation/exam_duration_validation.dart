import 'package:alwaleed_admain/features/exams/presentation/validation/add_exam_validation_handler.dart';

class ExamDurationValidation
    extends AddExamValidationHandler {
  String? validateField(String? value) {
    final String durationText = value?.trim() ?? '';

    if (durationText.isEmpty) {
      return 'يرجى إدخال مدة الاختبار';
    }

    final int? durationMinutes =
        int.tryParse(durationText);

    if (durationMinutes == null || durationMinutes <= 0) {
      return 'يرجى إدخال مدة صحيحة';
    }

    return null;
  }

  @override
  String? validate(AddExamValidationData data) {
    final String? error = validateField(
      data.examDurationText,
    );

    if (error != null) {
      return error;
    }

    return super.validate(data);
  }
}