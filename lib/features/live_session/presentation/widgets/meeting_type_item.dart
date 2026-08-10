import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeetingTypeItem extends StatelessWidget {
  const MeetingTypeItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 100.h,
      decoration: BoxDecoration(
        color: isSelected ? ColorPalette.background : ColorPalette.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? ColorPalette.primary : ColorPalette.border,
          width: isSelected ? 1.5.w : 1.w,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: ColorPalette.primarySoftBackground,
          highlightColor: ColorPalette.primarySoftBackground,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 28.sp,
                  color: isSelected
                      ? ColorPalette.primary
                      : ColorPalette.textSecondary,
                ),
                verticalSpace(8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.font16TextPrimaryBoldTajawal().copyWith(
                    color: isSelected
                        ? ColorPalette.primary
                        : ColorPalette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
