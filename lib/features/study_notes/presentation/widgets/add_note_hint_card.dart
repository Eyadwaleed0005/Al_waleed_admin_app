import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNoteHintCard extends StatelessWidget {
  const AddNoteHintCard({
    super.key,
    this.message = 'اجعل عنوان الملف واضحًا للطالب',
  });


  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 84.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: ColorPalette.infoSoftBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorPalette.secondary.withValues(alpha: 0.06),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: AppTextStyle.font13TextPrimaryRegularTajawal(),
            ),
          ),
          horizontalSpace(18),
          Container(
            width: 10.w,
            height: 10.h,
            decoration: const BoxDecoration(
              color: ColorPalette.secondary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
