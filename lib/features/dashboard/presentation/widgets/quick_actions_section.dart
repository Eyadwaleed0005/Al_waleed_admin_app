import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/widgets/quick_action_card.dart';
import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    required this.onStudentsTap,
    required this.onContentTap,
    required this.onExamsTap,
    required this.onResultsTap,
  });

  final VoidCallback onStudentsTap;
  final VoidCallback onContentTap;
  final VoidCallback onExamsTap;
  final VoidCallback onResultsTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'إجراءات سريعة',
            textAlign: TextAlign.right,
            style: AppTextStyle.font20TextSecondaryRegularKufam(),
          ),
        ),
        verticalSpace(16),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: QuickActionCard(
                title: 'إضافة درس',
                icon: Icons.menu,
                backgroundColor: ColorPalette.secondary,
                iconBackgroundColor: ColorPalette.secondary,
                onTap: onStudentsTap,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: QuickActionCard(
                title: 'إضافة طالب',
                icon: Icons.add,
                backgroundColor: ColorPalette.background,
                iconBackgroundColor: ColorPalette.primary,
                onTap: onContentTap,
              ),
            ),
          ],
        ),
        verticalSpace(20),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: QuickActionCard(
                title: 'رابط البث',
                icon: Icons.videocam_outlined,
                backgroundColor: ColorPalette.background,
                iconBackgroundColor: ColorPalette.primary,
                onTap: onExamsTap,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: QuickActionCard(
                title: 'إنشاء اختبار',
               icon: Icons.done,
                backgroundColor: ColorPalette.warning,
                iconBackgroundColor: ColorPalette.warning,
                onTap: onResultsTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
