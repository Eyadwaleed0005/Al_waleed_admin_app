import 'package:alwaleed_admain/features/live_session/domain/repository/live_sessions_repository.dart';
import '../entities/live_session_entity.dart';

class GetLiveSessionUseCase {
  const GetLiveSessionUseCase({
    required LiveSessionsRepository repository,
  }) : _repository = repository;

  final LiveSessionsRepository _repository;

  Future<LiveSessionEntity?> call({
    required String gradeId,
  }) {
    return _repository.getLiveSession(
      gradeId: gradeId,
    );
  }
}