import 'package:alwaleed_admin/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admin/features/exams/data/validation/core/validation_handler.dart';
import 'package:alwaleed_admin/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admin/features/exams/data/validation/models/exams_validation_data.dart';

class UpdateExamIdHandler
    extends ValidationHandler<UpdateExamValidationData> {
  UpdateExamIdHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(UpdateExamValidationData data) {
    _validator.validateId(data.exam.examId);
  }
}

class UpdateExamGradeIdHandler
    extends ValidationHandler<UpdateExamValidationData> {
  UpdateExamGradeIdHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(UpdateExamValidationData data) {
    _validator.validateId(data.exam.gradeId);
  }
}

class UpdateExamNameHandler
    extends ValidationHandler<UpdateExamValidationData> {
  @override
  void validate(UpdateExamValidationData data) {
    if (data.exam.examName.trim().isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class UpdateExamDurationHandler
    extends ValidationHandler<UpdateExamValidationData> {
  @override
  void validate(UpdateExamValidationData data) {
    if (data.exam.durationMinutes <= 0) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}