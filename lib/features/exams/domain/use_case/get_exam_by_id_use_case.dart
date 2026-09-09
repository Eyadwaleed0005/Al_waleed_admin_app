import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/repositories/exams_repository.dart';
import 'package:dartz/dartz.dart';

class GetExamByIdUseCase {
  const GetExamByIdUseCase({
    required ExamsRepository examsRepository,
  }) : _examsRepository = examsRepository;

  final ExamsRepository _examsRepository;

  Future<Either<AppErrorModel, ExamEntity>> call({
    required String examId,
  }) {
    return _examsRepository.getExamById(
      examId: examId,
    );
  }
}