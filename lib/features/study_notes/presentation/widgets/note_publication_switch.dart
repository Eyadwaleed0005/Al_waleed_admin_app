import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotePublicationSwitch extends StatelessWidget {
  const NotePublicationSwitch({
    super.key,
    required this.isPublished,
    required this.onChanged,
  });

  final bool isPublished;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: isPublished,
      label: isPublished ? 'المذكرة منشورة' : 'المذكرة غير منشورة',
      child: Tooltip(
        message: isPublished ? 'إلغاء نشر المذكرة' : 'نشر المذكرة',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          height: 56.h,
          decoration: BoxDecoration(
            color: isPublished
                ? ColorPalette.primarySoftBackground
                : ColorPalette.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isPublished ? ColorPalette.accent : ColorPalette.border,
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.black.withValues(alpha: 0.06),
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
              onTap: () {
                onChanged(!isPublished);
              },
              borderRadius: BorderRadius.circular(18.r),
              splashColor: ColorPalette.primarySoftBackground,
              highlightColor: ColorPalette.primarySoftBackground,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          isPublished ? 'منشورة' : 'نشر',
                          key: ValueKey<bool>(isPublished),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: AppTextStyle.font15TextPrimaryMediumTajawal()
                              .copyWith(
                                color: isPublished
                                    ? ColorPalette.primary
                                    : ColorPalette.black,
                              ),
                        ),
                      ),
                    ),
                    horizontalSpace(8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      width: 56.w,
                      height: 34.h,
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                        color: isPublished
                            ? ColorPalette.primary
                            : ColorPalette.disabled,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: isPublished
                              ? ColorPalette.accent
                              : ColorPalette.border,
                          width: 1.w,
                        ),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutBack,
                        alignment: isPublished
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 26.w,
                          height: 26.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isPublished
                                ? ColorPalette.highlight
                                : ColorPalette.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: ColorPalette.black.withValues(
                                  alpha: 0.12,
                                ),
                                blurRadius: 3.r,
                                offset: Offset(0, 1.h),
                              ),
                            ],
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: Icon(
                              isPublished
                                  ? Icons.sentiment_satisfied_alt_rounded
                                  : Icons.sentiment_dissatisfied_rounded,
                              key: ValueKey<bool>(isPublished),
                              size: 19.sp,
                              color: isPublished
                                  ? ColorPalette.primary
                                  : ColorPalette.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ), 
          ),
        ),
      ),
    );
  }
}
