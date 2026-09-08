import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/delete_exam_use_case.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/get_exam_by_id_use_case.dart';
import 'package:alwaleed_admain/features/exams/domain/use_case/update_exam_use_case.dart';
import 'package:alwaleed_admain/features/exams/presentation/cubit/edit_exam_state.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/repositories/grades_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditExamCubit extends Cubit<EditExamState> {
  EditExamCubit({
    required String examId,
    required GetExamByIdUseCase getExamByIdUseCase,
    required UpdateExamUseCase updateExamUseCase,
    required DeleteExamUseCase deleteExamUseCase,
    required GradesRepository gradesRepository,
  }) : _examId = examId,
       _getExamByIdUseCase = getExamByIdUseCase,
       _updateExamUseCase = updateExamUseCase,
       _deleteExamUseCase = deleteExamUseCase,
       _gradesRepository = gradesRepository,
       super(const EditExamLoading());

  final String _examId;
  final GetExamByIdUseCase _getExamByIdUseCase;
  final UpdateExamUseCase _updateExamUseCase;
  final DeleteExamUseCase _deleteExamUseCase;
  final GradesRepository _gradesRepository;

  bool _isLoading = false;

  Future<void> initialize() async {
    if (isClosed || _isLoading) {
      return;
    }

    final current = state;

    if (current is EditExamReady &&
        (current.isOperating || current.operationSucceeded)) {
      return;
    }

    _isLoading = true;
    emit(const EditExamLoading());

    try {
      final examResult = await _getExamByIdUseCase(examId: _examId);

      if (isClosed) {
        return;
      }

      ExamEntity? loadedExam;
      AppErrorModel? loadError;

      examResult.fold(
        (error) => loadError = error,
        (exam) => loadedExam = exam,
      );

      if (loadError != null) {
        emit(EditExamError(error: loadError!));
        return;
      }

      // نحمّل كل الصفوف لعرض الصف الحالي حتى لو لم يعد نشطًا.
      final gradesResult = await _gradesRepository
          .streamGrades(activeOnly: false)
          .first;

      if (isClosed) {
        return;
      }

      gradesResult.fold(
        (error) {
          emit(EditExamError(error: error));
        },
        (List<GradeEntity> grades) {
          emit(EditExamReady(exam: loadedExam!, grades: grades));
        },
      );
    } catch (error) {
      if (!isClosed) {
        emit(EditExamError(error: FirebaseErrorHandler.handle(error)));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> retry() {
    return initialize();
  }

  Future<void> saveChanges({
    required String examName,
    required String gradeId,
    required int durationMinutes,
    required bool isPublished,
  }) async {
    final current = state;

    if (current is! EditExamReady ||
        current.isOperating ||
        current.operationSucceeded ||
        !current.canEditSettings ||
        isClosed) {
      return;
    }

    final String normalizedName = examName.trim();
    final String normalizedGradeId = gradeId.trim();

    if (normalizedName.isEmpty ||
        normalizedGradeId.isEmpty ||
        durationMinutes <= 0 ||
        !current.grades.any((grade) => grade.gradeId == normalizedGradeId)) {
      return;
    }

    final ExamEntity updatedExam = _updatedExam(
      current.exam,
      examName: normalizedName,
      gradeId: normalizedGradeId,
      durationMinutes: durationMinutes,
      status: isPublished ? ExamStatus.published : ExamStatus.unpublished,
    );

    await _executeOperation(
      current: current,
      operation: EditExamOperation.save,
      action: () => _updateExamUseCase(exam: updatedExam),
    );
  }

  Future<void> closeExam() async {
    final current = state;

    if (current is! EditExamReady ||
        current.isOperating ||
        current.operationSucceeded ||
        !current.canClose ||
        isClosed) {
      return;
    }

    final ExamEntity closedExam = _updatedExam(
      current.exam,
      status: ExamStatus.ended,
    );

    await _executeOperation(
      current: current,
      operation: EditExamOperation.close,
      action: () => _updateExamUseCase(exam: closedExam),
    );
  }

  Future<void> deleteExam() async {
    final current = state;

    if (current is! EditExamReady ||
        current.isOperating ||
        current.operationSucceeded ||
        !current.canDelete ||
        isClosed) {
      return;
    }

    await _executeOperation(
      current: current,
      operation: EditExamOperation.delete,
      action: () => _deleteExamUseCase(examId: current.exam.examId),
    );
  }

  Future<void> _executeOperation({
    required EditExamReady current,
    required EditExamOperation operation,
    required Future<Either<AppErrorModel, Unit>> Function() action,
  }) async {
    emit(
      EditExamReady(
        exam: current.exam,
        grades: current.grades,
        operation: operation,
        isOperating: true,
      ),
    );

    try {
      final result = await action();

      if (isClosed) {
        return;
      }

      result.fold(
        (error) {
          emit(
            EditExamReady(
              exam: current.exam,
              grades: current.grades,
              operation: operation,
              operationError: error,
            ),
          );
        },
        (_) {
          emit(
            EditExamReady(
              exam: current.exam,
              grades: current.grades,
              operation: operation,
              operationSucceeded: true,
            ),
          );
        },
      );
    } catch (error) {
      if (!isClosed) {
        emit(
          EditExamReady(
            exam: current.exam,
            grades: current.grades,
            operation: operation,
            operationError: FirebaseErrorHandler.handle(error),
          ),
        );
      }
    }
  }

  ExamEntity _updatedExam(
    ExamEntity exam, {
    String? examName,
    String? gradeId,
    int? durationMinutes,
    ExamStatus? status,
  }) {
    return ExamEntity(
      examId: exam.examId,
      gradeId: gradeId ?? exam.gradeId,
      examName: examName ?? exam.examName,
      durationMinutes: durationMinutes ?? exam.durationMinutes,
      questionCount: exam.questionCount,
      totalScore: exam.totalScore,
      status: status ?? exam.status,
      questions: exam.questions,
      firstAttemptAt: exam.firstAttemptAt,
      closedAt: exam.closedAt,
      createdAt: exam.createdAt,
      updatedAt: exam.updatedAt,
    );
  }
}
