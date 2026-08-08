import 'package:alwaleed_admain/core/cache/shared_preferences/shared_preference_keys.dart';
import 'package:alwaleed_admain/core/cache/shared_preferences/shared_preferences.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/cache/dashboard_local_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/models/dashboard_students_summary_model.dart';

class SharedPreferencesDashboardLocalDataSource
    implements DashboardLocalDataSource {
  const SharedPreferencesDashboardLocalDataSource();

  @override
  Future<void> cacheStudentsSummary({
    required DashboardStudentsSummaryModel summary,
  }) async {
    await Future.wait<void>([
      SharedPreferencesHelper.saveInt(
        key: SharedPreferenceKeys.dashboardTotalStudents,
        value: summary.totalStudents,
      ),
      SharedPreferencesHelper.saveInt(
        key: SharedPreferenceKeys.dashboardExpiredSubscriptions,
        value: summary.expiredSubscriptions,
      ),
      SharedPreferencesHelper.saveString(
        key: SharedPreferenceKeys.dashboardSummaryUpdatedAt,
        value: DateTime.now().toIso8601String(),
      ),
    ]);
  }

  @override
  Future<DashboardStudentsSummaryModel?> getCachedStudentsSummary() async {
    final values = await Future.wait<int?>([
      SharedPreferencesHelper.getInt(
        key: SharedPreferenceKeys.dashboardTotalStudents,
      ),
      SharedPreferencesHelper.getInt(
        key: SharedPreferenceKeys.dashboardExpiredSubscriptions,
      ),
    ]);

    final totalStudents = values[0];
    final expiredSubscriptions = values[1];

    if (totalStudents == null || expiredSubscriptions == null) {
      return null;
    }

    return DashboardStudentsSummaryModel(
      totalStudents: totalStudents,
      expiredSubscriptions: expiredSubscriptions,
    );
  }
}
