import 'dart:async';

import 'package:alwaleed_admin/app/routes/route_names.dart';
import 'package:alwaleed_admin/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:alwaleed_admin/features/lesson_exams/domain/use_case/create_lesson_exam_question_use_case.dart';
import 'package:alwaleed_admin/features/lesson_exams/domain/use_case/delete_lesson_exam_question_use_case.dart';
import 'package:alwaleed_admin/features/lesson_exams/domain/use_case/save_lesson_exam_answers_use_case.dart';
import 'package:alwaleed_admin/features/lesson_exams/domain/use_case/stream_lesson_exam_use_case.dart';
import 'package:alwaleed_admin/features/lesson_exams/domain/use_case/update_lesson_exam_question_use_case.dart';
import 'package:alwaleed_admin/features/lesson_exams/presentation/cubit/add_lesson_exam_question_cubit.dart';
import 'package:alwaleed_admin/features/lesson_exams/presentation/cubit/edit_lesson_exam_question_cubit.dart';
import 'package:alwaleed_admin/features/lesson_exams/presentation/cubit/lesson_exams_cubit.dart';
import 'package:alwaleed_admin/features/lesson_exams/presentation/screens/add_lesson_exam_question_screen.dart';
import 'package:alwaleed_admin/features/lesson_exams/presentation/screens/edit_lesson_exam_question_screen.dart';
import 'package:alwaleed_admin/features/lesson_exams/presentation/screens/lesson_exams_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class LessonExamsRoutes {
  const LessonExamsRoutes._();

  static final GetIt _getIt = GetIt.instance;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.lessonExamsScreen:
        return _generateLessonExamsRoute(settings);

      case RouteNames.addLessonExamQuestionScreen:
        return _generateAddLessonExamQuestionRoute(settings);

      case RouteNames.editLessonExamQuestionScreen:
        return _generateEditLessonExamQuestionRoute(settings);

      default:
        return null;
    }
  }

  static Route<dynamic>? _generateLessonExamsRoute(RouteSettings settings) {
    final String? lessonId = _readRequiredId(settings.arguments);

    if (lessonId == null) {
      return null;
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
        return BlocProvider<LessonExamsCubit>(
          create: (_) => _createLessonExamsCubit(lessonId: lessonId),
          child: LessonExamsScreen(lessonId: lessonId),
        );
      },
    );
  }

  static Route<dynamic>? _generateAddLessonExamQuestionRoute(
    RouteSettings settings,
  ) {
    final String? lessonId = _readRequiredId(settings.arguments);

    if (lessonId == null) {
      return null;
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
        return BlocProvider<AddLessonExamQuestionCubit>(
          create: (_) => AddLessonExamQuestionCubit(
            createLessonExamQuestionUseCase:
                _get<CreateLessonExamQuestionUseCase>(),
          ),
          child: AddLessonExamQuestionScreen(lessonId: lessonId),
        );
      },
    );
  }

  static Route<dynamic>? _generateEditLessonExamQuestionRoute(
    RouteSettings settings,
  ) {
    final Object? argument = settings.arguments;

    if (argument is! LessonExamQuestionEntity) {
      return null;
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
        return BlocProvider<EditLessonExamQuestionCubit>(
          create: (_) => EditLessonExamQuestionCubit(
            _get<UpdateLessonExamQuestionUseCase>(),
          ),
          child: EditLessonExamQuestionScreen(question: argument),
        );
      },
    );
  }

  static LessonExamsCubit _createLessonExamsCubit({required String lessonId}) {
    final LessonExamsCubit lessonExamsCubit = LessonExamsCubit(
      lessonId: lessonId,
      streamLessonExamUseCase: _get<StreamLessonExamUseCase>(),
      deleteLessonExamQuestionUseCase: _get<DeleteLessonExamQuestionUseCase>(),
      saveLessonExamAnswersUseCase: _get<SaveLessonExamAnswersUseCase>(),
    );

    unawaited(lessonExamsCubit.initialize());

    return lessonExamsCubit;
  }

  static String? _readRequiredId(Object? argument) {
    if (argument is! String || argument.trim().isEmpty) {
      return null;
    }

    return argument.trim();
  }

  static T _get<T extends Object>() {
    return _getIt.get<T>();
  }
}
