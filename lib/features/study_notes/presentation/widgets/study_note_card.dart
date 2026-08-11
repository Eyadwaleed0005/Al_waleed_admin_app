import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNoteCard extends StatelessWidget {
  const StudyNoteCard({
    super.key,
    required this.name,
    required this.description,
    required this.isPublished,
    required this.onTap,
  });

  final String name;
  final String description;
  final bool isPublished;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 116.h),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.textPrimary.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          splashColor: ColorPalette.primarySoftBackground,
          highlightColor: ColorPalette.primarySoftBackground,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        name,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.font16TextPrimaryMediumKufam(),
                      ),
                      verticalSpace(8),
                      Text(
                        description,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.font12TextSecondaryRegularTajawal(),
                      ),
                    ],
                  ),
                ),
                horizontalSpace(12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isPublished
                        ? ColorPalette.semanticSuccessSoftBg
                        : ColorPalette.error,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    isPublished ? 'منشورة' : 'غير منشورة',
                    style: AppTextStyle.font14SuccessMediumTajawal().copyWith(
                      color: isPublished
                          ? ColorPalette.success
                          : ColorPalette.surface,
                    ),
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
