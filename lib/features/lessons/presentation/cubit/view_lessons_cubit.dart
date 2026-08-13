import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/view_lessons_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewLessonsCubit extends Cubit<ViewLessonsState> {
  ViewLessonsCubit({required StreamGradesUseCase streamGradesUseCase})
    : _streamGradesUseCase = streamGradesUseCase,
      super(const ViewLessonsInitial());

  final StreamGradesUseCase _streamGradesUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  List<GradeEntity> _grades = const [];
  List<LessonEntity> _lessons = const [];

  bool _hasFailure = false;
  bool _isInitializing = false;

  Future<void> initialize() async {
    if (_isInitializing) {
      return;
    }

    _isInitializing = true;

    try {
      await _cancelSubscriptions();

      _resetData();

      if (isClosed) {
        return;
      }

      emit(const ViewLessonsLoading());

      _watchGrades();
    } finally {
      _isInitializing = false;
    }
  }

  void searchLessons(String value) {
    final currentState = state;

    if (currentState is! ViewLessonsDataSuccess) {
      return;
    }

    emit(currentState.copyWith(searchQuery: value));
  }

  void selectGrade(String gradeId) {
    final currentState = state;

    if (currentState is! ViewLessonsDataSuccess) {
      return;
    }

    emit(currentState.copyWith(selectedGradeId: gradeId.trim()));
  }

  void selectPublicationFilter(LessonPublicationFilter filter) {
    final currentState = state;

    if (currentState is! ViewLessonsDataSuccess) {
      return;
    }

    emit(currentState.copyWith(selectedPublicationFilter: filter));
  }

  Future<void> retry() async {
    await initialize();
  }

  void _watchGrades() {
    _gradesSubscription = _streamGradesUseCase(
      activeOnly: true,
    ).listen(_onGradesResult);
  }

  void _onGradesResult(Either<AppErrorModel, List<GradeEntity>> result) {
    if (isClosed) {
      return;
    }

    result.fold(_emitFailure, (grades) {
      _grades = List<GradeEntity>.unmodifiable(grades);

      _lessons = List<LessonEntity>.unmodifiable(_createMockLessons(grades));

      _emitDataSuccess();
    });
  }

  void _emitDataSuccess() {
    if (isClosed || _hasFailure) {
      return;
    }

    final currentState = state;

    final searchQuery = currentState is ViewLessonsDataSuccess
        ? currentState.searchQuery
        : '';

    final publicationFilter = currentState is ViewLessonsDataSuccess
        ? currentState.selectedPublicationFilter
        : LessonPublicationFilter.all;

    String selectedGradeId = currentState is ViewLessonsDataSuccess
        ? currentState.selectedGradeId
        : '';

    final selectedGradeStillExists =
        selectedGradeId.isEmpty ||
        _grades.any((grade) => grade.gradeId == selectedGradeId);

    if (!selectedGradeStillExists) {
      selectedGradeId = '';
    }

    emit(
      ViewLessonsDataSuccess(
        grades: _grades,
        lessons: _lessons,
        searchQuery: searchQuery,
        selectedGradeId: selectedGradeId,
        selectedPublicationFilter: publicationFilter,
      ),
    );
  }

  void _emitFailure(AppErrorModel error) {
    if (isClosed) {
      return;
    }

    _hasFailure = true;

    emit(ViewLessonsFailure(error: error));
  }

  List<LessonEntity> _createMockLessons(List<GradeEntity> grades) {
    String gradeIdAt(int index) {
      if (grades.isEmpty) {
        return '';
      }

      return grades[index % grades.length].gradeId;
    }

    return [
      LessonEntity(
        lessonId: 'lesson_1',
        gradeId: gradeIdAt(0),
        title: 'مقدمة في علم الكيمياء',
        subtitle: 'شرح أساسيات الكيمياء وتركيب المادة',
        youtubeUrl: 'https://youtube.com/watch?v=lesson1',
        pdfFileName: 'chemistry_introduction.pdf',
        pdfFileSize: 2457600,
        pdfStoragePath: 'lessons/lesson_1/chemistry_introduction.pdf',
        isPublished: true,
      ),
      LessonEntity(
        lessonId: 'lesson_2',
        gradeId: gradeIdAt(1),
        title: 'تركيب الذرة',
        subtitle: 'مكونات الذرة والبروتونات والإلكترونات',
        youtubeUrl: 'https://youtube.com/watch?v=lesson2',
        isPublished: true,
      ),
      LessonEntity(
        lessonId: 'lesson_3',
        gradeId: gradeIdAt(2),
        title: 'الجدول الدوري الحديث',
        subtitle: 'تصنيف العناصر وخواص الجدول الدوري',
        pdfFileName: 'periodic_table.pdf',
        pdfFileSize: 1843200,
        pdfStoragePath: 'lessons/lesson_3/periodic_table.pdf',
        isPublished: false,
      ),
      LessonEntity(
        lessonId: 'lesson_4',
        gradeId: gradeIdAt(0),
        title: 'الروابط الكيميائية',
        subtitle: 'الرابطة الأيونية والرابطة التساهمية',
        youtubeUrl: 'https://youtube.com/watch?v=lesson4',
        pdfFileName: 'chemical_bonds.pdf',
        pdfFileSize: 3145728,
        pdfStoragePath: 'lessons/lesson_4/chemical_bonds.pdf',
        isPublished: true,
      ),
      LessonEntity(
        lessonId: 'lesson_5',
        gradeId: gradeIdAt(1),
        title: 'الكيمياء العضوية',
        subtitle: 'مقدمة عن المركبات العضوية والهيدروكربونات',
        youtubeUrl: 'https://youtube.com/watch?v=lesson5',
        pdfFileName: 'organic_chemistry.pdf',
        pdfFileSize: 4194304,
        pdfStoragePath: 'lessons/lesson_5/organic_chemistry.pdf',
        isPublished: false,
      ),
    ];
  }

  void _resetData() {
    _grades = const [];
    _lessons = const [];

    _hasFailure = false;
  }

  Future<void> _cancelSubscriptions() async {
    await _gradesSubscription?.cancel();

    _gradesSubscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelSubscriptions();

    return super.close();
  }
}
