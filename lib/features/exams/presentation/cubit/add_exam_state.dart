import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';

sealed class AddExamState {
  const AddExamState();
}

final class AddExamLoading extends AddExamState {
  const AddExamLoading();
}

final class AddExamEmpty extends AddExamState {
  const AddExamEmpty();
}

final class AddExamSuccess extends AddExamState {
  const AddExamSuccess({
    required this.grades,
  });

  final List<GradeEntity> grades;
}

final class AddExamError extends AddExamState {
  const AddExamError({
    required this.error,
  });

  final AppErrorModel error;
}