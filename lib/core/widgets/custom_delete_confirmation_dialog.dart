import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool> showCustomDeleteConfirmationBottomSheet(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  String cancelText = 'إلغاء',
  bool isDismissible = true,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    backgroundColor: Colors.transparent,
    barrierColor: ColorPalette.textPrimary.withValues(alpha: 0.35),
    builder: (_) {
      return CustomDeleteConfirmationBottomSheet(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
      );
    },
  );

  return result ?? false;
}

class CustomDeleteConfirmationBottomSheet extends StatelessWidget {
  const CustomDeleteConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 20.h + bottomSafeArea),
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _BottomSheetHandle(),

            verticalSpace(20),

            Text(
              title,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font18PrimarySemiBoldKufam(),
            ),

            verticalSpace(14),

            Text(
              message,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
                height: 1.6,
              ),
            ),

            verticalSpace(72),

            Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: _ConfirmButton(
                    text: confirmText,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),

                horizontalSpace(16),

                Expanded(
                  child: _CancelButton(
                    text: cancelText,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: ColorPalette.primary.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ColorPalette.error,
          foregroundColor: ColorPalette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.r),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyle.font15SurfaceBoldTajawal(),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorPalette.primary,
          backgroundColor: ColorPalette.surface,
          side: BorderSide(color: ColorPalette.primary, width: 1.4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.r),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyle.font15PrimaryBoldTajawal(),
        ),
      ),
    );
  }
}
