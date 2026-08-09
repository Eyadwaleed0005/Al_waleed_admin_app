import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/features/dashboard/domin/entities/dashboard_students_summary_entity.dart';
import 'package:alwaleed_admain/features/dashboard/domin/use_cases/get_dashboard_students_summary_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_dashboard_state.dart';

class HomeDashboardCubit extends Cubit<HomeDashboardState> {
  HomeDashboardCubit({
    required GetDashboardStudentsSummaryUseCase
    getDashboardStudentsSummaryUseCase,
    required NetworkStatusCubit networkStatusCubit,
  }) : _getDashboardStudentsSummaryUseCase = getDashboardStudentsSummaryUseCase,
       _networkStatusCubit = networkStatusCubit,
       super(const HomeDashboardInitial());

  final GetDashboardStudentsSummaryUseCase _getDashboardStudentsSummaryUseCase;

  final NetworkStatusCubit _networkStatusCubit;

  bool _isFetching = false;

  Future<void> loadStudentsSummary() {
    return _loadStudentsSummary(
      showInitialLoading: true,
      forceNetworkCheck: false,
    );
  }

  Future<void> refreshStudentsSummary() {
    return _loadStudentsSummary(
      showInitialLoading: false,
      forceNetworkCheck: true,
    );
  }

  Future<void> _loadStudentsSummary({
    required bool showInitialLoading,
    required bool forceNetworkCheck,
  }) async {
    if (_isFetching || isClosed) {
      return;
    }

    _isFetching = true;

    if (forceNetworkCheck) {
      try {
        await _networkStatusCubit.checkConnection(forceShowOfflineBanner: true);
      } catch (_) {}
    }

    if (isClosed) {
      _isFetching = false;
      return;
    }

    final shouldShowLoading =
        showInitialLoading && state is HomeDashboardInitial;

    if (shouldShowLoading) {
      emit(const HomeDashboardLoading());
    }

    try {
      final result = await _getDashboardStudentsSummaryUseCase();

      if (isClosed) {
        return;
      }

      result.fold(
        (error) {
          _handleLoadingFailure();
        },
        (summary) {
          emit(HomeDashboardLoaded(summary: summary));
        },
      );
    } catch (_) {
      if (isClosed) {
        return;
      }

      _handleLoadingFailure();
    } finally {
      _isFetching = false;
    }
  }

  void _handleLoadingFailure() {
    if (isClosed) {
      return;
    }

    if (state is HomeDashboardLoaded) {
      return;
    }

    _emitZeroSummary();
  }

  void _emitZeroSummary() {
    if (isClosed) {
      return;
    }

    emit(
      const HomeDashboardLoaded(
        summary: DashboardStudentsSummaryEntity(
          totalStudents: 0,
          expiredSubscriptions: 0,
        ),
      ),
    );
  }
}
