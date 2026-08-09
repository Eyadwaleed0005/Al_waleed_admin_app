import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/custom_delete_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool> showCustomDeleteConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'تأكيد الحذف',
  String cancelText = 'إلغاء',
}) async {
  final bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return CustomDeleteConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
      );
    },
  );

  return result ?? false;
}

class CustomDeleteConfirmationDialog extends StatelessWidget {
  const CustomDeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'تأكيد الحذف',
    this.cancelText = 'إلغاء',
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: ColorPalette.error.withValues(alpha: 0.30),
            width: 1.2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorPalette.error.withValues(alpha: 0.10),
              blurRadius: 28.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.h,
              decoration: BoxDecoration(
                color: ColorPalette.error.withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.delete_outline_rounded,
                color: ColorPalette.error,
                size: 38.sp,
              ),
            ),

            verticalSpace(22),

            Text(
              title,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font18PrimarySemiBoldKufam().copyWith(
                color: ColorPalette.textPrimary,
              ),
            ),

            verticalSpace(10),

            Text(
              message,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font14TextPrimaryRegularTajawal().copyWith(
                color: ColorPalette.textSecondary,
              ),
            ),

            verticalSpace(26),

            CustomDeleteButton(
              text: confirmText,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            verticalSpace(12),
            CustomSecondaryButton(
              text: cancelText,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
