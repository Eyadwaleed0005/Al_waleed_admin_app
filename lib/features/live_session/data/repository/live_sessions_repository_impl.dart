import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/live_session_entity.dart';
import '../../domain/repository/live_sessions_repository.dart';
import '../data_source/live_sessions_remote_data_source.dart';
import '../models/live_session_model.dart';

class LiveSessionsRepositoryImpl implements LiveSessionsRepository {
  const LiveSessionsRepositoryImpl({
    required LiveSessionsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final LiveSessionsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppErrorModel, LiveSessionEntity?>> getLiveSession() {
    return _execute<LiveSessionEntity?>(() async {
      final model = await _remoteDataSource.getLiveSession();

      return model?.toEntity();
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> saveLiveSession({
    required LiveSessionEntity liveSession,
  }) {
    return _execute<Unit>(() async {
      final model = LiveSessionModel.fromEntity(liveSession);

      await _remoteDataSource.saveLiveSession(liveSession: model);

      return unit;
    });
  }

  @override
  Future<Either<AppErrorModel, Unit>> deleteLiveSession({
    required String gradeId,
  }) {
    return _execute<Unit>(() async {
      await _remoteDataSource.deleteLiveSession(gradeId: gradeId);

      return unit;
    });
  }

  Future<Either<AppErrorModel, T>> _execute<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();

      return Right(result);
    } catch (error) {
      return Left(FirebaseErrorHandler.handle(error));
    }
  }
}
