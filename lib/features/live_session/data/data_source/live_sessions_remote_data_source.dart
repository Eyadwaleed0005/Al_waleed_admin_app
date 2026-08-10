import '../models/live_session_model.dart';

abstract interface class LiveSessionsRemoteDataSource {
  Future<LiveSessionModel?> getLiveSession();

  Future<void> saveLiveSession({
    required LiveSessionModel liveSession,
  });

  Future<void> deleteLiveSession({
    required String gradeId,
  });
}