import 'package:alwaleed_admin/features/exams/data/validation/core/validation_handler.dart';
import 'package:alwaleed_admin/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admin/features/exams/data/validation/models/exams_validation_data.dart';

class DeleteQuestionExamIdHandler
    extends ValidationHandler<DeleteQuestionValidationData> {
  DeleteQuestionExamIdHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(DeleteQuestionValidationData data) {
    _validator.validateId(data.examId);
  }
}

class DeleteQuestionIdHandler
    extends ValidationHandler<DeleteQuestionValidationData> {
  DeleteQuestionIdHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(DeleteQuestionValidationData data) {
    _validator.validateId(data.questionId);
  }
}