import 'dart:async';

import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/core/helper/app_validator.dart';
import 'package:alwaleed_admin/core/helper/password_generator.dart';
import 'package:alwaleed_admin/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admin/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admin/features/students/domain/params/student_params.dart';
import 'package:alwaleed_admin/features/students/domain/use_cases/create_student_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_student_state.dart';

class AddStudentCubit extends Cubit<AddStudentState> {
  AddStudentCubit({
    required CreateStudentUseCase createStudentUseCase,
    required StreamGradesUseCase streamGradesUseCase,
  }) : _createStudentUseCase = createStudentUseCase,
       _streamGradesUseCase = streamGradesUseCase,
       super(const AddStudentState());

  final CreateStudentUseCase _createStudentUseCase;
  final StreamGradesUseCase _streamGradesUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController subscriptionStartDateController =
      TextEditingController();

  final TextEditingController subscriptionEndDateController =
      TextEditingController();

  DateTime get today {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  DateTime get subscriptionEndFirstDate {
    final startDate = state.subscriptionStartDate;

    if (startDate == null) {
      return today;
    }

    return startDate.add(const Duration(days: 1));
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
        final selectedGradeStillExists = grades.any((grade) {
          return grade.gradeId == state.selectedGradeId;
        });

        emit(
          state.copyWith(
            grades: grades,
            clearSelectedGradeId:
                state.selectedGradeId != null && !selectedGradeStillExists,
          ),
        );
      });
    }, onError: (Object _, StackTrace __) {});
  }

  void selectGrade(String gradeId) {
    if (isClosed || state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        status: AddStudentStatus.idle,
        selectedGradeId: gradeId.trim(),
        clearError: true,
      ),
    );
  }

  void generateStrongPassword() {
    if (isClosed || state.isSubmitting) {
      return;
    }

    final generatedPassword = PasswordGenerator.generate(length: 12);

    _setControllerText(controller: passwordController, text: generatedPassword);

    _setControllerText(
      controller: confirmPasswordController,
      text: generatedPassword,
    );

    emit(
      state.copyWith(
        status: AddStudentStatus.idle,
        hasGeneratedPassword: true,
        clearError: true,
      ),
    );

    formKey.currentState?.validate();
  }

  void onPasswordChanged(String _) {
    if (isClosed || state.isSubmitting || !state.hasGeneratedPassword) {
      return;
    }

    emit(state.copyWith(hasGeneratedPassword: false));
  }

  void selectSubscriptionStartDate(DateTime date) {
    if (isClosed || state.isSubmitting) {
      return;
    }

    final normalizedDate = _normalizeDate(date);

    subscriptionStartDateController.text = _formatDate(normalizedDate);
    subscriptionEndDateController.clear();

    emit(
      state.copyWith(
        status: AddStudentStatus.idle,
        subscriptionStartDate: normalizedDate,
        clearSubscriptionEndDate: true,
        clearError: true,
      ),
    );

    formKey.currentState?.validate();
  }

  void selectSubscriptionEndDate(DateTime date) {
    if (isClosed || state.isSubmitting) {
      return;
    }

    final normalizedDate = _normalizeDate(date);

    subscriptionEndDateController.text = _formatDate(normalizedDate);

    emit(
      state.copyWith(
        status: AddStudentStatus.idle,
        subscriptionEndDate: normalizedDate,
        clearError: true,
      ),
    );

    formKey.currentState?.validate();
  }

  void clearSubscriptionDates() {
    if (isClosed || state.isSubmitting) {
      return;
    }

    subscriptionStartDateController.clear();
    subscriptionEndDateController.clear();

    emit(
      state.copyWith(
        status: AddStudentStatus.idle,
        clearSubscriptionStartDate: true,
        clearSubscriptionEndDate: true,
        clearError: true,
      ),
    );

    formKey.currentState?.validate();
  }

  Future<void> submit() async {
    if (isClosed || state.isSubmitting) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final isFormValid = formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    final gradeId = state.selectedGradeId?.trim();

    if (gradeId == null || gradeId.isEmpty) {
      return;
    }

    final subscriptionStartDate = state.subscriptionStartDate;
    final subscriptionEndDate = state.subscriptionEndDate;

    final hasSubscriptionDates =
        subscriptionStartDate != null || subscriptionEndDate != null;

    if (hasSubscriptionDates) {
      final startDateError = AppValidator.subscriptionStartDate(
        subscriptionStartDate,
      );

      final endDateError = AppValidator.subscriptionEndDate(
        startDate: subscriptionStartDate,
        endDate: subscriptionEndDate,
      );

      if (subscriptionStartDate == null ||
          subscriptionEndDate == null ||
          startDateError != null ||
          endDateError != null) {
        formKey.currentState?.validate();
        return;
      }
    }

    emit(
      state.copyWith(
        status: AddStudentStatus.submitting,
        clearError: true,
        clearCreatedStudent: true,
      ),
    );

    final result = await _createStudentUseCase(
      params: CreateStudentParams(
        gradeId: gradeId,
        name: studentNameController.text,
        phoneNumber: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
        subscriptionStartAt: subscriptionStartDate,
        subscriptionEndAt: subscriptionEndDate,
      ),
    );

    if (isClosed) {
      return;
    }

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: AddStudentStatus.failure,
            error: error,
            clearCreatedStudent: true,
          ),
        );
      },
      (student) {
        emit(
          state.copyWith(
            status: AddStudentStatus.success,
            createdStudent: student,
            clearError: true,
          ),
        );
      },
    );
  }

  void dismissFailure() {
    if (isClosed || state.status != AddStudentStatus.failure) {
      return;
    }

    emit(state.copyWith(status: AddStudentStatus.idle, clearError: true));
  }

  void _setControllerText({
    required TextEditingController controller,
    required String text,
  }) {
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Future<void> close() async {
    await _gradesSubscription?.cancel();

    studentNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    subscriptionStartDateController.dispose();
    subscriptionEndDateController.dispose();

    return super.close();
  }
}
