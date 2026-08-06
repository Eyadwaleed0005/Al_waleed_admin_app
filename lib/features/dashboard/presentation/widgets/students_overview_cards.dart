import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/features/dashboard/presentation/widgets/students_data_card.dart';
import 'package:flutter/material.dart';

class StudentsOverviewCards extends StatelessWidget {
  const StudentsOverviewCards({
    super.key,
    required this.totalStudents,
    required this.expiredSubscriptions,
  });

  final int totalStudents;
  final int expiredSubscriptions;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StudentsDataCard(
              studentsCount: totalStudents,
              title: 'إجمالي الطلاب',
              enableCountVisibility: true,
              numberColor: ColorPalette.primary,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: StudentsDataCard(
              studentsCount: expiredSubscriptions,
              title: 'اشتراكات منتهية',
              enableCountVisibility: false,
              numberColor: ColorPalette.warning,
            ),
          ),
        ],
      ),
    );
  }
}