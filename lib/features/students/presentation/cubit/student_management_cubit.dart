import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/helper/students_filter_helper.dart';
import 'package:alwaleed_admain/features/students/domain/params/student_params.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/stream_students_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'student_management_state.dart';

class StudentManagementCubit extends Cubit<StudentManagementState> {
  final StreamStudentsUseCase _streamStudentsUseCase;

  final StreamGradesUseCase _streamGradesUseCase;

  StreamSubscription<Either<AppErrorModel, List<StudentEntity>>>?
  _studentsSubscription;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  List<StudentEntity> _allStudents = const [];

  List<GradeEntity> _grades = const [];

  StudentsFilterParams _filters = const StudentsFilterParams();

  bool _studentsReceived = false;
  bool _gradesReceived = false;
  bool _hasFailure = false;

  StudentManagementCubit({
    required StreamStudentsUseCase streamStudentsUseCase,
    required StreamGradesUseCase streamGradesUseCase,
  }) : _streamStudentsUseCase = streamStudentsUseCase,
       _streamGradesUseCase = streamGradesUseCase,
       super(const StudentManagementInitial());

  Future<void> watchStudentManagement() async {
    await _studentsSubscription?.cancel();
    await _gradesSubscription?.cancel();

    _studentsReceived = false;
    _gradesReceived = false;
    _hasFailure = false;

    if (isClosed) return;

    emit(const StudentManagementLoading());

    _startStudentsStream();
    _startGradesStream();
  }

  void _startStudentsStream() {
    _studentsSubscription =
        _streamStudentsUseCase(params: const StudentsFilterParams()).listen((
          result,
        ) {
          result.fold(_emitFailure, (students) {
            if (isClosed) return;

            _allStudents = students;
            _studentsReceived = true;

            _emitCurrentState();
          });
        });
  }

  void _startGradesStream() {
    _gradesSubscription = _streamGradesUseCase(activeOnly: true).listen((
      result,
    ) {
      result.fold(_emitFailure, (grades) {
        if (isClosed) return;

        _grades = grades;
        _gradesReceived = true;

        _emitCurrentState();
      });
    });
  }

  void updateSearchQuery(String searchQuery) {
    _filters = StudentsFilterParams(
      gradeId: _filters.gradeId,
      searchQuery: searchQuery,
      subscriptionFilter: _filters.subscriptionFilter,
    );

    _emitCurrentState();
  }

  void updateGradeFilter(String gradeId) {
    _filters = StudentsFilterParams(
      gradeId: gradeId,
      searchQuery: _filters.searchQuery,
      subscriptionFilter: _filters.subscriptionFilter,
    );

    _emitCurrentState();
  }

  void updateSubscriptionFilter(StudentSubscriptionFilter filter) {
    _filters = StudentsFilterParams(
      gradeId: _filters.gradeId,
      searchQuery: _filters.searchQuery,
      subscriptionFilter: filter,
    );

    _emitCurrentState();
  }

  void clearFilters() {
    _filters = const StudentsFilterParams();

    _emitCurrentState();
  }

  void _emitFailure(AppErrorModel error) {
    if (isClosed) return;

    _hasFailure = true;

    emit(StudentManagementFailure(error: error));
  }

  void _emitCurrentState() {
    if (isClosed || _hasFailure || !_studentsReceived || !_gradesReceived) {
      return;
    }

    if (_allStudents.isEmpty) {
      emit(const StudentManagementEmpty());

      return;
    }

    final filteredStudents = StudentsFilterHelper.apply(
      students: _allStudents,
      params: _filters,
    );

    if (filteredStudents.isEmpty) {
      emit(
        StudentManagementNoSearchResults(grades: _grades, filters: _filters),
      );

      return;
    }

    emit(
      StudentManagementLoaded(
        students: filteredStudents,
        grades: _grades,
        filters: _filters,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _studentsSubscription?.cancel();
    await _gradesSubscription?.cancel();

    return super.close();
  }
}
