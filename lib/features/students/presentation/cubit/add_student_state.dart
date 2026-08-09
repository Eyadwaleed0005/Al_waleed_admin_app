import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';

enum AddStudentStatus { idle, submitting, success, failure }

class AddStudentState {
  const AddStudentState({
    this.status = AddStudentStatus.idle,
    this.grades = const <GradeEntity>[],
    this.selectedGradeId,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.hasGeneratedPassword = false,
    this.error,
    this.createdStudent,
  });

  final AddStudentStatus status;
  final List<GradeEntity> grades;

  final String? selectedGradeId;

  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;

  final bool hasGeneratedPassword;

  final AppErrorModel? error;
  final StudentEntity? createdStudent;

  bool get isSubmitting {
    return status == AddStudentStatus.submitting;
  }

  String get selectedGradeName {
    for (final grade in grades) {
      if (grade.gradeId == selectedGradeId) {
        return grade.name;
      }
    }

    return 'اختر الصف';
  }

  AddStudentState copyWith({
    AddStudentStatus? status,
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
    StudentEntity? createdStudent,
    bool clearCreatedStudent = false,
  }) {
    return AddStudentState(
      status: status ?? this.status,
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
      hasGeneratedPassword: hasGeneratedPassword ?? this.hasGeneratedPassword,
      error: clearError ? null : error ?? this.error,
      createdStudent: clearCreatedStudent
          ? null
          : createdStudent ?? this.createdStudent,
    );
  }
}
