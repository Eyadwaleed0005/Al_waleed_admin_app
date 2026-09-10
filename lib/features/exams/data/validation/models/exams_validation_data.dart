import 'package:alwaleed_admin/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admin/features/exams/domain/exam_question_image_file.dart';

class IdValidationData {
  const IdValidationData({required this.value});

  final String value;
}

class ImageValidationData {
  const ImageValidationData({required this.image});

  final ExamQuestionImageFile image;
}

class QuestionValidationData {
  const QuestionValidationData({
    required this.question,
    this.requireExamId = false,
  });

  final ExamQuestionModel question;
  final bool requireExamId;
}

class CreateExamValidationData {
  const CreateExamValidationData({
    required this.exam,
    required this.questions,
    required this.questionImages,
  });

  final ExamModel exam;
  final List<ExamQuestionModel> questions;
  final Map<String, ExamQuestionImageFile> questionImages;
}

class UpdateExamValidationData {
  const UpdateExamValidationData({required this.exam});

  final ExamModel exam;
}

class CreateQuestionValidationData {
  const CreateQuestionValidationData({
    required this.examId,
    required this.question,
    required this.image,
  });

  final String examId;
  final ExamQuestionModel question;
  final ExamQuestionImageFile? image;
}

class UpdateQuestionValidationData {
  const UpdateQuestionValidationData({
    required this.question,
    required this.newImage,
    required this.removeCurrentImage,
  });

  final ExamQuestionModel question;
  final ExamQuestionImageFile? newImage;
  final bool removeCurrentImage;
}

class DeleteQuestionValidationData {
  const DeleteQuestionValidationData({
    required this.examId,
    required this.questionId,
  });

  final String examId;
  final String questionId;
}
