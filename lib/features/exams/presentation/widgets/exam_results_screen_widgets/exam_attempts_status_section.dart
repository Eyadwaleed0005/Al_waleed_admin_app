import 'package:alwaleed_admin/core/helper/arabic_numbers_helper.dart';
import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:alwaleed_admin/core/style/app_color.dart';
import 'package:alwaleed_admin/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamAttemptsStatusSection extends StatelessWidget {
  const ExamAttemptsStatusSection({
    super.key,
    required this.submittedCount,
    required this.inProgressCount,
  });

  final int submittedCount;
  final int inProgressCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ExamAttemptStatusCard(
            count: submittedCount,
            title: 'سلّموا الاختبار',
            icon: Icons.task_alt_rounded,
            foregroundColor: ColorPalette.primary,
            backgroundColor: ColorPalette.primarySoftBackground,
          ),
        ),
        horizontalSpace(14),
        Expanded(
          child: _ExamAttemptStatusCard(
            count: inProgressCount,
            title: 'ما زالوا يمتحنون',
            icon: Icons.schedule_rounded,
            foregroundColor: const Color(0xFFB7791F),
            backgroundColor: const Color(0xFFFFF3D6),
          ),
        ),
      ],
    );
  }
}

class _ExamAttemptStatusCard extends StatelessWidget {
  const _ExamAttemptStatusCard({
    required this.count,
    required this.title,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final int count;
  final String title;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: foregroundColor.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 23.sp, color: foregroundColor),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toArabicNumbers(count),
                  style: AppTextStyle.font18PrimarySemiBoldKufam().copyWith(
                    color: foregroundColor,
                  ),
                ),
                verticalSpace(4),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.font14TextPrimaryRegularTajawal()
                      .copyWith(color: ColorPalette.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
