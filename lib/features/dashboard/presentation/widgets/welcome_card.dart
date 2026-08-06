import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorPalette.deepSurface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: ColorPalette.highlight,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                'مدرس الكيمياء',
                textAlign: TextAlign.center,
                style: AppTextStyle.font12DeepSurfaceMediumTajawal(),
              ),
            ),
          ),

          verticalSpace(18),
          Text(
            'أهلاً أستاذ وليد',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font26HighlightBoldKufam(),
          ),

          verticalSpace(10),
          Text(
            'كل ما تحتاجه لإدارة طلابك ومحتواك من مكان واحد',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTextStyle.font13AccentRegularTajawal(),
          ),
        ],
      ),
    );
  }
}
