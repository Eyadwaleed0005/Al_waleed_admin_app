import 'dart:ui';

import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlurredOvalShadow extends StatelessWidget {
  const BlurredOvalShadow({
    super.key,
    this.translateY = -45,
  });

  final double translateY;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, translateY.h),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 60.r,
          sigmaY: 28.r,
          tileMode: TileMode.decal,
        ),
        child: Container(
          width: 270.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: ColorPalette.highlight.withValues(alpha: 0.22),
            borderRadius: BorderRadius.all(
              Radius.elliptical(
                220.w,
                22.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}