import 'package:alwaleed_admain/core/helper/app_date_time_formatter.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteLastUpdateCard extends StatelessWidget {
  const NoteLastUpdateCard({
    super.key,
    required this.lastUpdatedAt,
    this.label = 'تم رفع الملف الحالي في',
    this.showTime = false,
  });

  final DateTime lastUpdatedAt;
  final String label;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = AppDateTimeFormatter.separate(lastUpdatedAt);

    final displayedValue = showTime
        ? '${formattedDateTime.date}، الساعة ${formattedDateTime.time}'
        : formattedDateTime.date;

    return Semantics(
      label: '$label $displayedValue',
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 80.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: ColorPalette.semanticSuccessSoftBg.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: ColorPalette.primary.withValues(alpha: 0.05),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorPalette.black.withValues(alpha: 0.05),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: Text(
                '$label $displayedValue',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font13TextPrimaryRegularTajawal(),
              ),
            ),

            horizontalSpace(20),
            Container(
              width: 15.w,
              height: 15.w,
              decoration: const BoxDecoration(
                color: ColorPalette.success,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
