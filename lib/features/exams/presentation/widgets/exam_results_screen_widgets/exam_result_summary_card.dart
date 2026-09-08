import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamResultSummaryCard extends StatelessWidget {
  const ExamResultSummaryCard({
    super.key,
    required this.valueText,
    required this.labelText,
    required this.valueColor,
  });

  final String valueText;
  final String labelText;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: ColorPalette.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primaryShadow,
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            valueText,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.font26HighlightBoldKufam().copyWith(
              color: valueColor,
            ),
          ),
          horizontalSpace(8),
          Text(
            labelText,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.font13TextSecondaryRegularTajawal()
          ),
        ],
      ),
    );
  }
}
