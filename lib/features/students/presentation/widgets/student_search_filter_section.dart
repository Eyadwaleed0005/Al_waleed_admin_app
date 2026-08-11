import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/widgets/custom_popup_menu_field.dart';
import 'package:alwaleed_admain/core/widgets/custom_search_bar.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/domain/params/student_params.dart';
import 'package:alwaleed_admain/features/students/presentation/widgets/grade_popup_menu_field.dart';
import 'package:flutter/material.dart';

class StudentSearchFilterSection extends StatelessWidget {
  const StudentSearchFilterSection({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchTap,
    required this.grades,
    required this.selectedGradeId,
    required this.selectedSubscriptionFilter,
    required this.onGradeSelected,
    required this.onStatusSelected,
  });

  final TextEditingController? searchController;

  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchTap;

  final List<GradeEntity> grades;

  final String selectedGradeId;

  final StudentSubscriptionFilter selectedSubscriptionFilter;

  final ValueChanged<String> onGradeSelected;

  final ValueChanged<StudentSubscriptionFilter> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSearchBar(
          controller: searchController,
          hintText: 'البحث بالاسم أو رقم الهاتف',
          onChanged: onSearchChanged,
          onSubmitted: onSearchSubmitted,
          onSearchTap: onSearchTap,
        ),
        verticalSpace(16),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(child: _buildGradesPopupMenu()),
            horizontalSpace(16),
            Expanded(child: _buildStatusPopupMenu()),
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

  Widget _buildStatusPopupMenu() {
    return CustomPopupMenuField<StudentSubscriptionFilter>(
      items: const [
        PopupSelectionItem<StudentSubscriptionFilter>(
          value: StudentSubscriptionFilter.all,
          label: 'كل الحالات',
        ),
        PopupSelectionItem<StudentSubscriptionFilter>(
          value: StudentSubscriptionFilter.active,
          label: 'نشط',
        ),
        PopupSelectionItem<StudentSubscriptionFilter>(
          value: StudentSubscriptionFilter.expired,
          label: 'منتهي',
        ),
      ],
      value: selectedSubscriptionFilter,
      selectedText: 'كل الحالات',
      filterValue: _selectedStatusName,
      tooltip: 'اختيار حالة الاشتراك',
      onSelected: onStatusSelected,
    );
  }

  String get _selectedStatusName {
    return switch (selectedSubscriptionFilter) {
      StudentSubscriptionFilter.all => 'كل الحالات',
      StudentSubscriptionFilter.active => 'نشط',
      StudentSubscriptionFilter.expired => 'منتهي',
    };
  }
}
