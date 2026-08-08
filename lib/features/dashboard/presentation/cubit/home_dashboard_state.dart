import 'package:alwaleed_admain/features/dashboard/domin/entities/dashboard_students_summary_entity.dart';

sealed class HomeDashboardState {
  const HomeDashboardState();
}

final class HomeDashboardInitial
    extends HomeDashboardState {
  const HomeDashboardInitial();
}

final class HomeDashboardLoading
    extends HomeDashboardState {
  const HomeDashboardLoading();
}

final class HomeDashboardLoaded
    extends HomeDashboardState {
  final DashboardStudentsSummaryEntity summary;

  const HomeDashboardLoaded({
    required this.summary,
  });
}