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
    final normalizedLessonId = lessonId.trim();

    try {
      await for (final questionModels in _remoteDataSource.streamQuestions(
        lessonId: normalizedLessonId,
      )) {
        final questions = questionModels
            .map((questionModel) {
              return questionModel.toEntity();
            })
            .toList(growable: false);

        yield right(
          LessonExamEntity(
            lessonId: normalizedLessonId,
            questions: List<LessonExamQuestionEntity>.unmodifiable(questions),
          ),
        );
      }
    } catch (error) {
      yield left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> createQuestion({
    required String lessonId,
    required String questionText,
    required int degree,
    required List<String> choices,
    required LessonExamQuestionImageFile? image,
  }) async {
    try {
      final questionModel = LessonExamQuestionModel(
        questionId: '',
        lessonId: lessonId.trim(),
        questionText: questionText.trim(),
        degree: degree,
        choices: _normalizeChoices(choices),
        correctChoiceIndex: null,
      );

      await _remoteDataSource.createQuestion(
        question: questionModel,
        image: image,
      );

      return right(unit);
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateQuestion({
    required String lessonId,
    required String questionId,
    required String questionText,
    required int degree,
    required List<String> choices,
    required LessonExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  }) async {
    try {
      final questionModel = LessonExamQuestionModel(
        questionId: questionId.trim(),
        lessonId: lessonId.trim(),
        questionText: questionText.trim(),
        degree: degree,
        choices: _normalizeChoices(choices),
        correctChoiceIndex: null,
      );

      await _remoteDataSource.updateQuestion(
        question: questionModel,
        newImage: newImage,
        removeCurrentImage: removeCurrentImage,
      );

      return right(unit);
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> deleteQuestion({
    required String lessonId,
    required String questionId,
  }) async {
    try {
      await _remoteDataSource.deleteQuestion(
        lessonId: lessonId.trim(),
        questionId: questionId.trim(),
      );

      return right(unit);
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> saveCorrectAnswers({
    required String lessonId,
    required Map<String, int> correctChoiceIndexes,
  }) async {
    try {
      final normalizedAnswers = Map<String, int>.unmodifiable(
        correctChoiceIndexes.map((questionId, choiceIndex) {
          return MapEntry(questionId.trim(), choiceIndex);
        }),
      );

      await _remoteDataSource.saveCorrectAnswers(
        lessonId: lessonId.trim(),
        correctChoiceIndexes: normalizedAnswers,
      );

      return right(unit);
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  List<String> _normalizeChoices(List<String> choices) {
    return List<String>.unmodifiable(choices.map((choice) => choice.trim()));
  }
}
