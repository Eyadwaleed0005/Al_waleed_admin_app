import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/features/exams/data/data_sources/exams_remote_data_source.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_result_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_attempt_status.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_result_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:alwaleed_admain/features/exams/domain/repositories/exams_repository.dart';
import 'package:dartz/dartz.dart';

class ExamsRepositoryImpl implements ExamsRepository {
  const ExamsRepositoryImpl({required ExamsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ExamsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppErrorModel, List<ExamEntity>>> getExams({
    String? gradeId,
    ExamStatus? status,
  }) async {
    try {
      final List<ExamModel> examModels = await _remoteDataSource.getExams(
        gradeId: gradeId,
        status: status,
      );

      final List<ExamEntity> exams = examModels
          .map((ExamModel model) {
            return model.toEntity();
          })
          .toList(growable: false);

      return right(List<ExamEntity>.unmodifiable(exams));
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Stream<Either<AppErrorModel, List<ExamEntity>>> streamExams({
    String? gradeId,
    ExamStatus? status,
  }) async* {
    try {
      await for (final List<ExamModel> examModels
          in _remoteDataSource.streamExams(gradeId: gradeId, status: status)) {
        final List<ExamEntity> exams = examModels
            .map((ExamModel model) {
              return model.toEntity();
            })
            .toList(growable: false);

        yield right(List<ExamEntity>.unmodifiable(exams));
      }
    } catch (error) {
      yield left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, ExamEntity>> getExamById({
    required String examId,
  }) async {
    try {
      final ExamModel examModel = await _remoteDataSource.getExamById(
        examId: examId,
      );

      return right(examModel.toEntity());
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, String>> createExam({
    required ExamDraftEntity examDraft,
    required List<ExamQuestionEntity> questions,
    required Map<String, ExamQuestionImageFile> questionImages,
  }) async {
    try {
      final List<ExamQuestionModel> questionModels = questions
          .map((ExamQuestionEntity question) {
            return ExamQuestionModel.fromEntity(question);
          })
          .toList(growable: false);

      final int totalScore = questions.fold<int>(0, (
        int currentScore,
        ExamQuestionEntity question,
      ) {
        return currentScore + question.degree;
      });

      final ExamModel examModel = ExamModel(
        examId: '',
        gradeId: examDraft.gradeId,
        examName: examDraft.examName,
        durationMinutes: examDraft.durationMinutes,
        questionCount: questions.length,
        totalScore: totalScore,
        participantsCount: 0,
        status: examDraft.status,
        questions: questionModels,
      );

      final String createdExamId = await _remoteDataSource.createExam(
        exam: examModel,
        questions: questionModels,
        questionImages: Map<String, ExamQuestionImageFile>.unmodifiable(
          questionImages,
        ),
      );

      return right(createdExamId);
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, ExamQuestionEntity>> createQuestion({
    required String examId,
    required ExamQuestionEntity question,
    ExamQuestionImageFile? image,
  }) async {
    try {
      final ExamQuestionModel questionModel = ExamQuestionModel.fromEntity(
        question,
      );

      final ExamQuestionModel createdQuestionModel = await _remoteDataSource
          .createQuestion(
            examId: examId,
            question: questionModel,
            image: image,
          );

      return right(createdQuestionModel.toEntity());
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateExam({
    required ExamEntity exam,
  }) async {
    try {
      final ExamModel examModel = ExamModel(
        examId: exam.examId,
        gradeId: exam.gradeId,
        examName: exam.examName,
        durationMinutes: exam.durationMinutes,
        questionCount: exam.questionCount,
        totalScore: exam.totalScore,
        participantsCount: exam.participantsCount,
        status: exam.status,
        questions: List<ExamQuestionEntity>.unmodifiable(exam.questions),
        firstAttemptAt: exam.firstAttemptAt,
        closedAt: exam.closedAt,
        createdAt: exam.createdAt,
        updatedAt: exam.updatedAt,
      );

      await _remoteDataSource.updateExam(exam: examModel);

      return right(unit);
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> deleteExam({
    required String examId,
  }) async {
    try {
      await _remoteDataSource.deleteExam(examId: examId);

      return right(unit);
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, Unit>> updateQuestion({
    required ExamQuestionEntity question,
    ExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  }) async {
    try {
      final ExamQuestionModel questionModel = ExamQuestionModel.fromEntity(
        question,
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
    required String examId,
    required String questionId,
  }) async {
    try {
      await _remoteDataSource.deleteQuestion(
        examId: examId,
        questionId: questionId,
      );

      return right(unit);
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<AppErrorModel, List<ExamResultEntity>>> getExamResults({
    required String examId,
    ExamAttemptStatus? status,
  }) async {
    try {
      final List<ExamResultModel> resultModels = await _remoteDataSource
          .getExamResults(examId: examId, status: status);

      final List<ExamResultEntity> results = resultModels
          .map((ExamResultModel model) {
            return model.toEntity();
          })
          .toList(growable: false);

      return right(List<ExamResultEntity>.unmodifiable(results));
    } catch (error) {
      return left(FirebaseErrorHandler.handle(error));
    }
  }

  @override
  Stream<Either<AppErrorModel, List<ExamResultEntity>>> streamExamResults({
    required String examId,
    ExamAttemptStatus? status,
  }) async* {
    try {
      await for (final List<ExamResultModel> resultModels
          in _remoteDataSource.streamExamResults(
            examId: examId,
            status: status,
          )) {
        final List<ExamResultEntity> results = resultModels
            .map((ExamResultModel model) {
              return model.toEntity();
            })
            .toList(growable: false);

        yield right(List<ExamResultEntity>.unmodifiable(results));
      }
    } catch (error) {
      yield left(FirebaseErrorHandler.handle(error));
    }
  }
}
