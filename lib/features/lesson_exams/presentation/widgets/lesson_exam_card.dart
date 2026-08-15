import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonExamCard extends StatelessWidget {
  const LessonExamCard({
    super.key,
    required this.hasExam,
    required this.onCreateExam,
    required this.onEditExam,
    this.isEnabled = true,
  });

  final bool hasExam;
  final VoidCallback onCreateExam;
  final VoidCallback onEditExam;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final title = hasExam ? 'تم إنشاء اختبار لهذا الدرس' : 'اختبار الدرس ';

    final buttonText = hasExam ? 'تعديل الاختبار' : 'إنشاء الاختبار';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: ColorPalette.infoSoftBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primaryShadow,
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                title,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.right,
                style: AppTextStyle.font14TextPrimaryMediumKufam(),
              ),
            ),
          ),

          horizontalSpace(12),

          SizedBox(
            height: 56.h,
            child: OutlinedButton(
              onPressed: !isEnabled
                  ? null
                  : hasExam
                  ? onEditExam
                  : onCreateExam,
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorPalette.primary,
                disabledForegroundColor: ColorPalette.disabled,
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                side: BorderSide(
                  color: isEnabled
                      ? ColorPalette.primary
                      : ColorPalette.disabled,
                  width: 2.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
              child: Text(
                buttonText,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: AppTextStyle.font15PrimaryBoldTajawal().copyWith(
                  color: isEnabled
                      ? ColorPalette.primary
                      : ColorPalette.disabled,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
