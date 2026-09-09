import 'package:alwaleed_admain/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admain/features/exams/data/validation/core/validation_chain.dart';
import 'package:alwaleed_admain/features/exams/data/validation/handlers/create_exam_validation_handlers.dart';
import 'package:alwaleed_admain/features/exams/data/validation/handlers/create_question_validation_handlers.dart';
import 'package:alwaleed_admain/features/exams/data/validation/handlers/delete_question_validation_handlers.dart';
import 'package:alwaleed_admain/features/exams/data/validation/handlers/id_validation_handlers.dart';
import 'package:alwaleed_admain/features/exams/data/validation/handlers/image_validation_handlers.dart';
import 'package:alwaleed_admain/features/exams/data/validation/handlers/question_validation_handlers.dart';
import 'package:alwaleed_admain/features/exams/data/validation/handlers/update_exam_validation_handlers.dart';
import 'package:alwaleed_admain/features/exams/data/validation/handlers/update_question_validation_handlers.dart';
import 'package:alwaleed_admain/features/exams/data/validation/models/exams_validation_data.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';

class ExamsDataValidator {
  const ExamsDataValidator();

  static const int maxQuestionsPerExam = 400;

  String validateId(String value) {
    ValidationChain<IdValidationData>(
      handlers: [IdNotEmptyHandler(), IdPathSeparatorHandler()],
    ).validate(IdValidationData(value: value));

    return value.trim();
  }

  void validateImage(ExamQuestionImageFile image) {
    ValidationChain<ImageValidationData>(
      handlers: [
        ImageBytesHandler(),
        ImageNameHandler(),
        ImageExtensionHandler(),
      ],
    ).validate(ImageValidationData(image: image));
  }

  void validateQuestion(
    ExamQuestionModel question, {
    bool requireExamId = false,
  }) {
    ValidationChain<QuestionValidationData>(
      handlers: [
        QuestionIdHandler(validator: this),
        QuestionExamIdHandler(validator: this),
        QuestionTextHandler(),
        QuestionDegreeHandler(),
        QuestionChoicesCountHandler(),
        QuestionChoicesContentHandler(),
        QuestionCorrectChoiceHandler(),
      ],
    ).validate(
      QuestionValidationData(question: question, requireExamId: requireExamId),
    );
  }

  void validateCreateExam({
    required ExamModel exam,
    required List<ExamQuestionModel> questions,
    required Map<String, ExamQuestionImageFile> questionImages,
  }) {
    ValidationChain<CreateExamValidationData>(
      handlers: [
        CreateExamGradeIdHandler(validator: this),
        CreateExamNameHandler(),
        CreateExamDurationHandler(),
        CreateExamStatusHandler(),
        CreateExamQuestionsNotEmptyHandler(),
        CreateExamQuestionsLimitHandler(),
        CreateExamQuestionCountHandler(),
        CreateExamQuestionsPayloadHandler(validator: this),
        CreateExamUniqueQuestionIdsHandler(validator: this),
        CreateExamTotalScoreHandler(),
        CreateExamImageKeysHandler(validator: this),
        CreateExamImageReferencesHandler(validator: this),
        CreateExamImageFilesHandler(validator: this),
      ],
    ).validate(
      CreateExamValidationData(
        exam: exam,
        questions: questions,
        questionImages: questionImages,
      ),
    );
  }

  void validateUpdateExam({required ExamModel exam}) {
    ValidationChain<UpdateExamValidationData>(
      handlers: [
        UpdateExamIdHandler(validator: this),
        UpdateExamGradeIdHandler(validator: this),
        UpdateExamNameHandler(),
        UpdateExamDurationHandler(),
      ],
    ).validate(UpdateExamValidationData(exam: exam));
  }

  void validateCreateQuestion({
    required String examId,
    required ExamQuestionModel question,
    ExamQuestionImageFile? image,
  }) {
    ValidationChain<CreateQuestionValidationData>(
      handlers: [
        CreateQuestionExamIdHandler(validator: this),
        CreateQuestionPayloadHandler(validator: this),
        CreateQuestionImageReferenceHandler(),
        CreateQuestionImageHandler(validator: this),
      ],
    ).validate(
      CreateQuestionValidationData(
        examId: examId,
        question: question,
        image: image,
      ),
    );
  }

  void validateUpdateQuestion({
    required ExamQuestionModel question,
    ExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  }) {
    ValidationChain<UpdateQuestionValidationData>(
      handlers: [
        UpdateQuestionPayloadHandler(validator: this),
        UpdateQuestionImageOperationHandler(),
        UpdateQuestionImageHandler(validator: this),
      ],
    ).validate(
      UpdateQuestionValidationData(
        question: question,
        newImage: newImage,
        removeCurrentImage: removeCurrentImage,
      ),
    );
  }

  void validateDeleteExam({required String examId}) {
    validateId(examId);
  }

  void validateDeleteQuestion({
    required String examId,
    required String questionId,
  }) {
    ValidationChain<DeleteQuestionValidationData>(
      handlers: [
        DeleteQuestionExamIdHandler(validator: this),
        DeleteQuestionIdHandler(validator: this),
      ],
    ).validate(
      DeleteQuestionValidationData(examId: examId, questionId: questionId),
    );
  }
}
