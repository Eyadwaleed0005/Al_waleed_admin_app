import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:dartz/dartz.dart';

import '../entities/live_session_entity.dart';

abstract interface class LiveSessionsRepository {
  Future<Either<AppErrorModel, LiveSessionEntity?>>
      getLiveSession();

  Future<Either<AppErrorModel, Unit>> saveLiveSession({
    required LiveSessionEntity liveSession,
  });

  Future<Either<AppErrorModel, Unit>> deleteLiveSession({
    required String gradeId,
  });
}