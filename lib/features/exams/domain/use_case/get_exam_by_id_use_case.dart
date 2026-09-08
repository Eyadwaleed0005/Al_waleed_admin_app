import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/repositories/exams_repository.dart';
import 'package:dartz/dartz.dart';

class GetExamByIdUseCase {
  const GetExamByIdUseCase(this._repository);

  final ExamsRepository _repository;

  Future<Either<AppErrorModel, ExamEntity>> call({
    required String examId,
  }) {
    return _repository.getExamById(
      examId: examId,
    );
  }
}