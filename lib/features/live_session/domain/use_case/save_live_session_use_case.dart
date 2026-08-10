import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:dartz/dartz.dart';

import '../entities/live_session_entity.dart';
import '../repository/live_sessions_repository.dart';

class SaveLiveSessionUseCase {
  const SaveLiveSessionUseCase({
    required LiveSessionsRepository repository,
  }) : _repository = repository;

  final LiveSessionsRepository _repository;

  Future<Either<AppErrorModel, Unit>> call({
    required LiveSessionEntity liveSession,
  }) {
    return _repository.saveLiveSession(
      liveSession: liveSession,
    );
  }
}