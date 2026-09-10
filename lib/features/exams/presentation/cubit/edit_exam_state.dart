import 'package:alwaleed_admin/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admin/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admin/features/grades/domain/entities/grade_entity.dart';

enum EditExamOperation {
  save,
  close,
  delete,
}

sealed class EditExamState {
  const EditExamState();
}

final class EditExamLoading extends EditExamState {
  const EditExamLoading();
}

final class EditExamError extends EditExamState {
  const EditExamError({
    required this.error,
  });

  final AppErrorModel error;
}

final class EditExamReady extends EditExamState {
  EditExamReady({
    required this.exam,
    required List<GradeEntity> grades,
    this.operation,
    this.isOperating = false,
    this.operationSucceeded = false,
    this.operationError,
  }) : grades = List<GradeEntity>.unmodifiable(grades);

  final ExamEntity exam;
  final List<GradeEntity> grades;

  final EditExamOperation? operation;
  final bool isOperating;
  final bool operationSucceeded;
  final AppErrorModel? operationError;

  bool get isEnded {
    return exam.isEnded;
  }

  bool get canEditForm {
    return !exam.isEnded;
  }

  bool get canClose {
    return exam.status == ExamStatus.published &&
        exam.questionCount > 0;
  }

  bool get canRequestDelete {
    return true;
  }
}