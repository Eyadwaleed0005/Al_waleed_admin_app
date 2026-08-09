import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';

enum UpdateStudentStatus {
  initial,
  loading,
  ready,

  submitting,
  updateSuccess,
  updateFailure,

  disconnectingDevice,
  disconnectDeviceSuccess,
  disconnectDeviceFailure,

  renewingSubscription,
  renewalSuccess,
  renewalFailure,

  deleting,
  deleteSuccess,
  deleteFailure,

  loadFailure,
}

class UpdateStudentState {
  const UpdateStudentState({
    this.status = UpdateStudentStatus.initial,
    this.student,
    this.grades = const <GradeEntity>[],
    this.selectedGradeId,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.hasGeneratedPassword = false,
    this.error,
  });

  final UpdateStudentStatus status;

  final StudentEntity? student;

  final List<GradeEntity> grades;

  final String? selectedGradeId;

  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;

  final bool hasGeneratedPassword;

  final AppErrorModel? error;

  bool get isLoading {
    return status == UpdateStudentStatus.initial ||
        status == UpdateStudentStatus.loading;
  }

  bool get isSubmitting {
    return status == UpdateStudentStatus.submitting;
  }

  bool get isRenewingSubscription {
    return status == UpdateStudentStatus.renewingSubscription;
  }

  bool get isDisconnectingDevice {
    return status == UpdateStudentStatus.disconnectingDevice;
  }

  bool get isDeleting {
    return status == UpdateStudentStatus.deleting;
  }

  bool get isBusy {
    return isSubmitting ||
        isRenewingSubscription ||
        isDisconnectingDevice ||
        isDeleting;
  }

  bool get hasSelectedGrade {
    final gradeId = selectedGradeId;

    return gradeId != null && gradeId.isNotEmpty;
  }

  GradeEntity? get selectedGrade {
    final gradeId = selectedGradeId;

    if (gradeId == null || gradeId.isEmpty) {
      return null;
    }

    for (final grade in grades) {
      if (grade.gradeId == gradeId) {
        return grade;
      }
    }

    return null;
  }

  UpdateStudentState copyWith({
    UpdateStudentStatus? status,
    StudentEntity? student,
    bool clearStudent = false,
    List<GradeEntity>? grades,
    String? selectedGradeId,
    bool clearSelectedGradeId = false,
    DateTime? subscriptionStartDate,
    bool clearSubscriptionStartDate = false,
    DateTime? subscriptionEndDate,
    bool clearSubscriptionEndDate = false,
    bool? hasGeneratedPassword,
    AppErrorModel? error,
    bool clearError = false,
  }) {
    return UpdateStudentState(
      status: status ?? this.status,
      student: clearStudent ? null : student ?? this.student,
      grades: grades ?? this.grades,
      selectedGradeId: clearSelectedGradeId
          ? null
          : selectedGradeId ?? this.selectedGradeId,
      subscriptionStartDate: clearSubscriptionStartDate
          ? null
          : subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: clearSubscriptionEndDate
          ? null
          : subscriptionEndDate ?? this.subscriptionEndDate,
      hasGeneratedPassword:
          hasGeneratedPassword ?? this.hasGeneratedPassword,
      error: clearError ? null : error ?? this.error,
    );
  }
}