import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/repositories/exams_repository.dart';
import 'package:dartz/dartz.dart';

class StreamExamsUseCase {
  const StreamExamsUseCase(this._repository);

  final ExamsRepository _repository;

  Stream<Either<AppErrorModel, List<ExamEntity>>> call({
    String? gradeId,
    ExamStatus? status,
  }) {
    return _repository.streamExams(
      gradeId: gradeId,
      status: status,
    );
  }
}