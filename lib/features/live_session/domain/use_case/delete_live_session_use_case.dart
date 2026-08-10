import 'package:alwaleed_admain/features/live_session/domain/repository/live_sessions_repository.dart';


class DeleteLiveSessionUseCase {
  const DeleteLiveSessionUseCase({
    required LiveSessionsRepository repository,
  }) : _repository = repository;

  final LiveSessionsRepository _repository;

  Future<void> call({
    required String gradeId,
  }) {
    return _repository.deleteLiveSession(
      gradeId: gradeId,
    );
  }
}