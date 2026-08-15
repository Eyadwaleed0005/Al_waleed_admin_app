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
    required this.onRetry,
    this.isEnabled = true,
    this.isLoading = false,
    this.hasError = false,
  });

  final bool hasExam;
  final bool isEnabled;
  final bool isLoading;
  final bool hasError;

  final VoidCallback onCreateExam;
  final VoidCallback onEditExam;
  final VoidCallback onRetry;

  String get _title {
    if (isLoading) {
      return 'جاري التحقق من اختبار الدرس';
    }

    if (hasError) {
      return 'تعذر تحميل حالة اختبار الدرس';
    }

    if (hasExam) {
      return 'تم إنشاء اختبار لهذا الدرس';
    }

    return 'اختبار الدرس';
  }

  String get _buttonText {
    if (hasError) {
      return 'إعادة المحاولة';
    }

    if (hasExam) {
      return 'تعديل الاختبار';
    }

    return 'إنشاء الاختبار';
  }

  VoidCallback get _buttonAction {
    if (hasError) {
      return onRetry;
    }

    if (hasExam) {
      return onEditExam;
    }

    return onCreateExam;
  }

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading;

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
                _title,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.font14TextPrimaryMediumKufam(),
              ),
            ),
          ),

          horizontalSpace(12),

          SizedBox(
            height: 56.h,
            child: OutlinedButton(
              onPressed: canPress ? _buttonAction : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorPalette.primary,
                disabledForegroundColor: ColorPalette.disabled,
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                side: BorderSide(
                  color: canPress
                      ? ColorPalette.primary
                      : ColorPalette.disabled,
                  width: 2.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 21.w,
                      height: 21.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.3.w,
                        color: ColorPalette.primary,
                      ),
                    )
                  : Text(
                      _buttonText,
                      maxLines: 1,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.font15PrimaryBoldTajawal().copyWith(
                        color: canPress
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
