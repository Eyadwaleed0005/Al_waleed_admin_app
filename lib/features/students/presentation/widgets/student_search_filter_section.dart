import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/custom_filter_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_search_bar.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/students/domain/params/student_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return PopupMenuButton<String>(
      tooltip: 'اختيار الصف',
      position: PopupMenuPosition.under,
      color: ColorPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: ColorPalette.border, width: 1.w),
      ),
      initialValue: selectedGradeId,
      onSelected: onGradeSelected,
      itemBuilder: (context) {
        return [
          CheckedPopupMenuItem<String>(
            value: '',
            checked: selectedGradeId.isEmpty,
            child: const Text('كل الصفوف'),
          ),
          ...grades.map((grade) {
            return CheckedPopupMenuItem<String>(
              value: grade.gradeId,
              checked: selectedGradeId == grade.gradeId,
              child: Text(grade.name),
            );
          }),
        ];
      },
      child: IgnorePointer(
        child: CustomFilterButton(text: _selectedGradeName()),
      ),
    );
  }

  Widget _buildStatusPopupMenu() {
    return PopupMenuButton<StudentSubscriptionFilter>(
      tooltip: 'اختيار حالة الاشتراك',
      position: PopupMenuPosition.under,
      color: ColorPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: ColorPalette.border, width: 1.w),
      ),
      initialValue: selectedSubscriptionFilter,
      onSelected: onStatusSelected,
      itemBuilder: (context) {
        return [
          CheckedPopupMenuItem<StudentSubscriptionFilter>(
            value: StudentSubscriptionFilter.all,
            checked:
                selectedSubscriptionFilter == StudentSubscriptionFilter.all,
            child: const Text('كل الحالات'),
          ),
          CheckedPopupMenuItem<StudentSubscriptionFilter>(
            value: StudentSubscriptionFilter.active,
            checked:
                selectedSubscriptionFilter == StudentSubscriptionFilter.active,
            child: const Text('نشط'),
          ),
          CheckedPopupMenuItem<StudentSubscriptionFilter>(
            value: StudentSubscriptionFilter.expired,
            checked:
                selectedSubscriptionFilter == StudentSubscriptionFilter.expired,
            child: const Text('منتهي'),
          ),
        ];
      },
      child: IgnorePointer(
        child: CustomFilterButton(text: _selectedStatusName()),
      ),
    );
  }

  String _selectedGradeName() {
    if (selectedGradeId.isEmpty) {
      return 'كل الصفوف';
    }

    for (final grade in grades) {
      if (grade.gradeId == selectedGradeId) {
        return grade.name;
      }
    }

    return 'كل الصفوف';
  }
 
  String _selectedStatusName() {
    return switch (selectedSubscriptionFilter) {
      StudentSubscriptionFilter.all => 'كل الحالات',
      StudentSubscriptionFilter.active => ' نشط',
      StudentSubscriptionFilter.expired => ' منتهي',
    };
  }
}
