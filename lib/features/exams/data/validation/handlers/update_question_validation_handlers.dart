import 'package:alwaleed_admin/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admin/features/exams/data/validation/core/validation_handler.dart';
import 'package:alwaleed_admin/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admin/features/exams/data/validation/models/exams_validation_data.dart';
import 'package:alwaleed_admin/features/exams/domain/exam_question_image_file.dart';

class UpdateQuestionPayloadHandler
    extends ValidationHandler<UpdateQuestionValidationData> {
  UpdateQuestionPayloadHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(UpdateQuestionValidationData data) {
    _validator.validateQuestion(
      data.question,
      requireExamId: true,
    );
  }
}

class UpdateQuestionImageOperationHandler
    extends ValidationHandler<UpdateQuestionValidationData> {
  @override
  void validate(UpdateQuestionValidationData data) {
    if (data.newImage != null && data.removeCurrentImage) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class UpdateQuestionImageHandler
    extends ValidationHandler<UpdateQuestionValidationData> {
  UpdateQuestionImageHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(UpdateQuestionValidationData data) {
    final ExamQuestionImageFile? image = data.newImage;

    if (image != null) {
      _validator.validateImage(image);
    }
  }
}