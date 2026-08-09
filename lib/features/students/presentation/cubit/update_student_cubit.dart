import 'dart:async';
import 'dart:math';
import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/helper/password_generator.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/delete_student_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/get_student_by_id_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_email_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_password_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_profile_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_subscription_use_case.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateStudentCubit extends Cubit<UpdateStudentState> {
  UpdateStudentCubit({
    required this.studentId,
    required GetStudentByIdUseCase getStudentByIdUseCase,
    required StreamGradesUseCase streamGradesUseCase,
    required UpdateStudentProfileUseCase updateStudentProfileUseCase,
    required UpdateStudentEmailUseCase updateStudentEmailUseCase,
    required UpdateStudentPasswordUseCase updateStudentPasswordUseCase,
    required UpdateStudentSubscriptionUseCase updateStudentSubscriptionUseCase,
    required DeleteStudentUseCase deleteStudentUseCase,
  }) : _getStudentByIdUseCase = getStudentByIdUseCase,
       _streamGradesUseCase = streamGradesUseCase,
       _updateStudentProfileUseCase = updateStudentProfileUseCase,
       _updateStudentEmailUseCase = updateStudentEmailUseCase,
       _updateStudentPasswordUseCase = updateStudentPasswordUseCase,
       _updateStudentSubscriptionUseCase = updateStudentSubscriptionUseCase,
       _deleteStudentUseCase = deleteStudentUseCase,
       super(const UpdateStudentState());

  final String studentId;

  final GetStudentByIdUseCase _getStudentByIdUseCase;
  final StreamGradesUseCase _streamGradesUseCase;
  final UpdateStudentProfileUseCase _updateStudentProfileUseCase;
  final UpdateStudentEmailUseCase _updateStudentEmailUseCase;
  final UpdateStudentPasswordUseCase _updateStudentPasswordUseCase;
  final UpdateStudentSubscriptionUseCase _updateStudentSubscriptionUseCase;
  final DeleteStudentUseCase _deleteStudentUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController studentNameController = TextEditingController();

  final TextEditingController studentAgeController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController subscriptionStartDateController =
      TextEditingController();

  final TextEditingController subscriptionEndDateController =
      TextEditingController();

  DateTime get subscriptionEndFirstDate {
    final startDate = state.subscriptionStartDate;

    if (startDate == null) {
      return DateTime(2000);
    }

    return startDate.add(const Duration(days: 1));
  }

  Future<void> initialize() async {
    await watchGrades();
    await loadStudent();
  }

  Future<void> watchGrades() async {
    await _gradesSubscription?.cancel();

    _gradesSubscription = _streamGradesUseCase(activeOnly: true).listen((
      result,
    ) {
      if (isClosed) {
        return;
      }

      result.fold((_) {}, (grades) {
        emit(state.copyWith(grades: grades));
      });
    });
  }

  Future<void> loadStudent() async {
    if (state.status == UpdateStudentStatus.loading) {
      return;
    }

    emit(state.copyWith(status: UpdateStudentStatus.loading, clearError: true));

    final result = await _getStudentByIdUseCase(studentId: studentId);

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(status: UpdateStudentStatus.loadFailure, error: error),
        );
      },
      (student) {
        _fillControllers(student);

        emit(
          state.copyWith(
            status: UpdateStudentStatus.ready,
            student: student,
            selectedGradeId: student.gradeId,
            subscriptionStartDate: _normalizeDate(student.subscriptionStartAt),
            subscriptionEndDate: _normalizeDate(student.subscriptionEndAt),
            hasGeneratedPassword: false,
            clearError: true,
          ),
        );
      },
    );
  }

  void _fillControllers(StudentEntity student) {
    studentNameController.text = student.name;
    studentAgeController.text = student.age.toString();
    phoneController.text = student.phoneNumber;
    emailController.text = student.email;

    passwordController.clear();

    subscriptionStartDateController.text = _formatDate(
      student.subscriptionStartAt,
    );

    subscriptionEndDateController.text = _formatDate(student.subscriptionEndAt);
  }

  void selectGrade(String gradeId) {
    emit(
      state.copyWith(
        status: UpdateStudentStatus.ready,
        selectedGradeId: gradeId,
        clearError: true,
      ),
    );
  }

  void selectSubscriptionStartDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);

    subscriptionStartDateController.text = _formatDate(normalizedDate);

    subscriptionEndDateController.clear();

    emit(
      state.copyWith(
        status: UpdateStudentStatus.ready,
        subscriptionStartDate: normalizedDate,
        clearSubscriptionEndDate: true,
        clearError: true,
      ),
    );

    formKey.currentState?.validate();
  }

  void selectSubscriptionEndDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);

    subscriptionEndDateController.text = _formatDate(normalizedDate);

    emit(
      state.copyWith(
        status: UpdateStudentStatus.ready,
        subscriptionEndDate: normalizedDate,
        clearError: true,
      ),
    );

    formKey.currentState?.validate();
  }

  void generateStrongPassword() {
    passwordController.text = PasswordGenerator.generate(length: 12);

    emit(
      state.copyWith(
        status: UpdateStudentStatus.ready,
        hasGeneratedPassword: true,
        clearError: true,
      ),
    );

    formKey.currentState?.validate();
  }

  void onPasswordChanged(String _) {
    if (!state.hasGeneratedPassword) {
      return;
    }

    emit(state.copyWith(hasGeneratedPassword: false));
  }

  Future<void> submit() async {
    if (state.isBusy) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final currentStudent = state.student;
    final gradeId = state.selectedGradeId;
    final subscriptionStartDate = state.subscriptionStartDate;
    final subscriptionEndDate = state.subscriptionEndDate;

    final age = int.tryParse(studentAgeController.text.trim());

    if (currentStudent == null ||
        gradeId == null ||
        subscriptionStartDate == null ||
        subscriptionEndDate == null ||
        age == null) {
      return;
    }

    final newName = studentNameController.text.trim();
    final newPhoneNumber = phoneController.text.trim();
    final newEmail = emailController.text.trim().toLowerCase();
    final newPassword = passwordController.text;

    final profileChanged =
        newName != currentStudent.name ||
        newPhoneNumber != currentStudent.phoneNumber ||
        age != currentStudent.age ||
        gradeId != currentStudent.gradeId;

    final emailChanged = newEmail != currentStudent.email.trim().toLowerCase();

    final passwordChanged = newPassword.isNotEmpty;

    final subscriptionChanged =
        !_isSameDate(
          subscriptionStartDate,
          currentStudent.subscriptionStartAt,
        ) ||
        !_isSameDate(subscriptionEndDate, currentStudent.subscriptionEndAt);

    final hasAnyChanges =
        profileChanged ||
        emailChanged ||
        passwordChanged ||
        subscriptionChanged;

    if (!hasAnyChanges) {
      return;
    }

    final updatedStudent = currentStudent.copyWith(
      gradeId: gradeId,
      name: newName,
      age: age,
      email: newEmail,
      phoneNumber: newPhoneNumber,
      subscriptionStartAt: subscriptionStartDate,
      subscriptionEndAt: subscriptionEndDate,
    );

    emit(
      state.copyWith(status: UpdateStudentStatus.submitting, clearError: true),
    );

    if (emailChanged) {
      final error = await _execute(
        _updateStudentEmailUseCase(student: currentStudent, newEmail: newEmail),
      );

      if (error != null) {
        _emitUpdateFailure(error);
        return;
      }
    }

    if (passwordChanged) {
      final error = await _execute(
        _updateStudentPasswordUseCase(
          studentId: currentStudent.studentId,
          newPassword: newPassword,
        ),
      );

      if (error != null) {
        _emitUpdateFailure(error);
        return;
      }
    }

    if (subscriptionChanged) {
      final error = await _execute(
        _updateStudentSubscriptionUseCase(
          student: currentStudent,
          subscriptionStartAt: subscriptionStartDate,
          subscriptionEndAt: subscriptionEndDate,
        ),
      );

      if (error != null) {
        _emitUpdateFailure(error);
        return;
      }
    }

    if (profileChanged) {
      final error = await _execute(
        _updateStudentProfileUseCase(student: updatedStudent),
      );

      if (error != null) {
        _emitUpdateFailure(error);
        return;
      }
    }

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        status: UpdateStudentStatus.updateSuccess,
        student: updatedStudent,
        clearError: true,
      ),
    );
  }

  Future<void> renewSubscription() async {
    if (state.isBusy) {
      return;
    }

    final currentStudent = state.student;

    if (currentStudent == null) {
      return;
    }

    final today = _normalizeDate(DateTime.now());

    final currentStartDate = _normalizeDate(currentStudent.subscriptionStartAt);

    final currentEndDate = _normalizeDate(currentStudent.subscriptionEndAt);

    final subscriptionExpired =
        !currentEndDate.isAfter(today) || !currentStudent.isActive;

    final newStartDate = subscriptionExpired ? today : currentStartDate;

    final renewalBaseDate = subscriptionExpired ? today : currentEndDate;

    final newEndDate = _addOneCalendarMonth(renewalBaseDate);

    final renewedStudent = currentStudent.copyWith(
      subscriptionStartAt: newStartDate,
      subscriptionEndAt: newEndDate,
      isActive: true,
    );

    emit(
      state.copyWith(
        status: UpdateStudentStatus.renewingSubscription,
        clearError: true,
      ),
    );

    final result = await _updateStudentSubscriptionUseCase(
      student: renewedStudent,
      subscriptionStartAt: newStartDate,
      subscriptionEndAt: newEndDate,
    );

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: UpdateStudentStatus.renewalFailure,
            error: error,
          ),
        );
      },
      (_) {
        subscriptionStartDateController.text = _formatDate(newStartDate);

        subscriptionEndDateController.text = _formatDate(newEndDate);

        emit(
          state.copyWith(
            status: UpdateStudentStatus.renewalSuccess,
            student: renewedStudent,
            subscriptionStartDate: newStartDate,
            subscriptionEndDate: newEndDate,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> disconnectDevice() async {
    if (state.isBusy) {
      return;
    }

    final currentStudent = state.student;

    if (currentStudent == null) {
      return;
    }

    final disconnectedStudent = currentStudent.copyWith(isLoggedIn: false);

    emit(
      state.copyWith(
        status: UpdateStudentStatus.disconnectingDevice,
        clearError: true,
      ),
    );

    final result = await _updateStudentProfileUseCase(
      student: disconnectedStudent,
    );

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: UpdateStudentStatus.disconnectDeviceFailure,
            error: error,
          ),
        );
      },
      (updatedStudent) {
        emit(
          state.copyWith(
            status: UpdateStudentStatus.disconnectDeviceSuccess,
            student: updatedStudent,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> deleteStudent() async {
    if (state.isBusy) {
      return;
    }

    final currentStudent = state.student;

    if (currentStudent == null) {
      return;
    }

    emit(
      state.copyWith(status: UpdateStudentStatus.deleting, clearError: true),
    );

    final result = await _deleteStudentUseCase(student: currentStudent);

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: UpdateStudentStatus.deleteFailure,
            error: error,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: UpdateStudentStatus.deleteSuccess,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<AppErrorModel?> _execute<T>(
    Future<Either<AppErrorModel, T>> operation,
  ) async {
    final result = await operation;

    return result.fold((error) => error, (_) => null);
  }

  void _emitUpdateFailure(AppErrorModel error) {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(status: UpdateStudentStatus.updateFailure, error: error),
    );
  }

  void dismissFailure() {
    final isFailure =
        state.status == UpdateStudentStatus.updateFailure ||
        state.status == UpdateStudentStatus.renewalFailure ||
        state.status == UpdateStudentStatus.disconnectDeviceFailure ||
        state.status == UpdateStudentStatus.deleteFailure;

    if (!isFailure) {
      return;
    }

    emit(state.copyWith(status: UpdateStudentStatus.ready, clearError: true));
  }

  void finishSecondaryOperationFeedback() {
    final isSuccess =
        state.status == UpdateStudentStatus.renewalSuccess ||
        state.status == UpdateStudentStatus.disconnectDeviceSuccess;

    if (!isSuccess) {
      return;
    }

    emit(state.copyWith(status: UpdateStudentStatus.ready, clearError: true));
  }

  DateTime _addOneCalendarMonth(DateTime date) {
    final targetYear = date.month == 12 ? date.year + 1 : date.year;

    final targetMonth = date.month == 12 ? 1 : date.month + 1;

    final lastDay = DateTime(targetYear, targetMonth + 1, 0).day;

    final targetDay = min(date.day, lastDay);

    return DateTime(targetYear, targetMonth, targetDay);
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);

    final day = normalizedDate.day.toString().padLeft(2, '0');

    final month = normalizedDate.month.toString().padLeft(2, '0');

    return '$day/$month/${normalizedDate.year}';
  }

  @override
  Future<void> close() async {
    await _gradesSubscription?.cancel();

    studentNameController.dispose();
    studentAgeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    subscriptionStartDateController.dispose();
    subscriptionEndDateController.dispose();

    return super.close();
  }
}
