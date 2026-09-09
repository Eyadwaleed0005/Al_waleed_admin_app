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
  final bool? result = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    backgroundColor: Colors.transparent,
    barrierColor: ColorPalette.textPrimary.withValues(alpha: 0.35),
    builder: (BuildContext bottomSheetContext) {
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

class CustomDeleteConfirmationBottomSheet extends StatefulWidget {
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
  State<CustomDeleteConfirmationBottomSheet> createState() {
    return _CustomDeleteConfirmationBottomSheetState();
  }
}

class _CustomDeleteConfirmationBottomSheetState
    extends State<CustomDeleteConfirmationBottomSheet> {
  bool _isClosing = false;

  @override
  Widget build(BuildContext context) {
    final double bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: PopScope(
        canPop: !_isClosing,
        child: AbsorbPointer(
          absorbing: _isClosing,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              24.w,
              12.h,
              24.w,
              20.h + bottomSafeArea,
            ),
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
                  widget.title,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.font18PrimarySemiBoldKufam(),
                ),
                verticalSpace(14),
                Text(
                  widget.message,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.font14TextSecondaryRegularTajawal()
                      .copyWith(height: 1.6),
                ),
                verticalSpace(72),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: _ConfirmButton(
                        text: widget.confirmText,
                        isEnabled: !_isClosing,
                        onPressed: () {
                          _closeBottomSheet(true);
                        },
                      ),
                    ),
                    horizontalSpace(16),
                    Expanded(
                      child: _CancelButton(
                        text: widget.cancelText,
                        isEnabled: !_isClosing,
                        onPressed: () {
                          _closeBottomSheet(false);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _closeBottomSheet(bool result) {
    if (_isClosing || !mounted) {
      return;
    }

    setState(() {
      _isClosing = true;
    });

    final NavigatorState navigator = Navigator.of(context);

    if (!navigator.canPop()) {
      return;
    }

    navigator.pop<bool>(result);
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
  const _ConfirmButton({
    required this.text,
    required this.onPressed,
    required this.isEnabled,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ColorPalette.error,
          foregroundColor: ColorPalette.surface,
          disabledBackgroundColor: ColorPalette.error.withValues(alpha: 0.45),
          disabledForegroundColor: ColorPalette.surface.withValues(alpha: 0.65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.r),
          ),
        ),
        child: Text(text, style: AppTextStyle.font15SurfaceBoldTajawal()),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({
    required this.text,
    required this.onPressed,
    required this.isEnabled,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorPalette.primary,
          backgroundColor: ColorPalette.surface,
          disabledForegroundColor: ColorPalette.primary.withValues(alpha: 0.45),
          side: BorderSide(
            color: isEnabled
                ? ColorPalette.primary
                : ColorPalette.primary.withValues(alpha: 0.45),
            width: 1.4.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.r),
          ),
        ),
        child: Text(text, style: AppTextStyle.font15PrimaryBoldTajawal()),
      ),
    );
  }
}
