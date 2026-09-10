import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/core/widgets/custom_status_switch.dart';
import 'package:flutter/material.dart';

class ExamPublicationSwitch extends StatelessWidget {
  const ExamPublicationSwitch({
    super.key,
    required this.isPublished,
    required this.onChanged,
  });

  final bool isPublished;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'حالة الاختبار',
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: AppTextStyle.font15TextPrimaryMediumTajawal(),
        ),
        verticalSpace(10),
        CustomStatusSwitch(
          value: isPublished,
          onChanged: onChanged,
          activeText: 'منشور',
          inactiveText: 'غير منشور',
          activeSemanticLabel: 'الاختبار منشور',
          inactiveSemanticLabel: 'الاختبار غير منشور',
          activeTooltip: 'إلغاء نشر الاختبار',
          inactiveTooltip: 'نشر الاختبار',
          showTextOnLeft: false,
        ),
      ],
    );
  }
}
