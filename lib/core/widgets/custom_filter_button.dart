import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({
    super.key,
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: Material(
        color: ColorPalette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: ColorPalette.border,
            width: 1.w,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor:
              ColorPalette.primarySoftBackground,
          highlightColor:
              ColorPalette.primarySoftBackground,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18.w,
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle
                        .font15TextPrimaryMediumTajawal(),
                  ),
                ),
                horizontalSpace(8),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 26.sp,
                  color: ColorPalette.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}