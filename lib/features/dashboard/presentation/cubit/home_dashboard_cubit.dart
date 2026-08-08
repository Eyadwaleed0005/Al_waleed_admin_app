import 'package:alwaleed_admain/features/dashboard/domin/entities/dashboard_students_summary_entity.dart';
import 'package:alwaleed_admain/features/dashboard/domin/use_cases/get_dashboard_students_summary_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_dashboard_state.dart';

class HomeDashboardCubit
    extends Cubit<HomeDashboardState> {
  final GetDashboardStudentsSummaryUseCase
      _getDashboardStudentsSummaryUseCase;

  bool _isFetching = false;

  HomeDashboardCubit({
    required GetDashboardStudentsSummaryUseCase
        getDashboardStudentsSummaryUseCase,
  })  : _getDashboardStudentsSummaryUseCase =
            getDashboardStudentsSummaryUseCase,
        super(const HomeDashboardInitial());

  Future<void> loadStudentsSummary() async {
    if (_isFetching) {
      return;
    }

    _isFetching = true;

    final bool isFirstLoading =
        state is HomeDashboardInitial;

    if (isFirstLoading) {
      emit(const HomeDashboardLoading());
    }

    try {
      final result =
          await _getDashboardStudentsSummaryUseCase();

      if (isClosed) {
        return;
      }

      result.fold(
        (_) {
          _emitZeroSummary();
        },
        (summary) {
          emit(
            HomeDashboardLoaded(
              summary: summary,
            ),
          );
        },
      );
    } catch (_) {
      if (isClosed) {
        return;
      }

      _emitZeroSummary();
    } finally {
      _isFetching = false;
    }
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