import 'package:alwaleed_admin/app/routes/route_names.dart';
import 'package:alwaleed_admin/features/grades/domain/use_cases/stream_grades_use_case.dart';
import 'package:alwaleed_admin/features/study_notes/domain/use_case/create_study_note_use_case.dart';
import 'package:alwaleed_admin/features/study_notes/domain/use_case/delete_study_note_use_case.dart';
import 'package:alwaleed_admin/features/study_notes/domain/use_case/get_study_note_by_id_use_case.dart';
import 'package:alwaleed_admin/features/study_notes/domain/use_case/stream_study_notes_use_case.dart';
import 'package:alwaleed_admin/features/study_notes/domain/use_case/update_study_note_use_case.dart';
import 'package:alwaleed_admin/features/study_notes/presentation/cubit/add_note_cubit.dart';
import 'package:alwaleed_admin/features/study_notes/presentation/cubit/edit_note_cubit.dart';
import 'package:alwaleed_admin/features/study_notes/presentation/cubit/view_notes_cubit.dart';
import 'package:alwaleed_admin/features/study_notes/presentation/screens/add_note_screen.dart';
import 'package:alwaleed_admin/features/study_notes/presentation/screens/content_management_screen.dart';
import 'package:alwaleed_admin/features/study_notes/presentation/screens/edit_note_screen.dart';
import 'package:alwaleed_admin/features/study_notes/presentation/screens/view_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class StudyNotesRoutes {
  const StudyNotesRoutes._();

  static final GetIt _getIt = GetIt.instance;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.contentManagementScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return const ContentManagementScreen();
          },
        );

      case RouteNames.viewNotesScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return BlocProvider<ViewNotesCubit>(
              create: (_) => _createViewNotesCubit(),
              child: const ViewNotesScreen(),
            );
          },
        );

      case RouteNames.addNoteScreen:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            return BlocProvider<AddNoteCubit>(
              create: (_) => _createAddNoteCubit(),
              child: const AddNoteScreen(),
            );
          },
        );

      case RouteNames.editNoteScreen:
        return _generateEditNoteRoute(settings);

      default:
        return null;
    }
  }

  static Route<dynamic>? _generateEditNoteRoute(
    RouteSettings settings,
  ) {
    final Object? argument = settings.arguments;

    if (argument is! String || argument.trim().isEmpty) {
      return null;
    }

    final String noteId = argument.trim();

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) {
        return BlocProvider<EditNoteCubit>(
          create: (_) => _createEditNoteCubit(
            noteId: noteId,
          ),
          child: const EditNoteScreen(),
        );
      },
    );
  }

  static ViewNotesCubit _createViewNotesCubit() {
    return ViewNotesCubit(
      streamGradesUseCase: _get<StreamGradesUseCase>(),
      streamStudyNotesUseCase: _get<StreamStudyNotesUseCase>(),
    )..initialize();
  }

  static AddNoteCubit _createAddNoteCubit() {
    return AddNoteCubit(
      streamGradesUseCase: _get<StreamGradesUseCase>(),
      createStudyNoteUseCase: _get<CreateStudyNoteUseCase>(),
    )..initialize();
  }

  static EditNoteCubit _createEditNoteCubit({
    required String noteId,
  }) {
    return EditNoteCubit(
      noteId: noteId,
      getStudyNoteByIdUseCase: _get<GetStudyNoteByIdUseCase>(),
      streamGradesUseCase: _get<StreamGradesUseCase>(),
      updateStudyNoteUseCase: _get<UpdateStudyNoteUseCase>(),
      deleteStudyNoteUseCase: _get<DeleteStudyNoteUseCase>(),
    )..initialize();
  }

  static T _get<T extends Object>() {
    return _getIt.get<T>();
  }
}