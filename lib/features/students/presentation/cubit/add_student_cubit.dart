import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/helper/app_validator.dart';
import 'package:alwaleed_admain/core/helper/password_generator.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/params/student_params.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/create_student_use_case.dart';
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

  final TextEditingController studentAgeController = TextEditingController();

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

    _gradesSubscription = _streamGradesUseCase(activeOnly: true).listen(
      (result) {
        if (isClosed) {
          return;
        }

        result.fold(
          (_) {
            return;
          },
          (grades) {
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
          },
        );
      },
      onError: (Object _, StackTrace __) {
        if (isClosed) {
          return;
        }
      },
    );
  }

  void selectGrade(String gradeId) {
    emit(
      state.copyWith(
        status: AddStudentStatus.idle,
        selectedGradeId: gradeId,
        clearError: true,
      ),
    );
  }

  void generateStrongPassword() {
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
    if (!state.hasGeneratedPassword) {
      return;
    }

    emit(state.copyWith(hasGeneratedPassword: false));
  }

  void selectSubscriptionStartDate(DateTime date) {
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

  Future<void> submit() async {
    if (state.isSubmitting) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final isFormValid = formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    final gradeId = state.selectedGradeId;

    final subscriptionStartDate = state.subscriptionStartDate;

    final subscriptionEndDate = state.subscriptionEndDate;

    final age = int.tryParse(studentAgeController.text.trim());

    final startDateError = AppValidator.subscriptionStartDate(
      subscriptionStartDate,
    );

    final endDateError = AppValidator.subscriptionEndDate(
      startDate: subscriptionStartDate,
      endDate: subscriptionEndDate,
    );

    if (gradeId == null ||
        subscriptionStartDate == null ||
        subscriptionEndDate == null ||
        age == null ||
        startDateError != null ||
        endDateError != null) {
      formKey.currentState?.validate();
      return;
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
        age: age,
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
    if (state.status != AddStudentStatus.failure) {
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
    studentAgeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    subscriptionStartDateController.dispose();
    subscriptionEndDateController.dispose();

    return super.close();
  }
}
