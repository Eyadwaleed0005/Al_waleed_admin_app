import 'package:alwaleed_admin/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admin/features/exams/data/validation/core/validation_handler.dart';
import 'package:alwaleed_admin/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admin/features/exams/data/validation/models/exams_validation_data.dart';
import 'package:alwaleed_admin/features/exams/domain/exam_question_image_file.dart';

class CreateQuestionExamIdHandler
    extends ValidationHandler<CreateQuestionValidationData> {
  CreateQuestionExamIdHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(CreateQuestionValidationData data) {
    _validator.validateId(data.examId);
  }
}

class CreateQuestionPayloadHandler
    extends ValidationHandler<CreateQuestionValidationData> {
  CreateQuestionPayloadHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(CreateQuestionValidationData data) {
    _validator.validateQuestion(data.question);
  }
}

class CreateQuestionImageReferenceHandler
    extends ValidationHandler<CreateQuestionValidationData> {
  @override
  void validate(CreateQuestionValidationData data) {
    if (data.question.hasImage && data.image == null) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class CreateQuestionImageHandler
    extends ValidationHandler<CreateQuestionValidationData> {
  CreateQuestionImageHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(CreateQuestionValidationData data) {
    final ExamQuestionImageFile? image = data.image;

    if (image != null) {
      _validator.validateImage(image);
    }
  }
}