import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_empty_widget.dart';
import 'package:alwaleed_admain/core/widgets/app_no_search_results_widget.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/view_lessons_cubit.dart';
import 'package:alwaleed_admain/features/lessons/presentation/cubit/view_lessons_state.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/lesson_search_filter_section.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/lessons_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewLessonsContent extends StatelessWidget {
  const ViewLessonsContent({
    super.key,
    required this.state,
    required this.onAddLessonPressed,
    required this.onLessonTap,
  });

  final ViewLessonsDataSuccess state;
  final VoidCallback onAddLessonPressed;
  final ValueChanged<LessonEntity> onLessonTap;

  @override
  Widget build(BuildContext context) {
    if (state.hasNoLessons) {
      return AppAnimations.emptyStateEntrance(
        child: AppEmptyWidget(
          title: 'لا توجد دروس',
          message: 'لم تتم إضافة أي دروس حتى الآن، يمكنك إضافة درس جديد.',
          actionText: 'إضافة درس جديد',
          icon: Icons.play_lesson_outlined,
          onActionPressed: onAddLessonPressed,
        ),
      );
    }

    final cubit = context.read<ViewLessonsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppAnimations.screenSection(
          delay: 0,
          child: LessonSearchFilterSection(
            grades: state.grades,
            selectedGradeId: state.selectedGradeId,
            selectedPublicationFilter: state.selectedPublicationFilter,
            onSearchChanged: cubit.searchLessons,
            onSearchSubmitted: cubit.searchLessons,
            onGradeSelected: cubit.selectGrade,
            onPublicationStatusSelected: cubit.selectPublicationFilter,
          ),
        ),
        verticalSpace(24),
        Expanded(
          child: state.hasNoSearchResults
              ? AppAnimations.emptyStateEntrance(
                  child: const AppNoSearchResultsWidget(
                    message: 'لا توجد دروس مطابقة للبحث أو الفلاتر المحددة.',
                  ),
                )
              : AppAnimations.screenSection(
                  delay: 120,
                  child: LessonsList(
                    lessons: state.filteredLessons,
                    onLessonTap: onLessonTap,
                  ),
                ),
        ),
        verticalSpace(16),
        AppAnimations.screenSection(
          delay: 240,
          child: CustomButton(
            text: 'إضافة درس جديد',
            onPressed: onAddLessonPressed,
          ),
        ),
      ],
    );
  }
}
