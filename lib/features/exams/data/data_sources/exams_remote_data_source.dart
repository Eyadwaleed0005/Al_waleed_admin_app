import 'package:alwaleed_admain/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admain/features/exams/data/models/exam_result_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_attempt_status.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';

abstract class ExamsRemoteDataSource {
  Future<List<ExamModel>> getExams({
    String? gradeId,
    ExamStatus? status,
  });

  Stream<List<ExamModel>> streamExams({
    String? gradeId,
    ExamStatus? status,
  });

  Future<ExamModel> getExamById({
    required String examId,
  });

  Future<List<ExamResultModel>> getExamResults({
    required String examId,
    ExamAttemptStatus? status,
  });

  Stream<List<ExamResultModel>> streamExamResults({
    required String examId,
    ExamAttemptStatus? status,
  });

  Future<String> createExam({
    required ExamModel exam,
    required List<ExamQuestionModel> questions,
    required Map<String, ExamQuestionImageFile> questionImages,
  });

  Future<ExamQuestionModel> createQuestion({
    required String examId,
    required ExamQuestionModel question,
    ExamQuestionImageFile? image,
  });

  Future<void> updateExam({
    required ExamModel exam,
  });

  Future<void> deleteExam({
    required String examId,
  });

  Future<void> updateQuestion({
    required ExamQuestionModel question,
    ExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  });

  Future<void> deleteQuestion({
    required String examId,
    required String questionId,
  });
}