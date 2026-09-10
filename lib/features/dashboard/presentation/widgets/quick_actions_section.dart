import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:alwaleed_admin/features/dashboard/presentation/widgets/quick_action_card.dart';
import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    required this.onStudentsTap,
    required this.onContentTap,
    required this.onExamsTap,
    required this.onNotesTap,
  });

  final VoidCallback onStudentsTap;
  final VoidCallback onContentTap;
  final VoidCallback onExamsTap;
  final VoidCallback onNotesTap;

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
                onTap: onContentTap,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: QuickActionCard(
                title: 'إضافة طالب',
                icon: Icons.add,
                backgroundColor: ColorPalette.background,
                iconBackgroundColor: ColorPalette.primary,
                onTap: onStudentsTap,
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
                title: 'إضافة مذاكرة',
                icon: Icons.library_add_rounded,
                backgroundColor: ColorPalette.background,
                iconBackgroundColor: ColorPalette.primary,
                onTap: onNotesTap,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: QuickActionCard(
                title: 'إنشاء اختبار',
                icon: Icons.done,
                backgroundColor: ColorPalette.warning,
                iconBackgroundColor: ColorPalette.warning,
                onTap: onExamsTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
