import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.color = ColorPalette.surface, 
    this.size = 18,
    this.strokeWidth = 3,
  });

  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.h,
      width: size.w,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth.w,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
