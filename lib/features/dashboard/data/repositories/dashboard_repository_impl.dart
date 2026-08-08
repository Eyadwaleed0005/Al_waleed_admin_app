import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/cache/dashboard_local_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/remotely_data_base/dashboard_remote_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/models/dashboard_students_summary_model.dart';
import 'package:alwaleed_admain/features/dashboard/domin/entities/dashboard_students_summary_entity.dart';
import 'package:alwaleed_admain/features/dashboard/domin/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;
  final DashboardLocalDataSource _localDataSource;

  const DashboardRepositoryImpl({
    required DashboardRemoteDataSource remoteDataSource,
    required DashboardLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<AppErrorModel, DashboardStudentsSummaryEntity>>
  getStudentsSummary() async {
    try {
      final remoteModel = await _remoteDataSource.getStudentsSummary();

      await _cacheSummarySafely(remoteModel);

      return Right<AppErrorModel, DashboardStudentsSummaryEntity>(
        DashboardStudentsSummaryEntity(
          totalStudents: remoteModel.totalStudents,
          expiredSubscriptions: remoteModel.expiredSubscriptions,
        ),
      );
    } on FirebaseRemoteException {
      final cachedModel = await _getCachedSummarySafely();

      return Right<AppErrorModel, DashboardStudentsSummaryEntity>(
        DashboardStudentsSummaryEntity(
          totalStudents: cachedModel?.totalStudents ?? 0,
          expiredSubscriptions: cachedModel?.expiredSubscriptions ?? 0,
        ),
      );
    }
  }

  Future<void> _cacheSummarySafely(
    DashboardStudentsSummaryModel summary,
  ) async {
    try {
      await _localDataSource.cacheStudentsSummary(summary: summary);
    } catch (_) {}
  }

  Future<DashboardStudentsSummaryModel?> _getCachedSummarySafely() async {
    try {
      return await _localDataSource.getCachedStudentsSummary();
    } catch (_) {
      return null;
    }
  }
}
