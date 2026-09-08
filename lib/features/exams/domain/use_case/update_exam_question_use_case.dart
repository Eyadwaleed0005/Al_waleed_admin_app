import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/exam_question_image_file.dart';
import 'package:alwaleed_admain/features/exams/domain/repositories/exams_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateExamQuestionUseCase {
  const UpdateExamQuestionUseCase({
    required ExamsRepository examsRepository,
  }) : _examsRepository = examsRepository;

  final ExamsRepository _examsRepository;

  Future<Either<AppErrorModel, Unit>> call({
    required ExamQuestionEntity question,
    ExamQuestionImageFile? newImage,
    required bool removeCurrentImage,
  }) {
    return _examsRepository.updateQuestion(
      question: question,
      newImage: newImage,
      removeCurrentImage: removeCurrentImage,
    );
  }
}