import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/repositories/exams_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteExamQuestionUseCase {
  const DeleteExamQuestionUseCase({
    required ExamsRepository examsRepository,
  }) : _examsRepository = examsRepository;

  final ExamsRepository _examsRepository;

  Future<Either<AppErrorModel, Unit>> call({
    required String examId,
    required String questionId,
  }) {
    return _examsRepository.deleteQuestion(
      examId: examId,
      questionId: questionId,
    );
  }
}