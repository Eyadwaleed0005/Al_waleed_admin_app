import 'dart:async';
import 'dart:math';

import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/core/helper/password_generator.dart';
import 'package:alwaleed_admin/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admin/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/delete_student_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/get_student_by_id_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/update_student_email_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/update_student_password_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/update_student_profile_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/update_student_subscription_use_case.dart';
import 'package:alwaleed_admin/features/students/presentation/cubit/update_student_state.dart';
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
       super(const UpdateStudentState()) {
    _addFormListeners();
  }

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
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController subscriptionStartDateController =
      TextEditingController();

  final TextEditingController subscriptionEndDateController =
      TextEditingController();

  bool _isFillingControllers = false;

  DateTime get subscriptionEndFirstDate {
    final startDate = state.subscriptionStartDate;

    if (startDate == null) {
      return DateTime(2000);
    }

    return startDate.add(const Duration(days: 1));
  }

  void _addFormListeners() {
    studentNameController.addListener(_updateHasChanges);
    phoneController.addListener(_updateHasChanges);
    emailController.addListener(_updateHasChanges);
    passwordController.addListener(_updateHasChanges);
  }

  void _removeFormListeners() {
    studentNameController.removeListener(_updateHasChanges);
    phoneController.removeListener(_updateHasChanges);
    emailController.removeListener(_updateHasChanges);
    passwordController.removeListener(_updateHasChanges);
  }

  Future<void> initialize() async {
    await watchGrades();

    if (isClosed) {
      return;
    }

    await loadStudent();
  }

  Future<void> watchGrades() async {
    await _gradesSubscription?.cancel();

    if (isClosed) {
      return;
    }

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
    if (isClosed || state.status == UpdateStudentStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        status: UpdateStudentStatus.loading,
        hasChanges: false,
        clearError: true,
      ),
    );

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

        final startAt = student.subscriptionStartAt;
        final endAt = student.subscriptionEndAt;

        emit(
          state.copyWith(
            status: UpdateStudentStatus.ready,
            student: student,
            selectedGradeId: student.gradeId,
            subscriptionStartDate: startAt == null
                ? null
                : _normalizeDate(startAt),
            clearSubscriptionStartDate: startAt == null,
            subscriptionEndDate: endAt == null ? null : _normalizeDate(endAt),
            clearSubscriptionEndDate: endAt == null,
            hasGeneratedPassword: false,
            hasChanges: false,
            clearError: true,
          ),
        );
      },
    );
  }

  void _fillControllers(StudentEntity student) {
    _isFillingControllers = true;

    try {
      studentNameController.text = student.name;
      phoneController.text = student.phoneNumber;
      emailController.text = student.email;
      passwordController.clear();

      subscriptionStartDateController.text = _formatDate(
        student.subscriptionStartAt,
      );

      subscriptionEndDateController.text = _formatDate(
        student.subscriptionEndAt,
      );
    } finally {
      _isFillingControllers = false;
    }
  }

  void selectGrade(String gradeId) {
    if (isClosed || state.isBusy) {
      return;
    }

    emit(
      state.copyWith(
        status: UpdateStudentStatus.ready,
        selectedGradeId: gradeId.trim(),
        clearError: true,
      ),
    );

    _updateHasChanges();
  }

  void selectSubscriptionStartDate(DateTime date) {
    if (isClosed || state.isBusy) {
      return;
    }

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

    _updateHasChanges();
  }

  void selectSubscriptionEndDate(DateTime date) {
    if (isClosed || state.isBusy) {
      return;
    }

    final normalizedDate = _normalizeDate(date);

    subscriptionEndDateController.text = _formatDate(normalizedDate);

    emit(
      state.copyWith(
        status: UpdateStudentStatus.ready,
        subscriptionEndDate: normalizedDate,
        clearError: true,
      ),
    );

    _updateHasChanges();
  }

  void generateStrongPassword() {
    if (isClosed || state.isBusy) {
      return;
    }

    passwordController.text = PasswordGenerator.generate(length: 12);

    emit(
      state.copyWith(
        status: UpdateStudentStatus.ready,
        hasGeneratedPassword: true,
        clearError: true,
      ),
    );

    _updateHasChanges();
  }

  void onPasswordChanged(String _) {
    if (isClosed || state.isBusy) {
      return;
    }

    if (state.hasGeneratedPassword) {
      emit(state.copyWith(hasGeneratedPassword: false));
    }

    _updateHasChanges();
  }

  void _updateHasChanges() {
    if (isClosed || _isFillingControllers) {
      return;
    }

    final hasChanges = _calculateHasChanges();

    if (hasChanges == state.hasChanges) {
      return;
    }

    emit(state.copyWith(hasChanges: hasChanges));
  }

  bool _calculateHasChanges() {
    final currentStudent = state.student;

    if (currentStudent == null) {
      return false;
    }

    final nameChanged =
        studentNameController.text.trim() != currentStudent.name.trim();

    final phoneChanged =
        phoneController.text.trim() != currentStudent.phoneNumber.trim();

    final emailChanged =
        emailController.text.trim().toLowerCase() !=
        currentStudent.email.trim().toLowerCase();

    final passwordChanged = passwordController.text.isNotEmpty;

    final gradeChanged = state.selectedGradeId != currentStudent.gradeId;

    final subscriptionStartChanged = !_isSameDate(
      state.subscriptionStartDate,
      currentStudent.subscriptionStartAt,
    );

    final subscriptionEndChanged = !_isSameDate(
      state.subscriptionEndDate,
      currentStudent.subscriptionEndAt,
    );

    return nameChanged ||
        phoneChanged ||
        emailChanged ||
        passwordChanged ||
        gradeChanged ||
        subscriptionStartChanged ||
        subscriptionEndChanged;
  }

  Future<void> submit() async {
    if (isClosed || state.isBusy || !state.hasChanges) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final currentStudent = state.student;
    final gradeId = state.selectedGradeId?.trim();
    final subscriptionStartDate = state.subscriptionStartDate;
    final subscriptionEndDate = state.subscriptionEndDate;

    if (currentStudent == null || gradeId == null || gradeId.isEmpty) {
      return;
    }

    final subscriptionChanged =
        !_isSameDate(
          subscriptionStartDate,
          currentStudent.subscriptionStartAt,
        ) ||
        !_isSameDate(subscriptionEndDate, currentStudent.subscriptionEndAt);

    if (subscriptionChanged &&
        (subscriptionStartDate == null || subscriptionEndDate == null)) {
      return;
    }

    final newName = studentNameController.text.trim();
    final newPhoneNumber = phoneController.text.trim();
    final newEmail = emailController.text.trim().toLowerCase();
    final newPassword = passwordController.text;

    final profileChanged =
        newName != currentStudent.name ||
        newPhoneNumber != currentStudent.phoneNumber ||
        gradeId != currentStudent.gradeId;

    final emailChanged = newEmail != currentStudent.email.trim().toLowerCase();
    final passwordChanged = newPassword.isNotEmpty;

    var savedStudent = currentStudent;

    emit(
      state.copyWith(status: UpdateStudentStatus.submitting, clearError: true),
    );

    if (emailChanged) {
      final result = await _updateStudentEmailUseCase(
        student: savedStudent,
        newEmail: newEmail,
      );

      if (isClosed) {
        return;
      }

      final error = result.fold<AppErrorModel?>((error) => error, (_) => null);

      if (error != null) {
        _emitUpdateFailure(error);
        return;
      }

      savedStudent = savedStudent.copyWith(email: newEmail);

      emit(state.copyWith(student: savedStudent));
    }

    if (passwordChanged) {
      final error = await _execute(
        _updateStudentPasswordUseCase(
          studentId: savedStudent.studentId,
          newPassword: newPassword,
        ),
      );

      if (isClosed) {
        return;
      }

      if (error != null) {
        _emitUpdateFailure(error);
        return;
      }

      _isFillingControllers = true;

      try {
        passwordController.clear();
      } finally {
        _isFillingControllers = false;
      }
    }

    if (profileChanged) {
      final result = await _updateStudentProfileUseCase(
        student: savedStudent.copyWith(
          gradeId: gradeId,
          name: newName,
          phoneNumber: newPhoneNumber,
        ),
      );

      if (isClosed) {
        return;
      }

      final error = result.fold<AppErrorModel?>((error) => error, (student) {
        savedStudent = student;
        return null;
      });

      if (error != null) {
        _emitUpdateFailure(error);
        return;
      }

      emit(state.copyWith(student: savedStudent));
    }

    if (subscriptionChanged &&
        subscriptionStartDate != null &&
        subscriptionEndDate != null) {
      final error = await _execute(
        _updateStudentSubscriptionUseCase(
          student: savedStudent,
          subscriptionStartAt: subscriptionStartDate,
          subscriptionEndAt: subscriptionEndDate,
        ),
      );

      if (isClosed) {
        return;
      }

      if (error != null) {
        _emitUpdateFailure(error);
        return;
      }

      final refreshedResult = await _getStudentByIdUseCase(
        studentId: savedStudent.studentId,
      );

      if (isClosed) {
        return;
      }

      final refreshError = refreshedResult.fold<AppErrorModel?>(
        (error) => error,
        (student) {
          savedStudent = student;
          return null;
        },
      );

      if (refreshError != null) {
        _emitUpdateFailure(refreshError);
        return;
      }
    }

    _fillControllers(savedStudent);

    final savedStartAt = savedStudent.subscriptionStartAt;
    final savedEndAt = savedStudent.subscriptionEndAt;

    emit(
      state.copyWith(
        status: UpdateStudentStatus.updateSuccess,
        student: savedStudent,
        subscriptionStartDate: savedStartAt == null
            ? null
            : _normalizeDate(savedStartAt),
        clearSubscriptionStartDate: savedStartAt == null,
        subscriptionEndDate: savedEndAt == null
            ? null
            : _normalizeDate(savedEndAt),
        clearSubscriptionEndDate: savedEndAt == null,
        hasGeneratedPassword: false,
        hasChanges: false,
        clearError: true,
      ),
    );
  }

  Future<void> renewSubscription() async {
    if (isClosed || state.isBusy) {
      return;
    }

    final currentStudent = state.student;

    if (currentStudent == null) {
      return;
    }

    final today = _normalizeDate(DateTime.now());

    final storedStartAt = currentStudent.subscriptionStartAt;
    final storedEndAt = currentStudent.subscriptionEndAt;

    final currentStartDate = storedStartAt == null
        ? null
        : _normalizeDate(storedStartAt);

    final currentEndDate = storedEndAt == null
        ? null
        : _normalizeDate(storedEndAt);

    final canExtendSubscription =
        currentStudent.isActive &&
        currentStartDate != null &&
        currentEndDate != null &&
        currentEndDate.isAfter(today);

    final newStartDate = canExtendSubscription ? (currentStartDate) : today;

    final renewalBaseDate = canExtendSubscription ? (currentEndDate) : today;

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

        _updateHasChanges();
      },
    );
  }

  Future<void> disconnectDevice() async {
    if (isClosed || state.isBusy) {
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

        _updateHasChanges();
      },
    );
  }

  Future<void> deleteStudent() async {
    if (isClosed || state.isBusy) {
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
      state.copyWith(
        status: UpdateStudentStatus.updateFailure,
        hasChanges: _calculateHasChanges(),
        error: error,
      ),
    );
  }

  void dismissFailure() {
    if (isClosed) {
      return;
    }

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
    if (isClosed) {
      return;
    }

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

  bool _isSameDate(DateTime? first, DateTime? second) {
    if (first == null || second == null) {
      return first == null && second == null;
    }

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    final normalizedDate = _normalizeDate(date);
    final day = normalizedDate.day.toString().padLeft(2, '0');
    final month = normalizedDate.month.toString().padLeft(2, '0');

    return '$day/$month/${normalizedDate.year}';
  }

  @override
  Future<void> close() async {
    await _gradesSubscription?.cancel();

    _removeFormListeners();

    studentNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    subscriptionStartDateController.dispose();
    subscriptionEndDateController.dispose();

    return super.close();
  }
}
