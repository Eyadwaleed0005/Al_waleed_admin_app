import 'package:alwaleed_admin/features/result_student/domain/use_case/get_student_results_by_student_id_use_case.dart';
import 'package:alwaleed_admin/features/result_student/presentation/cubit/student_exam_results_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentExamResultsCubit extends Cubit<StudentExamResultsState> {
  final GetStudentExamResultsByStudentIdUseCase
  getStudentExamResultsByStudentIdUseCase;

  StudentExamResultsCubit({
    required this.getStudentExamResultsByStudentIdUseCase,
  }) : super(const StudentExamResultsInitial());

  Future<void> getStudentExamResultsByStudentId({
    required String studentId,
  }) async {
    emit(const StudentExamResultsLoading());

    final studentExamResultsOrError =
        await getStudentExamResultsByStudentIdUseCase(studentId: studentId);

    if (isClosed) {
      return;
    }

    studentExamResultsOrError.fold(
      (appErrorModel) {
        emit(StudentExamResultsError(appErrorModel: appErrorModel));
      },
      (studentExamResultsOverview) {
        if (studentExamResultsOverview.studentExamResults.isEmpty) {
          emit(
            StudentExamResultsEmpty(
              studentExamResultsOverview: studentExamResultsOverview,
            ),
          );

          return;
        }

        emit(
          StudentExamResultsSuccess(
            studentExamResultsOverview: studentExamResultsOverview,
          ),
        );
      },
    );
  }
}
