import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/widgets/custom_popup_menu_field.dart';
import 'package:alwaleed_admain/core/widgets/custom_search_bar.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/grade_popup_menu_field.dart';
import 'package:flutter/material.dart';

enum ExamPublicationFilter { all, published, unpublished, ended }

class ExamSearchFilterSection extends StatelessWidget {
  const ExamSearchFilterSection({
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

  final ExamPublicationFilter selectedPublicationFilter;

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final ValueChanged<String> onGradeSelected;

  final ValueChanged<ExamPublicationFilter> onPublicationStatusSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSearchBar(
          hintText: 'ابحث باسم الاختبار',
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
    return CustomPopupMenuField<ExamPublicationFilter>(
      items: const [
        PopupSelectionItem<ExamPublicationFilter>(
          value: ExamPublicationFilter.all,
          label: 'كل الحالات',
        ),
        PopupSelectionItem<ExamPublicationFilter>(
          value: ExamPublicationFilter.published,
          label: 'منشور',
        ),
        PopupSelectionItem<ExamPublicationFilter>(
          value: ExamPublicationFilter.unpublished,
          label: 'غير منشور',
        ),
        PopupSelectionItem<ExamPublicationFilter>(
          value: ExamPublicationFilter.ended,
          label: 'منتهي',
        ),
      ],
      value: selectedPublicationFilter,
      selectedText: _selectedPublicationStatusName,
      filterValue: _selectedPublicationStatusName,
      tooltip: 'اختيار حالة الامتحان',
      onSelected: onPublicationStatusSelected,
    );
  }

  String get _selectedPublicationStatusName {
    return switch (selectedPublicationFilter) {
      ExamPublicationFilter.all => 'كل الحالات',
      ExamPublicationFilter.published => 'منشور',
      ExamPublicationFilter.unpublished => 'غير منشور',
      ExamPublicationFilter.ended => 'منتهي',
    };
  }
}
