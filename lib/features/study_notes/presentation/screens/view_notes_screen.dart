import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_error_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/view_notes_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/view_notes_state.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/view_note_content.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/view_notes_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewNotesScreen extends StatelessWidget {
  const ViewNotesScreen({super.key, this.onAddNotePressed, this.onNoteTap});

  final VoidCallback? onAddNotePressed;
  final ValueChanged<StudyNoteEntity>? onNoteTap;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        body: ContentManagementBackground(
          child: SafeArea(
            child: AppNetworkAwareContent(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppAnimations.screenSection(
                      delay: 0,
                      child: const SecondaryCustomHeaderBar(
                        title: 'عرض المذكرات',
                      ),
                    ),
                    verticalSpace(30),
                    Expanded(
                      child: AppAnimations.screenSection(
                        delay: 120,
                        child: BlocBuilder<ViewNotesCubit, ViewNotesState>(
                          builder: (context, state) {
                            if (state is ViewNotesInitial ||
                                state is ViewNotesLoading) {
                              return const ViewNotesLoadingSkeleton();
                            }

                            if (state is ViewNotesFailure) {
                              return AppErrorWidget(
                                message: state.message,
                                onRetry: () {
                                  context.read<ViewNotesCubit>().retry();
                                },
                              );
                            }

                            if (state is ViewNotesDataSuccess) {
                              return ViewNoteContent(
                                state: state,
                                onAddNotePressed: () {
                                  _onAddNotePressed(context);
                                },
                                onNoteTap: (note) {
                                  _onNoteTap(context, note);
                                },
                              );
                            }

                            return const ViewNotesLoadingSkeleton();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onAddNotePressed(BuildContext context) {
    if (onAddNotePressed != null) {
      onAddNotePressed!();
      return;
    }

    debugPrint('Add new note button pressed');
  }

  void _onNoteTap(BuildContext context, StudyNoteEntity note) {
    if (onNoteTap != null) {
      onNoteTap!(note);
      return;
    }

    debugPrint('Selected note ID: ${note.noteId}');
  }
}
