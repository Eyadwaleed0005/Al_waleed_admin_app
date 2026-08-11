import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentSectionCard extends StatelessWidget {
  const ContentSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.backgroundColor = ColorPalette.surface,
    this.iconBackgroundColor = ColorPalette.primarySoftBackground,
    this.iconColor = ColorPalette.primary,
    this.titleColor = ColorPalette.textPrimary,
    this.subtitleColor = ColorPalette.textSecondary,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: iconBackgroundColor.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            textDirection: TextDirection.ltr,
            children: [
              Container(
                width: 64.w,
                height: 64.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(icon, color: iconColor, size: 25.sp),
              ),
              horizontalSpace(16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyle.font21TextPrimaryBoldKufam().copyWith(
                        color: titleColor,
                      ),
                    ),
                    verticalSpace(6),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyle.font12TextSecondaryRegularTajawal()
                          .copyWith(color: subtitleColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
