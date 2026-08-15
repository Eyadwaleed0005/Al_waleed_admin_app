import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/features/lesson_exams/data/data_sources/lesson_exams_remote_data_source.dart';
import 'package:alwaleed_admain/features/lesson_exams/data/models/lesson_exam_question_model.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/lesson_exam_question_image_file.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/repositories/lesson_exam_repository.dart';
import 'package:dartz/dartz.dart';

class LessonExamRepositoryImpl implements LessonExamRepository {
  const LessonExamRepositoryImpl({
    required LessonExamsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final LessonExamsRemoteDataSource _remoteDataSource;

  @override
  Stream<Either<AppErrorModel, LessonExamEntity>> streamLessonExam({
    required String lessonId,
  }) async* {
    try {
      await for (final questionModels
          in _remoteDataSource.streamQuestions(
        lessonId: lessonId,
      )) {
        final questions = questionModels
            .map((model) => model.toEntity())
            .toList(growable: false);

        yield right(
          LessonExamEntity(
            lessonId: lessonId,
            questions:
                List<LessonExamQuestionEntity>.unmodifiable(
              questions,
            ),
          ),
        );
      }
    } catch (error) {
      yield left(
        FirebaseErrorHandler.handle(error),
      );
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> createQuestion({
    required String lessonId,
    required String questionText,
    required int degree,
    required List<String> choices,
    LessonExamQuestionImageFile? image,
  }) async {
    try {
      final questionModel = LessonExamQuestionModel(
        questionId: '',
        lessonId: lessonId,
        questionText: questionText,
        degree: degree,
        choices: List<String>.unmodifiable(
          choices,
        ),
        correctChoiceIndex: null,
      );

      await _remoteDataSource.createQuestion(
        question: questionModel,
        image: image,
      );

      return right(unit);
    } catch (error) {
      return left(
        FirebaseErrorHandler.handle(error),
      );
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateQuestion({
    required String lessonId,
    required String questionId,
    required String questionText,
    required int degree,
    required List<String> choices,
    LessonExamQuestionImageFile? newImage,
    bool removeCurrentImage = false,
  }) async {
    try {
      final questionModel = LessonExamQuestionModel(
        questionId: questionId,
        lessonId: lessonId,
        questionText: questionText,
        degree: degree,
        choices: List<String>.unmodifiable(
          choices,
        ),
        correctChoiceIndex: null,
      );

      await _remoteDataSource.updateQuestion(
        question: questionModel,
        newImage: newImage,
        removeCurrentImage: removeCurrentImage,
      );

      return right(unit);
    } catch (error) {
      return left(
        FirebaseErrorHandler.handle(error),
      );
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> deleteQuestion({
    required String lessonId,
    required String questionId,
  }) async {
    try {
      await _remoteDataSource.deleteQuestion(
        lessonId: lessonId,
        questionId: questionId,
      );

      return right(unit);
    } catch (error) {
      return left(
        FirebaseErrorHandler.handle(error),
      );
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> saveCorrectAnswers({
    required String lessonId,
    required Map<String, int> correctChoiceIndexes,
  }) async {
    try {
      await _remoteDataSource.saveCorrectAnswers(
        lessonId: lessonId,
        correctChoiceIndexes:
            Map<String, int>.unmodifiable(
          correctChoiceIndexes,
        ),
      );

      return right(unit);
    } catch (error) {
      return left(
        FirebaseErrorHandler.handle(error),
      );
    }
  }
}