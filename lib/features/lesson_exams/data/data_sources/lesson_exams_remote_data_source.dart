import 'package:alwaleed_admain/features/lesson_exams/data/models/lesson_exam_question_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';

abstract class LessonExamsRemoteDataSource {
  Stream<List<LessonExamQuestionModel>> streamQuestions({
    required String lessonId,
  });

  Future<void> createQuestion({
    required LessonExamQuestionModel question,
    LessonExamQuestionImageFile? image,
  });

  Future<void> updateQuestion({
    required LessonExamQuestionModel question,
    LessonExamQuestionImageFile? newImage,
    bool removeCurrentImage = false,
  });

  Future<void> deleteQuestion({
    required String lessonId,
    required String questionId,
  });

  Future<void> saveCorrectAnswers({
    required String lessonId,
    required Map<String, int> correctChoiceIndexes,
  });
}
