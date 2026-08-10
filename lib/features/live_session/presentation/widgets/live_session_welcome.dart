import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionWelcome extends StatelessWidget {
  const LiveSessionWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorPalette.primaryDark,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: ColorPalette.paleSage,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                'جاهز',
                textAlign: TextAlign.center,
                style: AppTextStyle.font12PrimaryBoldTajawal(),
              ),
            ),
          ),
          verticalSpace(18),
          Text(
            'الحصة المباشرة',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font22SurfaceSemiBoldKufam(),
          ),
          verticalSpace(10),
          Text(
            'شارك رابط Zoom أو Google Meet مع طلاب الصف',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font13SurfaceRegularTajawal(),
          ),
        ],
      ),
    );
  }
}
