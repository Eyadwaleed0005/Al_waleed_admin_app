import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/params/student_params.dart';

sealed class StudentManagementState {
  const StudentManagementState();
}

final class StudentManagementInitial
    extends StudentManagementState {
  const StudentManagementInitial();
}

final class StudentManagementLoading
    extends StudentManagementState {
  const StudentManagementLoading();
}

final class StudentManagementEmpty
    extends StudentManagementState {
  const StudentManagementEmpty();
}

sealed class StudentManagementContentState
    extends StudentManagementState {
  final List<GradeEntity> grades;
  final StudentsFilterParams filters;

  const StudentManagementContentState({
    required this.grades,
    required this.filters,
  });
}

final class StudentManagementLoaded
    extends StudentManagementContentState {
  final List<StudentEntity> students;

  const StudentManagementLoaded({
    required this.students,
    required super.grades,
    required super.filters,
  });
}

final class StudentManagementNoSearchResults
    extends StudentManagementContentState {
  const StudentManagementNoSearchResults({
    required super.grades,
    required super.filters,
  });
}

final class StudentManagementFailure
    extends StudentManagementState {
  final AppErrorModel error;

  const StudentManagementFailure({
    required this.error,
  });
}