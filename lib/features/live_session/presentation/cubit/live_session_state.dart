import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/live_session/domain/entities/live_session_entity.dart';
import 'package:alwaleed_admain/features/live_session/domain/entities/meeting_type.dart';

enum LiveSessionStatus {
  initial,
  loading,
  empty,
  loaded,
  saving,
  saveSuccess,
  deleting,
  deleteSuccess,
  failure,
}

class LiveSessionState {
  const LiveSessionState({
    this.status = LiveSessionStatus.initial,
    this.grades = const [],
    this.isGradesLoading = false,
    this.liveSession,
    this.selectedGradeId,
    this.selectedMeetingType,
    this.meetingUrl = '',
    this.errorModel,
  });

  final LiveSessionStatus status;

  final List<GradeEntity> grades;
  final bool isGradesLoading;

  final LiveSessionEntity? liveSession;

  final String? selectedGradeId;
  final MeetingType? selectedMeetingType;
  final String meetingUrl;

  final AppErrorModel? errorModel;

  bool get isLoading {
    return status == LiveSessionStatus.loading;
  }

  bool get isSaving {
    return status == LiveSessionStatus.saving;
  }

  bool get isDeleting {
    return status == LiveSessionStatus.deleting;
  }

  bool get isBusy {
    return isLoading || isSaving || isDeleting;
  }

  bool get hasLiveSession {
    return liveSession != null;
  }

  GradeEntity? get selectedGrade {
    final gradeId = selectedGradeId;

    if (gradeId == null) {
      return null;
    }

    for (final grade in grades) {
      if (grade.gradeId == gradeId) {
        return grade;
      }
    }

    return null;
  }

  bool get hasValidGrade {
    return selectedGrade != null && AppValidator.grade(selectedGradeId) == null;
  }

  bool get hasValidMeetingType {
    return selectedMeetingType != null;
  }

  bool get hasValidMeetingUrl {
    return AppValidator.liveSessionUrl(meetingUrl) == null;
  }

  bool get hasValidForm {
    return hasValidGrade && hasValidMeetingType && hasValidMeetingUrl;
  }

  bool get canSave {
    return hasValidForm && !isBusy && !hasLiveSession;
  }

  LiveSessionState copyWith({
    LiveSessionStatus? status,
    List<GradeEntity>? grades,
    bool? isGradesLoading,
    LiveSessionEntity? liveSession,
    bool clearLiveSession = false,
    String? selectedGradeId,
    bool clearSelectedGrade = false,
    MeetingType? selectedMeetingType,
    bool clearSelectedMeetingType = false,
    String? meetingUrl,
    AppErrorModel? errorModel,
    bool clearError = false,
  }) {
    return LiveSessionState(
      status: status ?? this.status,
      grades: grades ?? this.grades,
      isGradesLoading: isGradesLoading ?? this.isGradesLoading,
      liveSession: clearLiveSession ? null : liveSession ?? this.liveSession,
      selectedGradeId: clearSelectedGrade
          ? null
          : selectedGradeId ?? this.selectedGradeId,
      selectedMeetingType: clearSelectedMeetingType
          ? null
          : selectedMeetingType ?? this.selectedMeetingType,
      meetingUrl: meetingUrl ?? this.meetingUrl,
      errorModel: clearError ? null : errorModel ?? this.errorModel,
    );
  }
}
