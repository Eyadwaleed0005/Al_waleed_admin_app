import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/create_student_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/delete_student_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/get_student_by_id_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/stream_students_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_email_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_password_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_profile_use_case.dart';
import 'package:alwaleed_admain/features/students/domain/use_cases/update_student_subscription_use_case.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/add_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/student_management_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/cubit/update_student_cubit.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/add_student_screen.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/student_management_screen.dart';
import 'package:alwaleed_admain/features/students/presentation/screens/update_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class StudentRoutes {
  const StudentRoutes._();

  static final GetIt _getIt = GetIt.instance;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.studentManagementScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return BlocProvider<StudentManagementCubit>(
              create: (_) => _createStudentManagementCubit(),
              child: const StudentManagementScreen(),
            );
          },
        );

      case RouteNames.addStudentScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return BlocProvider<AddStudentCubit>(
              create: (_) => _createAddStudentCubit(),
              child: const AddStudentScreen(),
            );
          },
        );

      case RouteNames.updateStudentScreen:
        return _generateUpdateStudentRoute(settings);

      default:
        return null;
    }
  }

  static Route<dynamic>? _generateUpdateStudentRoute(
    RouteSettings settings,
  ) {
    final Object? argument = settings.arguments;

    if (argument is! String || argument.trim().isEmpty) {
      return null;
    }

    final String studentId = argument.trim();

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
        return BlocProvider<UpdateStudentCubit>(
          create: (_) => _createUpdateStudentCubit(
            studentId: studentId,
          ),
          child: const UpdateStudentScreen(),
        );
      },
    );
  }

  static StudentManagementCubit _createStudentManagementCubit() {
    return StudentManagementCubit(
      streamStudentsUseCase: _get<StreamStudentsUseCase>(),
      streamGradesUseCase: _get<StreamGradesUseCase>(),
    )..watchStudentManagement();
  }

  static AddStudentCubit _createAddStudentCubit() {
    return AddStudentCubit(
      createStudentUseCase: _get<CreateStudentUseCase>(),
      streamGradesUseCase: _get<StreamGradesUseCase>(),
    )..watchGrades();
  }

  static UpdateStudentCubit _createUpdateStudentCubit({
    required String studentId,
  }) {
    return UpdateStudentCubit(
      studentId: studentId,
      getStudentByIdUseCase: _get<GetStudentByIdUseCase>(),
      streamGradesUseCase: _get<StreamGradesUseCase>(),
      updateStudentProfileUseCase: _get<UpdateStudentProfileUseCase>(),
      updateStudentEmailUseCase: _get<UpdateStudentEmailUseCase>(),
      updateStudentPasswordUseCase: _get<UpdateStudentPasswordUseCase>(),
      updateStudentSubscriptionUseCase:
          _get<UpdateStudentSubscriptionUseCase>(),
      deleteStudentUseCase: _get<DeleteStudentUseCase>(),
    )..initialize();
  }

  static T _get<T extends Object>() {
    return _getIt.get<T>();
  }
}