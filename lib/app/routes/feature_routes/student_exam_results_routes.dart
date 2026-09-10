import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/features/result_student/domain/use_case/get_student_results_by_student_id_use_case.dart';
import 'package:alwaleed_admain/features/result_student/presentation/cubit/student_exam_results_cubit.dart';
import 'package:alwaleed_admain/features/result_student/presentation/screens/student_exam_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class StudentExamResultsRoutes {
  const StudentExamResultsRoutes._();

  static final GetIt _getIt = GetIt.instance;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name != RouteNames.studentExamResultsScreen) {
      return null;
    }

    final Object? argument = settings.arguments;

    if (argument is! String || argument.trim().isEmpty) {
      return null;
    }

    final String studentId = argument.trim();

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
        return BlocProvider<StudentExamResultsCubit>(
          create: (_) {
            return StudentExamResultsCubit(
              getStudentExamResultsByStudentIdUseCase:
                  _getIt.get<GetStudentExamResultsByStudentIdUseCase>(),
            )..getStudentExamResultsByStudentId(
                studentId: studentId,
              );
          },
          child: StudentExamResultsScreen(
            studentId: studentId,
          ),
        );
      },
    );
  }
}