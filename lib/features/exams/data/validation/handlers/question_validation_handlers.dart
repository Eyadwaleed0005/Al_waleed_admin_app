import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/features/exams/data/validation/core/validation_handler.dart';
import 'package:alwaleed_admain/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admain/features/exams/data/validation/models/exams_validation_data.dart';

class QuestionIdHandler extends ValidationHandler<QuestionValidationData> {
  QuestionIdHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(QuestionValidationData data) {
    _validator.validateId(data.question.questionId);
  }
}

class QuestionExamIdHandler extends ValidationHandler<QuestionValidationData> {
  QuestionExamIdHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(QuestionValidationData data) {
    if (data.requireExamId) {
      _validator.validateId(data.question.examId);
    }
  }
}

class QuestionTextHandler extends ValidationHandler<QuestionValidationData> {
  @override
  void validate(QuestionValidationData data) {
    if (data.question.questionText.trim().isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class QuestionDegreeHandler extends ValidationHandler<QuestionValidationData> {
  @override
  void validate(QuestionValidationData data) {
    if (data.question.degree <= 0) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class QuestionChoicesCountHandler
    extends ValidationHandler<QuestionValidationData> {
  @override
  void validate(QuestionValidationData data) {
    if (data.question.choices.length != 4) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class QuestionChoicesContentHandler
    extends ValidationHandler<QuestionValidationData> {
  @override
  void validate(QuestionValidationData data) {
    final bool hasEmptyChoice = data.question.choices.any(
      (String choice) => choice.trim().isEmpty,
    );

    if (hasEmptyChoice) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class QuestionCorrectChoiceHandler
    extends ValidationHandler<QuestionValidationData> {
  @override
  void validate(QuestionValidationData data) {
    final int? correctChoiceIndex = data.question.correctChoiceIndex;

    if (correctChoiceIndex == null ||
        correctChoiceIndex < 0 ||
        correctChoiceIndex >= data.question.choices.length) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}
