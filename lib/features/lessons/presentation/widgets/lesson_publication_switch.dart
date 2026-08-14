import 'package:alwaleed_admain/core/widgets/custom_status_switch.dart';
import 'package:flutter/material.dart';

class LessonPublicationSwitch extends StatelessWidget {
  const LessonPublicationSwitch({
    super.key,
    required this.isPublished,
    required this.onChanged,
  });

  final bool isPublished;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomStatusSwitch(
      value: isPublished,
      onChanged: onChanged,
      activeText: 'منشور',
      inactiveText: 'نشر',
      activeSemanticLabel: 'الدرس منشور',
      inactiveSemanticLabel: 'الدرس غير منشور',
      activeTooltip: 'إلغاء نشر الدرس',
      inactiveTooltip: 'نشر الدرس',
    );
  }
}