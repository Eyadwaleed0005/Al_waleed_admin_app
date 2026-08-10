import 'package:alwaleed_admain/features/live_session/data/data_source/live_sessions_remote_data_source.dart';
import 'package:alwaleed_admain/features/live_session/domain/entities/live_session_entity.dart';
import 'package:alwaleed_admain/features/live_session/domain/repository/live_sessions_repository.dart';
import '../models/live_session_model.dart';

class LiveSessionsRepositoryImpl implements LiveSessionsRepository {
  const LiveSessionsRepositoryImpl({
    required LiveSessionsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final LiveSessionsRemoteDataSource _remoteDataSource;

  @override
  Future<LiveSessionEntity?> getLiveSession({
    required String gradeId,
  }) async {
    final model = await _remoteDataSource.getLiveSession(
      gradeId: gradeId,
    );

    return model?.toEntity();
  }

  @override
  Future<void> saveLiveSession({
    required LiveSessionEntity liveSession,
  }) {
    final model = LiveSessionModel.fromEntity(liveSession);
    return _remoteDataSource.saveLiveSession(
      liveSession: model,
    );
  }

  @override
  Future<void> deleteLiveSession({
    required String gradeId,
  }) {
    return _remoteDataSource.deleteLiveSession(
      gradeId: gradeId,
    );
  }
}