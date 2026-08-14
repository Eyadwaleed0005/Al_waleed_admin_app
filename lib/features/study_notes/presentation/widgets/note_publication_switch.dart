import 'package:alwaleed_admain/core/widgets/custom_status_switch.dart';
import 'package:flutter/material.dart';

class NotePublicationSwitch extends StatelessWidget {
  const NotePublicationSwitch({
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
      activeText: 'منشورة',
      inactiveText: 'نشر',
      activeSemanticLabel: 'المذكرة منشورة',
      inactiveSemanticLabel: 'المذكرة غير منشورة',
      activeTooltip: 'إلغاء نشر المذكرة',
      inactiveTooltip: 'نشر المذكرة',
    );
  }
}
