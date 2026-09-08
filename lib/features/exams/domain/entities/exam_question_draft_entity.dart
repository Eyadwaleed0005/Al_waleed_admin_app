import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';

class ExamQuestionDraftEntity {
  const ExamQuestionDraftEntity({
    required this.question,
    this.image,
  });

  final ExamQuestionEntity question;
  final ExamQuestionImageFile? image;

  bool get hasImage {
    return image != null;
  }
}