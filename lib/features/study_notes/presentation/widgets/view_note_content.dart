import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_no_search_results_widget.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/view_notes_cubit.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/view_notes_state.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/note_search_filter_section.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/study_notes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewNoteContent extends StatelessWidget {
  const ViewNoteContent({
    super.key,
    required this.state,
    required this.onAddNotePressed,
    required this.onNoteTap,
  });

  final ViewNotesDataSuccess state;
  final VoidCallback onAddNotePressed;
  final ValueChanged<StudyNoteEntity> onNoteTap;

  @override
  Widget build(BuildContext context) {
    if (state.hasNoNotes) {
      return AppAnimations.emptyStateEntrance(
        child: AppEmptyWidget(
          title: 'لا توجد مذكرات',
          message: 'لم تتم إضافة أي مذكرات حتى الآن، يمكنك إضافة مذكرة جديدة.',
          actionText: 'إضافة مذكرة جديدة',
          icon: Icons.menu_book_outlined,
          onActionPressed: onAddNotePressed,
        ),
      );
    }

    final cubit = context.read<ViewNotesCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppAnimations.screenSection(
          delay: 0,
          child: NoteSearchFilterSection(
            grades: state.grades,
            selectedGradeId: state.selectedGradeId,
            selectedPublicationFilter: state.selectedPublicationFilter,
            onSearchChanged: cubit.searchNotes,
            onSearchSubmitted: cubit.searchNotes,
            onGradeSelected: cubit.selectGrade,
            onPublicationStatusSelected: cubit.selectPublicationFilter,
          ),
        ),

        verticalSpace(24),

        Expanded(
          child: state.hasNoSearchResults
              ? AppAnimations.emptyStateEntrance(
                  child: const AppNoSearchResultsWidget(
                    message: 'لا توجد مذكرات مطابقة للبحث أو الفلاتر المحددة.',
                  ),
                )
              : AppAnimations.screenSection(
                  delay: 120,
                  child: StudyNotesList(
                    notes: state.filteredNotes,
                    onNoteTap: onNoteTap,
                  ),
                ),
        ),

        verticalSpace(16),

        AppAnimations.screenSection(
          delay: 240,
          child: CustomButton(
            text: 'إضافة مذكرة جديدة',
            onPressed: onAddNotePressed,
          ),
        ),
      ],
    );
  }
}
