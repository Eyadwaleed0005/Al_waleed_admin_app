import 'package:alwaleed_admain/features/exams/presentation/validation/add_exam_validation_handler.dart';
import 'package:alwaleed_admain/features/exams/presentation/validation/exam_duration_validation.dart';
import 'package:alwaleed_admain/features/exams/presentation/validation/exam_grade_validation.dart';
import 'package:alwaleed_admain/features/exams/presentation/validation/exam_name_validation.dart';

class AddExamValidation {
  AddExamValidation() {
    _examNameValidation = ExamNameValidation();
    _examGradeValidation = ExamGradeValidation();
    _examDurationValidation = ExamDurationValidation();

    _examNameValidation
        .setNext(_examGradeValidation)
        .setNext(_examDurationValidation);

    _validationChain = _examNameValidation;
  }

  late final ExamNameValidation _examNameValidation;
  late final ExamGradeValidation _examGradeValidation;
  late final ExamDurationValidation
      _examDurationValidation;

  late final AddExamValidationHandler _validationChain;

  String? validateExamName(String? value) {
    return _examNameValidation.validateField(value);
  }

  String? validateGrade(String? value) {
    return _examGradeValidation.validateField(value);
  }

  String? validateDuration(String? value) {
    return _examDurationValidation.validateField(value);
  }

  String? validate({
    required String examName,
    required String selectedGradeId,
    required String examDurationText,
  }) {
    final AddExamValidationData validationData =
        AddExamValidationData(
      examName: examName,
      selectedGradeId: selectedGradeId,
      examDurationText: examDurationText,
    );

    return _validationChain.validate(validationData);
  }
}