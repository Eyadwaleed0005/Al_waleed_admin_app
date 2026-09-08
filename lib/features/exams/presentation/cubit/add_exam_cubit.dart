import 'dart:async';

import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_draft_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/add_exam_state.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExamCubit extends Cubit<AddExamState> {
  AddExamCubit({
    required StreamGradesUseCase streamGradesUseCase,
  }) : _streamGradesUseCase = streamGradesUseCase,
       super(const AddExamLoading());

  final StreamGradesUseCase _streamGradesUseCase;

  StreamSubscription<Either<AppErrorModel, List<GradeEntity>>>?
  _gradesSubscription;

  Future<void> loadGrades() async {
    await _gradesSubscription?.cancel();

    emit(const AddExamLoading());

    _gradesSubscription = _streamGradesUseCase(
      activeOnly: true,
    ).listen(_handleGradesResult);
  }

  ExamDraftEntity createDraft({
    required String examName,
    required String gradeId,
    required int durationMinutes,
    required bool isPublished,
  }) {
    return ExamDraftEntity(
      examName: examName.trim(),
      gradeId: gradeId.trim(),
      durationMinutes: durationMinutes,
      status: isPublished
          ? ExamStatus.published
          : ExamStatus.unpublished,
    );
  }

  Future<void> retry() {
    return loadGrades();
  }

  void _handleGradesResult(
    Either<AppErrorModel, List<GradeEntity>> result,
  ) {
    result.fold(
      (error) {
        emit(
          AddExamError(error: error),
        );
      },
      (grades) {
        if (grades.isEmpty) {
          emit(const AddExamEmpty());
          return;
        }

        emit(
          AddExamSuccess(
            grades: List<GradeEntity>.unmodifiable(
              grades,
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _gradesSubscription?.cancel();

    return super.close();
  }
}