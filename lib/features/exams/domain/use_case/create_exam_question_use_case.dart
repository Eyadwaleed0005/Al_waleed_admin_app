import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admin/features/exams/domain/exam_question_image_file.dart';
import 'package:alwaleed_admin/features/exams/domain/repositories/exams_repository.dart';
import 'package:dartz/dartz.dart';

class CreateExamQuestionUseCase {
  const CreateExamQuestionUseCase({
    required ExamsRepository examsRepository,
  }) : _examsRepository = examsRepository;

  final ExamsRepository _examsRepository;

  Future<Either<AppErrorModel, ExamQuestionEntity>> call({
    required String examId,
    required ExamQuestionEntity question,
    ExamQuestionImageFile? image,
  }) {
    return _examsRepository.createQuestion(
      examId: examId,
      question: question,
      image: image,
    );
  }
}