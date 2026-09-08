import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_entity.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';

sealed class ViewExamsState {
  const ViewExamsState();
}

final class ViewExamsLoading extends ViewExamsState {
  const ViewExamsLoading();
}

final class ViewExamsEmpty extends ViewExamsState {
  const ViewExamsEmpty({
    required this.grades,
  });

  final List<GradeEntity> grades;
}

final class ViewExamsSuccess extends ViewExamsState {
  const ViewExamsSuccess({
    required this.exams,
    required this.grades,
  });

  final List<ExamEntity> exams;
  final List<GradeEntity> grades;
}

final class ViewExamsError extends ViewExamsState {
  const ViewExamsError({
    required this.error,
  });

  final AppErrorModel error;
}