import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/repositories/exams_repository.dart';
import 'package:dartz/dartz.dart';

class GetExamsUseCase {
  const GetExamsUseCase(this._repository);

  final ExamsRepository _repository;

  Future<Either<AppErrorModel, List<ExamEntity>>> call({
    String? gradeId,
    ExamStatus? status,
  }) {
    return _repository.getExams(
      gradeId: gradeId,
      status: status,
    );
  }
}