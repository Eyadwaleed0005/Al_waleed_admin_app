import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/features/live_session/domain/entities/live_session_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionDetailsCard extends StatelessWidget {
  const LiveSessionDetailsCard({
    super.key,
    required this.liveSession,
    required this.isDeleting,
    required this.onDelete,
  });

  final LiveSessionEntity liveSession;
  final bool isDeleting;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.textPrimary.withValues(alpha: 0.06),
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: ColorPalette.secondary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.videocam_outlined,
              color: ColorPalette.secondary,
              size: 31.sp,
            ),
          ),
          verticalSpace(18),
          Text(
            'رابط الحصة جاهز',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font18PrimarySemiBoldKufam(),
          ),
          verticalSpace(10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: ColorPalette.paleSage,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(
              'نشط الآن',
              style: AppTextStyle.font12PrimaryMediumTajawal(),
            ),
          ),
          verticalSpace(18),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: ColorPalette.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SelectableText(
              liveSession.meetingUrl,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: AppTextStyle.font13TextPrimaryMediumTajawal(),
            ),
          ),
          verticalSpace(14),
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: isDeleting ? null : onDelete,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: ColorPalette.error,
                foregroundColor: ColorPalette.surface,
                disabledBackgroundColor: ColorPalette.error.withValues(
                  alpha: 0.65,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.r),
                ),
              ),
              child: isDeleting
                  ? SizedBox(
                      width: 21.w,
                      height: 21.w,
                      child: CircularProgressIndicator(
                        color: ColorPalette.surface,
                        strokeWidth: 2.5.w,
                      ),
                    )
                  : Text(
                      'حذف الرابط',
                      style: AppTextStyle.font15SurfaceBoldTajawal(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
