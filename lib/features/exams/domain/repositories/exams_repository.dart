import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:dartz/dartz.dart';

abstract class ExamsRepository {
  Future<Either<AppErrorModel, List<ExamEntity>>> getExams({
    String? gradeId,
    ExamStatus? status,
  });

  Stream<Either<AppErrorModel, List<ExamEntity>>> streamExams({
    String? gradeId,
    ExamStatus? status,
  });

  Future<Either<AppErrorModel, ExamEntity>> getExamById({
    required String examId,
  });

  Future<Either<AppErrorModel, String>> createExam({
    required ExamDraftEntity examDraft,
    required List<ExamQuestionEntity> questions,
    required Map<String, ExamQuestionImageFile> questionImages,
  });

  Future<Either<AppErrorModel, ExamQuestionEntity>> createQuestion({
    required String examId,
    required ExamQuestionEntity question,
    ExamQuestionImageFile? image,
  });

  Future<Either<AppErrorModel, Unit>> updateExam({required ExamEntity exam});

  Future<Either<AppErrorModel, Unit>> deleteExam({required String examId});

  Future<Either<AppErrorModel, Unit>> updateQuestion({
    required ExamQuestionEntity question,
    ExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  });

  Future<Either<AppErrorModel, Unit>> deleteQuestion({
    required String examId,
    required String questionId,
  });
}
