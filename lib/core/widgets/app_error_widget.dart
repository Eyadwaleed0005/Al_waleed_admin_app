import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double minimumHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : 0;

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minimumHeight),
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 420.h),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
                decoration: BoxDecoration(
                  color: ColorPalette.surface,
                  borderRadius: BorderRadius.circular(56.r),
                  border: Border.all(
                    color: ColorPalette.error.withValues(alpha: 0.45),
                    width: 1.5.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorPalette.error.withValues(alpha: 0.08),
                      blurRadius: 24.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        color: ColorPalette.error.withValues(alpha: 0.09),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 38.sp,
                        color: ColorPalette.error,
                      ),
                    ),

                    verticalSpace(28),

                    Text(
                      'حدث خطأ ما',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.font18PrimarySemiBoldKufam().copyWith(
                        color: ColorPalette.textPrimary,
                      ),
                    ),

                    verticalSpace(10),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.font14TextPrimaryRegularTajawal()
                            .copyWith(color: ColorPalette.textSecondary),
                      ),
                    ),

                    verticalSpace(30),

                    SizedBox(
                      width: 190.w,
                      height: 54.h,
                      child: ElevatedButton(
                        onPressed: onRetry,
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shadowColor: ColorPalette.error.withValues(
                            alpha: 0.30,
                          ),
                          backgroundColor: ColorPalette.error,
                          foregroundColor: ColorPalette.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                        ),
                        child: Text(
                          'أعد المحاولة',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.font15SurfaceBoldTajawal(),
                        ),
                      ),
                    ),
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
