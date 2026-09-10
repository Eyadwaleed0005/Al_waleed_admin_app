import 'package:alwaleed_admin/features/exams/data/data_sources/exams_remote_data_source.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_model.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_question_model.dart';
import 'package:alwaleed_admin/features/exams/data/models/exam_result_model.dart';
import 'package:alwaleed_admin/features/exams/data/services/exam_creation_service.dart';
import 'package:alwaleed_admin/features/exams/data/services/exam_deletion_service.dart';
import 'package:alwaleed_admin/features/exams/data/services/exam_query_service.dart';
import 'package:alwaleed_admin/features/exams/data/services/exam_results_query_service.dart';
import 'package:alwaleed_admin/features/exams/data/services/exam_update_service.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_attempt_status.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admin/features/exams/domain/exam_question_image_file.dart';

class FirebaseExamsRemoteDataSource implements ExamsRemoteDataSource {
  const FirebaseExamsRemoteDataSource({
    required this._examQueryService,
    required this._examResultsQueryService,
    required this._examCreationService,
    required this._examUpdateService,
    required this._examDeletionService,
  });

  final ExamQueryService _examQueryService;
  final ExamResultsQueryService _examResultsQueryService;
  final ExamCreationService _examCreationService;
  final ExamUpdateService _examUpdateService;
  final ExamDeletionService _examDeletionService;

  @override
  Future<List<ExamModel>> getExams({String? gradeId, ExamStatus? status}) {
    return _examQueryService.getExams(gradeId: gradeId, status: status);
  }

  @override
  Stream<List<ExamModel>> streamExams({String? gradeId, ExamStatus? status}) {
    return _examQueryService.streamExams(gradeId: gradeId, status: status);
  }

  @override
  Future<ExamModel> getExamById({required String examId}) {
    return _examQueryService.getExamById(examId: examId);
  }

  @override
  Future<List<ExamResultModel>> getExamResults({
    required String examId,
    ExamAttemptStatus? status,
  }) {
    return _examResultsQueryService.getExamResults(
      examId: examId,
      status: status,
    );
  }

  @override
  Stream<List<ExamResultModel>> streamExamResults({
    required String examId,
    ExamAttemptStatus? status,
  }) {
    return _examResultsQueryService.streamExamResults(
      examId: examId,
      status: status,
    );
  }

  @override
  Future<String> createExam({
    required ExamModel exam,
    required List<ExamQuestionModel> questions,
    required Map<String, ExamQuestionImageFile> questionImages,
  }) {
    return _examCreationService.createExam(
      exam: exam,
      questions: questions,
      questionImages: questionImages,
    );
  }

  @override
  Future<ExamQuestionModel> createQuestion({
    required String examId,
    required ExamQuestionModel question,
    ExamQuestionImageFile? image,
  }) {
    return _examCreationService.createQuestion(
      examId: examId,
      question: question,
      image: image,
    );
  }

  @override
  Future<void> updateExam({required ExamModel exam}) {
    return _examUpdateService.updateExam(exam: exam);
  }

  @override
  Future<void> updateQuestion({
    required ExamQuestionModel question,
    ExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  }) {
    return _examUpdateService.updateQuestion(
      question: question,
      newImage: newImage,
      removeCurrentImage: removeCurrentImage,
    );
  }

  @override
  Future<void> deleteQuestion({
    required String examId,
    required String questionId,
  }) {
    return _examDeletionService.deleteQuestion(
      examId: examId,
      questionId: questionId,
    );
  }

  @override
  Future<void> deleteExam({required String examId}) {
    return _examDeletionService.deleteExam(examId: examId);
  }
}
