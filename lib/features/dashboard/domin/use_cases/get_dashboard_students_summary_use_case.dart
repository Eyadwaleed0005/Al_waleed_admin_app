import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/dashboard/domin/entities/dashboard_students_summary_entity.dart';
import 'package:alwaleed_admain/features/dashboard/domin/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class GetDashboardStudentsSummaryUseCase {
  const GetDashboardStudentsSummaryUseCase({
    required DashboardRepository dashboardRepository,
  }) : _dashboardRepository = dashboardRepository;

  final DashboardRepository _dashboardRepository;

  Future<Either<AppErrorModel, DashboardStudentsSummaryEntity>> call() {
    return _dashboardRepository.getStudentsSummary();
  }
}
