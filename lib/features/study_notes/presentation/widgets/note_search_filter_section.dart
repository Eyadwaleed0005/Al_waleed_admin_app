import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/widgets/custom_popup_menu_field.dart';
import 'package:alwaleed_admain/core/widgets/custom_search_bar.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/grade_popup_menu_field.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/cubit/view_notes_state.dart';
import 'package:flutter/material.dart';

class NoteSearchFilterSection extends StatelessWidget {
  const NoteSearchFilterSection({
    super.key,
    required this.grades,
    required this.selectedGradeId,
    required this.selectedPublicationFilter,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onGradeSelected,
    required this.onPublicationStatusSelected,
  });

  final List<GradeEntity> grades;

  final String selectedGradeId;

  final NotePublicationFilter selectedPublicationFilter;

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;

  final ValueChanged<String> onGradeSelected;

  final ValueChanged<NotePublicationFilter> onPublicationStatusSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSearchBar(
          hintText: 'البحث باسم المذكرة',
          onChanged: onSearchChanged,
          onSubmitted: onSearchSubmitted,
        ),
        verticalSpace(16),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(child: _buildGradesPopupMenu()),
            horizontalSpace(16),
            Expanded(child: _buildPublicationStatusPopupMenu()),
          ],
        ),
      ],
    );
  }

  Widget _buildGradesPopupMenu() {
    return GradePopupMenuField(
      grades: grades,
      selectedGradeId: selectedGradeId,
      placeholderText: 'كل الصفوف',
      tooltip: 'اختيار الصف',
      emptyTooltip: 'لا توجد صفوف متاحة حاليًا',
      includeAllOption: true,
      allGradesText: 'كل الصفوف',
      onGradeSelected: onGradeSelected,
    );
  }

  Widget _buildPublicationStatusPopupMenu() {
    return CustomPopupMenuField<NotePublicationFilter>(
      items: const [
        PopupSelectionItem<NotePublicationFilter>(
          value: NotePublicationFilter.all,
          label: 'كل الحالات',
        ),
        PopupSelectionItem<NotePublicationFilter>(
          value: NotePublicationFilter.published,
          label: 'منشورة',
        ),
        PopupSelectionItem<NotePublicationFilter>(
          value: NotePublicationFilter.unpublished,
          label: 'غير منشورة',
        ),
      ],
      value: selectedPublicationFilter,
      selectedText: _selectedPublicationStatusName,
      filterValue: _selectedPublicationStatusName,
      tooltip: 'اختيار حالة نشر المذكرة',
      onSelected: onPublicationStatusSelected,
    );
  }

  String get _selectedPublicationStatusName {
    return switch (selectedPublicationFilter) {
      NotePublicationFilter.all => 'كل الحالات',
      NotePublicationFilter.published => 'منشورة',
      NotePublicationFilter.unpublished => 'غير منشورة',
    };
  }
}
