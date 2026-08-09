import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewStudentExamsButton extends StatelessWidget {
  const ViewStudentExamsButton({
    super.key,
    this.onPressed,
    this.isEnabled = true,
  });

  final VoidCallback? onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'عرض امتحانات الطالب',
      child: Material(
        color: isEnabled
            ? ColorPalette.primary
            : ColorPalette.primary.withValues(alpha: 0.45),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: 54.w,
            child: Icon(
              Icons.assignment_rounded,
              color: ColorPalette.surface,
              size: 25.sp,
            ),
          ),
        ),
      ),
    );
  }
}
