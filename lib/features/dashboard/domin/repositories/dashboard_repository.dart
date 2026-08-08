import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/dashboard/domin/entities/dashboard_students_summary_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class DashboardRepository {
  Future<Either<AppErrorModel, DashboardStudentsSummaryEntity>>
  getStudentsSummary();
}
