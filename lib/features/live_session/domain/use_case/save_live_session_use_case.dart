import 'package:alwaleed_admain/features/live_session/domain/repository/live_sessions_repository.dart';
import '../entities/live_session_entity.dart';

class SaveLiveSessionUseCase {
  const SaveLiveSessionUseCase({
    required LiveSessionsRepository repository,
  }) : _repository = repository;

  final LiveSessionsRepository _repository;

  Future<void> call({
    required LiveSessionEntity liveSession,
  }) {
    return _repository.saveLiveSession(
      liveSession: liveSession,
    );
  }
}