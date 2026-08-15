import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:dartz/dartz.dart';

abstract class LessonExamRepository {
  Stream<Either<AppErrorModel, LessonExamEntity>>
  streamLessonExam({
    required String lessonId,
  });

  Future<Either<AppErrorModel, Unit>> createQuestion({
    required String lessonId,
    required String questionText,
    required int degree,
    required List<String> choices,
    required LessonExamQuestionImageFile? image,
  });

  Future<Either<AppErrorModel, Unit>> updateQuestion({
    required String lessonId,
    required String questionId,
    required String questionText,
    required int degree,
    required List<String> choices,
    required LessonExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  });

  Future<Either<AppErrorModel, Unit>> deleteQuestion({
    required String lessonId,
    required String questionId,
  });

  Future<Either<AppErrorModel, Unit>> saveCorrectAnswers({
    required String lessonId,
    required Map<String, int> correctChoiceIndexes,
  });
}