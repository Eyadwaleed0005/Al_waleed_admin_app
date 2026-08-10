import 'package:alwaleed_admain/features/live_session/domain/entities/live_session_entity.dart';


abstract interface class LiveSessionsRepository {
  Future<LiveSessionEntity?> getLiveSession({
    required String gradeId,
  });

  Future<void> saveLiveSession({
    required LiveSessionEntity liveSession,
  });

  Future<void> deleteLiveSession({
    required String gradeId,
  });
}