import 'package:alwaleed_admain/core/widgets/custom_popup_menu_field.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:flutter/material.dart';

class GradePopupMenuField extends StatelessWidget {
  const GradePopupMenuField({
    super.key,
    required this.grades,
    required this.selectedGradeId,
    required this.placeholderText,
    required this.tooltip,
    required this.onGradeSelected,
    this.emptyTooltip,
    this.labelText,
    this.validator,
    this.includeAllOption = false,
    this.allGradesText,
  }) : assert(
         !includeAllOption || allGradesText != null,
         'allGradesText is required when includeAllOption is true.',
       );

  final List<GradeEntity> grades;

  final String? selectedGradeId;

  final String placeholderText;
  final String tooltip;

  final String? emptyTooltip;
  final String? labelText;

  final bool includeAllOption;
  final String? allGradesText;

  final FormFieldValidator<String>? validator;

  final ValueChanged<String> onGradeSelected;

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenuField<String>(
      items: _buildItems(),
      value: selectedGradeId,
      selectedText: _selectedGradeText,
      tooltip: tooltip,
      emptyTooltip: emptyTooltip,
      labelText: labelText,
      filterValue: selectedGradeId,
      validator: validator,
      enabled: grades.isNotEmpty,
      onSelected: onGradeSelected,
    );
  }

  List<PopupSelectionItem<String>> _buildItems() {
    return [
      if (includeAllOption)
        PopupSelectionItem<String>(
          value: '',
          label: allGradesText!,
        ),
      ...grades.map(
        (grade) {
          return PopupSelectionItem<String>(
            value: grade.gradeId,
            label: grade.name,
          );
        },
      ),
    ];
  }

  String get _selectedGradeText {
    final gradeId = selectedGradeId;

    if (gradeId == null || gradeId.isEmpty) {
      return includeAllOption
          ? allGradesText!
          : placeholderText;
    }

    for (final grade in grades) {
      if (grade.gradeId == gradeId) {
        return grade.name;
      }
    }

    return includeAllOption
        ? allGradesText!
        : placeholderText;
  }
}