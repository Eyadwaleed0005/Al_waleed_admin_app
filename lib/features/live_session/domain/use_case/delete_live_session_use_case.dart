import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:dartz/dartz.dart';

import '../repository/live_sessions_repository.dart';

class DeleteLiveSessionUseCase {
  const DeleteLiveSessionUseCase({
    required LiveSessionsRepository repository,
  }) : _repository = repository;

  final LiveSessionsRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required String gradeId,
  }) {
    return _repository.deleteLiveSession(
      gradeId: gradeId,
    );
  }
}