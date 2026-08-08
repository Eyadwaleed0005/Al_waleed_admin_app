import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onActionPressed,
    this.icon = Icons.person_outline_rounded,
  });

  final String title;
  final String message;
  final String? actionText;
  final IconData icon;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final bool hasAction = actionText != null && onActionPressed != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double minimumHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : 0;

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minimumHeight),
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 340.h),
                padding: EdgeInsets.fromLTRB(16.w, 34.h, 16.w, 20.h),
                decoration: BoxDecoration(
                  color: ColorPalette.surface,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24.r,
                      spreadRadius: 0,
                      offset: Offset(0, 8.h),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 84.w,
                      height: 84.h,
                      decoration: const BoxDecoration(
                        color: ColorPalette.primarySoftBackground,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        icon,
                        size: 42.sp,
                        color: ColorPalette.primary,
                      ),
                    ),

                    verticalSpace(22),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.font18PrimarySemiBoldKufam(),
                    ),

                    verticalSpace(10),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.font14TextPrimaryRegularTajawal(),
                      ),
                    ),

                    if (hasAction) ...[
                      verticalSpace(24),
                      CustomButton(
                        text: actionText!,
                        icon: Icons.add_rounded,
                        onPressed: onActionPressed!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
