import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admain/features/exams/data/validation/core/validation_handler.dart';
import 'package:alwaleed_admain/features/exams/data/validation/exams_data_validator.dart';
import 'package:alwaleed_admain/features/exams/data/validation/models/exams_validation_data.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';

class CreateExamGradeIdHandler
    extends ValidationHandler<CreateExamValidationData> {
  CreateExamGradeIdHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(CreateExamValidationData data) {
    _validator.validateId(data.exam.gradeId);
  }
}

class CreateExamNameHandler
    extends ValidationHandler<CreateExamValidationData> {
  @override
  void validate(CreateExamValidationData data) {
    if (data.exam.examName.trim().isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class CreateExamDurationHandler
    extends ValidationHandler<CreateExamValidationData> {
  @override
  void validate(CreateExamValidationData data) {
    if (data.exam.durationMinutes <= 0) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class CreateExamStatusHandler
    extends ValidationHandler<CreateExamValidationData> {
  @override
  void validate(CreateExamValidationData data) {
    if (data.exam.status == ExamStatus.ended) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class CreateExamQuestionsNotEmptyHandler
    extends ValidationHandler<CreateExamValidationData> {
  @override
  void validate(CreateExamValidationData data) {
    if (data.questions.isEmpty) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class CreateExamQuestionsLimitHandler
    extends ValidationHandler<CreateExamValidationData> {
  @override
  void validate(CreateExamValidationData data) {
    if (data.questions.length > ExamsDataValidator.maxQuestionsPerExam) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class CreateExamQuestionCountHandler
    extends ValidationHandler<CreateExamValidationData> {
  @override
  void validate(CreateExamValidationData data) {
    if (data.exam.questionCount != data.questions.length) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class CreateExamQuestionsPayloadHandler
    extends ValidationHandler<CreateExamValidationData> {
  CreateExamQuestionsPayloadHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(CreateExamValidationData data) {
    for (final ExamQuestionModel question in data.questions) {
      _validator.validateQuestion(question);
    }
  }
}

class CreateExamUniqueQuestionIdsHandler
    extends ValidationHandler<CreateExamValidationData> {
  CreateExamUniqueQuestionIdsHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(CreateExamValidationData data) {
    final Set<String> questionIds = <String>{};

    for (final ExamQuestionModel question in data.questions) {
      final String questionId = _validator.validateId(question.questionId);

      if (!questionIds.add(questionId)) {
        FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
      }
    }
  }
}

class CreateExamTotalScoreHandler
    extends ValidationHandler<CreateExamValidationData> {
  @override
  void validate(CreateExamValidationData data) {
    final int calculatedTotalScore = data.questions.fold<int>(0, (
      int total,
      ExamQuestionModel question,
    ) {
      return total + question.degree;
    });

    if (calculatedTotalScore != data.exam.totalScore) {
      FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
    }
  }
}

class CreateExamImageKeysHandler
    extends ValidationHandler<CreateExamValidationData> {
  CreateExamImageKeysHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(CreateExamValidationData data) {
    final Set<String> questionIds = data.questions.map((
      ExamQuestionModel question,
    ) {
      return _validator.validateId(question.questionId);
    }).toSet();

    for (final String imageQuestionId in data.questionImages.keys) {
      final String normalizedId = _validator.validateId(imageQuestionId);

      if (!questionIds.contains(normalizedId)) {
        FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
      }
    }
  }
}

class CreateExamImageReferencesHandler
    extends ValidationHandler<CreateExamValidationData> {
  CreateExamImageReferencesHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(CreateExamValidationData data) {
    final Set<String> imageQuestionIds = data.questionImages.keys
        .map(_validator.validateId)
        .toSet();

    for (final ExamQuestionModel question in data.questions) {
      final String questionId = _validator.validateId(question.questionId);

      if (question.hasImage && !imageQuestionIds.contains(questionId)) {
        FirebaseErrorHandler.throwFirestoreCode('invalid-argument');
      }
    }
  }
}

class CreateExamImageFilesHandler
    extends ValidationHandler<CreateExamValidationData> {
  CreateExamImageFilesHandler({required ExamsDataValidator validator})
    : _validator = validator;

  final ExamsDataValidator _validator;

  @override
  void validate(CreateExamValidationData data) {
    for (final ExamQuestionImageFile image in data.questionImages.values) {
      _validator.validateImage(image);
    }
  }
}
