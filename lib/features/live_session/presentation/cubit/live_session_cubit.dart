import 'dart:async';

import 'package:alwaleed_admain/core/connection/cubit/network_status_cubit.dart';
import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/entities/live_session_entity.dart';
import 'package:alwaleed_admain/features/live_session/domain/entities/meeting_type.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/delete_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/get_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/domain/use_case/save_live_session_use_case.dart';
import 'package:alwaleed_admain/features/live_session/presentation/cubit/live_session_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveSessionCubit extends Cubit<LiveSessionState> {
  LiveSessionCubit({
    required StreamGradesUseCase streamGradesUseCase,
    required GetLiveSessionUseCase getLiveSessionUseCase,
    required SaveLiveSessionUseCase saveLiveSessionUseCase,
    required DeleteLiveSessionUseCase deleteLiveSessionUseCase,
    required NetworkStatusCubit networkStatusCubit,
  }) : _streamGradesUseCase = streamGradesUseCase,
       _getLiveSessionUseCase = getLiveSessionUseCase,
       _saveLiveSessionUseCase = saveLiveSessionUseCase,
       _deleteLiveSessionUseCase = deleteLiveSessionUseCase,
       _networkStatusCubit = networkStatusCubit,
       super(const LiveSessionState()) {
    sessionLinkController.addListener(_handleMeetingUrlChanged);
  }

  final StreamGradesUseCase _streamGradesUseCase;
  final GetLiveSessionUseCase _getLiveSessionUseCase;
  final SaveLiveSessionUseCase _saveLiveSessionUseCase;
  final DeleteLiveSessionUseCase _deleteLiveSessionUseCase;
  final NetworkStatusCubit _networkStatusCubit;

  final TextEditingController sessionLinkController = TextEditingController();

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  bool _isInitialized = false;
  bool _isUpdatingController = false;
  bool _isFetchingLiveSession = false;

  Future<void> initialize() async {
    if (_isInitialized || isClosed) {
      return;
    }

    _isInitialized = true;

    await watchGrades();
    await loadLiveSession();
  }

  Future<void> watchGrades() async {
    await _gradesSubscription?.cancel();

    if (isClosed) {
      return;
    }

    emit(state.copyWith(isGradesLoading: true, clearError: true));

    _gradesSubscription = _streamGradesUseCase(activeOnly: true).listen(
      (result) {
        if (isClosed) {
          return;
        }

        result.fold(
          (errorModel) {
            emit(
              state.copyWith(isGradesLoading: false, errorModel: errorModel),
            );
          },
          (grades) {
            emit(
              state.copyWith(
                grades: grades,
                isGradesLoading: false,
                clearError: true,
              ),
            );
          },
        );
      },
      onError: (Object _, StackTrace __) {
        if (isClosed) {
          return;
        }

        emit(state.copyWith(isGradesLoading: false));
      },
    );
  }

  Future<void> loadLiveSession() {
    return _loadLiveSession(showInitialLoading: true, forceNetworkCheck: false);
  }

  Future<void> refreshLiveSession() {
    return _loadLiveSession(showInitialLoading: false, forceNetworkCheck: true);
  }

  Future<void> _loadLiveSession({
    required bool showInitialLoading,
    required bool forceNetworkCheck,
  }) async {
    if (_isFetchingLiveSession || state.isSaving || state.isDeleting) {
      return;
    }

    if (isClosed) {
      return;
    }

    _isFetchingLiveSession = true;

    try {
      if (forceNetworkCheck) {
        try {
          await _networkStatusCubit.checkConnection(
            forceShowOfflineBanner: true,
          );
        } catch (_) {}
      }

      if (isClosed) {
        return;
      }

      final shouldShowLoading =
          showInitialLoading && state.status == LiveSessionStatus.initial;

      if (shouldShowLoading) {
        emit(
          state.copyWith(status: LiveSessionStatus.loading, clearError: true),
        );
      }

      final result = await _getLiveSessionUseCase();

      if (isClosed) {
        return;
      }

      result.fold(
        (errorModel) {
          // Refresh failures are handled by the network banner.
          // Only the initial loading failure changes the screen state.
          if (!showInitialLoading) {
            return;
          }

          emit(
            state.copyWith(
              status: LiveSessionStatus.failure,
              errorModel: errorModel,
            ),
          );
        },
        (liveSession) {
          if (liveSession == null) {
            emit(
              state.copyWith(
                status: LiveSessionStatus.empty,
                clearLiveSession: true,
                clearError: true,
              ),
            );

            return;
          }

          emit(
            state.copyWith(
              status: LiveSessionStatus.loaded,
              liveSession: liveSession,
              clearError: true,
            ),
          );
        },
      );
    } finally {
      _isFetchingLiveSession = false;
    }
  }

  void selectGrade(String gradeId) {
    if (gradeId == state.selectedGradeId) {
      return;
    }

    _setControllerText('');

    emit(
      state.copyWith(
        selectedGradeId: gradeId,
        clearSelectedMeetingType: true,
        meetingUrl: '',
        clearError: true,
      ),
    );
  }

  void selectMeetingType(MeetingType meetingType) {
    if (meetingType == state.selectedMeetingType) {
      return;
    }

    emit(state.copyWith(selectedMeetingType: meetingType, clearError: true));
  }

  void _handleMeetingUrlChanged() {
    if (_isUpdatingController || isClosed) {
      return;
    }

    final meetingUrl = sessionLinkController.text;

    if (meetingUrl == state.meetingUrl) {
      return;
    }

    emit(state.copyWith(meetingUrl: meetingUrl, clearError: true));
  }

  void _setControllerText(String value) {
    if (sessionLinkController.text == value) {
      return;
    }

    _isUpdatingController = true;

    try {
      sessionLinkController.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    } finally {
      _isUpdatingController = false;
    }
  }

  Future<void> saveLiveSession() async {
    if (!state.canSave || _isFetchingLiveSession) {
      return;
    }

    final gradeId = state.selectedGradeId;
    final meetingType = state.selectedMeetingType;

    if (gradeId == null || meetingType == null) {
      return;
    }

    final liveSession = LiveSessionEntity(
      gradeId: gradeId,
      platformType: meetingType,
      meetingUrl: state.meetingUrl.trim(),
    );

    emit(state.copyWith(status: LiveSessionStatus.saving, clearError: true));

    final result = await _saveLiveSessionUseCase(liveSession: liveSession);

    if (isClosed) {
      return;
    }

    result.fold(
      (errorModel) {
        emit(
          state.copyWith(
            status: LiveSessionStatus.failure,
            errorModel: errorModel,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: LiveSessionStatus.saveSuccess,
            liveSession: liveSession,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> deleteLiveSession() async {
    final liveSession = state.liveSession;
    if (liveSession == null ||
        state.isDeleting ||
        state.isSaving ||
        _isFetchingLiveSession) {
      return;
    }
    emit(state.copyWith(status: LiveSessionStatus.deleting, clearError: true));
    final result = await _deleteLiveSessionUseCase(
      gradeId: liveSession.gradeId,
    );

    if (isClosed) {
      return;
    }

    result.fold(
      (errorModel) {
        emit(
          state.copyWith(
            status: LiveSessionStatus.failure,
            liveSession: liveSession,
            errorModel: errorModel,
          ),
        );
      },
      (_) {
        _setControllerText('');

        emit(
          state.copyWith(
            status: LiveSessionStatus.deleteSuccess,
            clearLiveSession: true,
            clearSelectedGrade: true,
            clearSelectedMeetingType: true,
            meetingUrl: '',
            clearError: true,
          ),
        );
      },
    );
  }

  void clearError() {
    if (state.errorModel == null) {
      return;
    }
    emit(state.copyWith(clearError: true));
  }

  @override
  Future<void> close() async {
    await _gradesSubscription?.cancel();
    sessionLinkController.removeListener(_handleMeetingUrlChanged);
    sessionLinkController.dispose();
    return super.close();
  }
}
